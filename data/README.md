# Reference data

These files come from full 8-dimensional Hamiltonian integration
(proper-time evolution with Christoffel symbols, converted to Mino time via
`dtau_m/dtau = 1/Sigma`).

All files are whitespace-separated plain text, readable with
`Import[..., "Table"]` or `numpy.loadtxt`.

---

## `DATA_CARTER.dat` — 27 MB

Two columns: **Mino time `lambda`**, **Carter-like constant `K(lambda)`**.

- 1,009,999 rows, uniform spacing 0.001, covering `lambda` from 0 to 1009.998
- `K` ranges over 9.4103 to 9.5314
- `K(0) = 9.5110420912`

This is the driving data for the solver. `K` oscillates because the system is
non-integrable at `O(eps^2)`; it is *not* an inspiral, so the energy and angular momentum
are genuinely constant for this run.

The notebook subsamples every 10th row and interpolates. Note that
`Interpolation[..., InterpolationOrder -> 10]` on the full ~1e6 points **fails silently** —
`Kfun'` then returns `Kfun` itself, giving `Kdot ~ 9.5` where slopes of `~1e-4` belong. The
notebook prints an off-node `Kdot` value as a guard against this.

---

## `reference_r.dat`, `reference_th.dat` — 5.3 MB each

Two columns each: **Mino time `lambda`**, and **`r`** / **`theta`** respectively.

- 150,000 rows, spacing 1.23e-3, covering `lambda` from 0 to about 1105
- Subsampled by a factor of 20 from the original 3,000,000-row files

The subsampling was verified against the full-resolution interpolation at off-node points.
Testing at round values such as `lambda = 0, 100, 200` gives exact zeros, since those are
nodes of both interpolations — any check must be done off-node.

Both files are from the same run.

---

## `Poincare_Mino.dat` — 35 KB

Three columns: **Mino time**, **`r`**, **`p_r`**.

Exported as `Transpose[{Inmtime, Intr1, Inpr}]` where `Inpr` interpolates
`pr = PR[tau] = PU[1] = dr/dtau`.

**That third column is `U^r = v_r / Sigma`, contravariant** — not the canonical
`p_r = v_r / Delta`. At the section `theta = pi/2`, so `Sigma = r^2` and the comparison
quantity is `v_r / r^2`. The two differ by `Sigma/Delta = 1.052` at `r = 40.323`, which is
large enough to be visible and small enough to look like a small bug rather than a wrong
formula.

**Crossing condition:** `theta` crosses `pi/2` with `thetadot > 0`, then linear
interpolation in `theta` for `lambda`, `r`, and `p_r`.

**Islands:** the rotation number is 2/3, giving a period-3 map and three islands. Take
every third crossing at three phase offsets. The crossings cycle
perihelion → perihelion → aphelion, so islands 1 and 2 sit at `r ~ 5.4-5.9` and island 3 at
`r ~ 39-40`; their axis ranges differ by an order of magnitude, which is genuine structure
rather than a plotting artifact. If two datasets' islands do not line up, shift one by a
single crossing before concluding they disagree — the sequences may start on different
phases of the period-3 cycle.
