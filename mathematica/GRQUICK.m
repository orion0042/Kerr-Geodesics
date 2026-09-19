(* ::Package:: *)

(* Author: Jaime Varela
Organization: University of California Berkeley *)

(* This package is used to calculate various expressions in 
general relativity in coordinate form.  The conventions used 
here follow S. Caroll. NOTE:  in the following
all indeces go from 0 to 3.*)

BeginPackage["GRQUICK`"]

(* This provides the usage of the functions *)
Metin::usage = "For a dxd matrix g and d dimensional vector vec, Metin[g,vec] sets the working Metric to g and the coordinates to vec (default {t,x,y,z}). One can also use default metrics by inputing certain strings.  For a list of metrics type ?DefaultMet"

DefaultMet::usage = "The load decault metrics use Metin[string] with one of the following strings\n\n
Schwar = Schwarchild metric with COORDINATES={t,r,\[Theta],\[Phi]} for a central mass of mass M;\n
FRW = Friedman walker metric with curvature k and coordinates {t,r,\[Theta],\[Phi]} and expansion function a[t];\n
Reissner = Charged black hole with total charge q;\n
Kerr = rotating black hole with total angular momentum J;\n
Kerr-Newman = charged rotating black hole with charge q and angular momentum J;\n
DS static = Static desitter coordinates {t,r,\[Theta],\[Phi]} with the cosmological horizon at r=\[Alpha] = \!\(\*SqrtBox[\(3/\[CapitalLambda]\)]\); \n
DS universe = Desitter universe with a[t]=\!\(\*SuperscriptBox[\(e\), \(H\\\ t\)]\) where H is the hubble constant;\n
DS-Schwar = De-sitter Schwarzchild metric where \[CapitalLambda] is the cosmological constant and M is the mass of the black hole.\n\n
Note: we use geometrical units in which G=c=1.  The metrics are taken from Wikipedia and I make no claim to their accuracy."


GINV::usage = "GINV, provides the inverse Metric in an array"

LoadMetric::usage = "Loads defaul metrics (internal use only)"

Metric::usage = "Metric[i,j] gives the ith jth component of the Metric"

IMetric::usage = "IMetric[i,j] gives the ith jth inverse component of the Metric"

Christoffel::usage = "Christoffel[{{i}, {j,k}}] provides (\!\(\*SuperscriptBox[\(\[CapitalGamma]\), \(i\)]\)\!\(\*SubscriptBox[\()\), \(jk\)]\)"

Riemann::usage = "Riemann[{{l},{i,j,k}}] = (\!\(\*SuperscriptBox[\(R\), \(l\)]\)\!\(\*SubscriptBox[\()\), \(ijk\)]\) or Riemann[i,j,k,l]=Riemann[{i,j,k,l}]=\!\(\*SubscriptBox[\(R\), \(ijkl\)]\)"

Ricci::usage = "The Ricci tensor Ricci[i,j] = \!\(\*SubscriptBox[\(R\), \(\(ij\)\(\\\\n\)\)]\)"

Rscalar::usage = "R = \!\(\*SubscriptBox[SuperscriptBox[\(R\), \(u\)], \(u\)]\)"

Einstein::usage = "Einstein[i,j] = \!\(\*SubscriptBox[\(R\), \(ij\)]\)"

(* The follwing functions do not yield expressions which 
are stored in memory *)

Geodesics::usage = "After the christofell symbols have been calculated, Geodesics[a], will display the geodesic equations x''[a\!\(\*SuperscriptBox[\(]\), \(i\)]\)+\!\(\*SubscriptBox[SuperscriptBox[\(\[CapitalGamma]\), \(i\)], \(jk\)]\) x'[a\!\(\*SuperscriptBox[\(]\), \(j\)]\) x'[a\!\(\*SuperscriptBox[\(]\), \(j\)]\) as a vector. "

Tenstr::usage = "Tenstr[TENSOR] will give the trace of a rank two lower index tensor. (Input is a string) For example Tenstr[Einstein] gives \!\(\*SubscriptBox[SuperscriptBox[\(G\), \(i\)], \(i\)]\) . Note Tenstr can only intake GRQUICK rank 2 tensors, not user defined tensors."

helpGRQUICK::usage = "To begin one must input a metric using Metin.  Type in ?Metin for usage.  For the usage of any function use ?function


Standard Differential Geometry objects are: Metric, IMetric, Christoffel,Riemann,
Weyl,Ricci,Rscalar,Einstein, Kretschmann, Metprod, Metnorm, Normalizevec, RaiseVector, LowerVector, and Setlight. 

Functions usefull for geodesic analysis are: Geodesics, Geoplot, Issol, ReplaceCoords


Functions which operate on tensore are: Coderv, and Tenstr.

Raychaudhuri functions are: SpatialMetric, BExpansion, ThetaExpansion, Shear, and Twist. 
The vector inputs to these function must be properly timelike normalized (I have not implemented a null formulation as of yet). For definitions 
see Wald's General Relativity text.


Important objects/tensors can be displayed using the commands: (GINV; GMET; DIM; COORDINATES)
,CHARRAY, GARRAY, RARRAY, RSARRAY, SPEEDOFLIGHT, and GEOSOL. 
These object are populated once the functions (Metin), Christoffel,
Einstein, Ricci, Rscalar, Setlight, and Geoplot have been computed respectively."

GMET::usage = "the Metric tensor"

CHARRAY::usage = "an array of Christofell symbols"

GARRAY::usage = "array of the einstein tensor"

RARRAY::usage = "array of the ricci tensor"

RSARRAY::usage = "array of the ricci tensor"

COORDINATES::usage = "the coordinate vector"

DIM::usage = "space-time dimension.  DIM-1 is the spatial dim"

SPEEDOFLIGHT::usage = "value of the speed of light (default c=1)"

setzero::usage = "to reset values"

constructnondummy::usage = "used for indeces"

Coderv::usage =  "Coderv[string,{{indtop},{indbot}},a] results in the 
ath covariant derivative of the tensor string that has the 
index structure {{indtop},{indbot}}. For example Coderv[Ricci,{1,2},0] the 0th covariant derivative
of R_{12}";

Setlight::usage = "Setlight[val] will set the numerical speed of light
to be c=val (default c=1).  This is needed for numerical functions"

Geoplot::usage = "Geoplot[t,init,vinit,range,plotvars] uses NDSOLVE to 
plot the timelike (or null) Geodesics for a system with parameter 
t, an initial position vector (init), an initial four velocity (vinit), 
and a two-vector range={ti,tf} specifying the range.  The four 
velocity must be properly normalized and the initial conditions are for
t=ti. (remember to change the value to the speed of light to reflect the units
in your Metric)."

GEOSOL::usage = "after Geoplot has been called once, GEOSOL contains the 
interpolation solutions to the previous Geoplot call."

Metnorm::usage = "given a CONTRAVARIANT vector, Metnorm[vec] gives its norm, namely g_{i,j} vec^i vec^j"

Metprod::usage = "product of two CONTRAVARIANT vectors, Metprod[vec1,vec2] 
gives the scalar product in curved spacetime, namely vec1^i g_{i,j} vec2^j."

Normalizevec::usage = "Normalizevec[X], for any D-dimensional array it
returns a normalize vector X/Sqrt[-Metprod[X]]"

Ricciint::usage = "for programs use only, used as an intermediate Ricci tensor"

Einsint::usage = "for programs use only, used as an intermediate Einstein"

Issol::usage = "Issol[x[\[Tau]],\[Tau]] will give True if the four vector x[\[Tau]] is a solution to the geodesic equations and False otherwise. Issol may also give an expression which must be zero for \!\(\*SuperscriptBox[\(x\), \(\[Mu]\)]\) to be a geodesic"

ReplaceCoords::usage = "ReplaceCoords[exp,coords] replaces the default coordinates (COORDINATES) to thos specified in coords."

RaiseVector::usage = "Give an vector X={x0,x1,...}, RaiseVector[X] will treat X as covariant vector and return the contravariant vector"

LowerVector::usage = "Give an vector X={x0,x1,...}, RaiseVector[X] will treat X as contravariant vector and return the covariant vector"

SpatialMetric::usage = "SpatialMetric[{\[Mu],\[Nu]},{\!\(\*SubscriptBox[\(\[Zeta]\), \(0\)]\),\!\(\*SubscriptBox[\(\[Zeta]\), \(1\)]\),\!\(\*SubscriptBox[\(\[Zeta]\), \(2\)]\),...}] gives \!\(\*SubscriptBox[\(h\), \(\[Mu]\[Nu]\)]\)=\!\(\*SubscriptBox[\(g\), \(\[Mu]\[Nu]\)]\)+\!\(\*SubscriptBox[\(\[Zeta]\), \(\[Mu]\)]\)\!\(\*SubscriptBox[\(\[Zeta]\), \(\[Nu]\)]\)"

BExpansion::usage = "BExpansion[{\[Mu],\[Nu]},{\!\(\*SubscriptBox[\(\[Zeta]\), \(0\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(1\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(2\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(3\)]\)(x)}] give \!\(\*SubscriptBox[\(B\), \(\[Mu]\[Nu]\)]\)=\!\(\*SubscriptBox[\(\[Del]\), \(\[Nu]\)]\)\!\(\*SubscriptBox[\(\[Zeta]\), \(\[Mu]\)]\)"

ThetaExpansion::usage = "ThetaExpansion[{\!\(\*SubscriptBox[\(\[Zeta]\), \(0\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(1\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(2\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(3\)]\)(x)}] gives the Raychauduri scalar \[Theta]"

Shear::usage = "Shear[{\[Mu],\[Nu]},{\!\(\*SubscriptBox[\(\[Zeta]\), \(0\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(1\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(2\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(3\)]\)(x)}] gives \!\(\*SubscriptBox[\(\[Sigma]\), \(\[Mu]\[Nu]\)]\)=\!\(\*SubscriptBox[\(B\), \([a\\\ b]\)]\)- \!\(\*FractionBox[\(1\), \(3\)]\)\[Theta] \!\(\*SubscriptBox[\(h\), \(\[Mu]\[Nu]\)]\)"


Twist::usage = "Twist[{\[Mu],\[Nu]},{\!\(\*SubscriptBox[\(\[Zeta]\), \(0\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(1\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(2\)]\)(x),\!\(\*SubscriptBox[\(\[Zeta]\), \(3\)]\)(x)}] gives \!\(\*SubscriptBox[\(\[Omega]\), \(\[Mu]\[Nu]\)]\)=\!\(\*SubscriptBox[\(B\), \([a\\\ b]\)]\)"

Kretschmann::usage = "Kretschmann invariant"

Weyl::usage = "The Weyl tensor given as defined in Carrol is given by Weyl[ijkl]=Weyl[{ijkl}]= \!\(\*SubscriptBox[\(C\), \(ijkl\)]\)"





Begin["Global`"]
LoadMetric[met_]:=Block[{g,v},
g=101;
v=0;
Switch[met, 
"Schwar", 
{g=DiagonalMatrix[{-(1-(2 M/r)),1/(1-(2 M/r)),r*r, r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"FRW",
{g=DiagonalMatrix[{-1,a[t]^2/(1-k r^2),a[t]^2 r^2,a[t]^2 r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"DS static",
{g=DiagonalMatrix[{-(1-r^2/\[Alpha]^2),1/(1-r^2/\[Alpha]^2),r^2,r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"DS universe",
{g=DiagonalMatrix[{-1,Exp[H t]^2/(1-k r^2),Exp[H t]^2 r^2,Exp[H t]^2 r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"DS-Schwar",
{g=DiagonalMatrix[{-(1-( \[CapitalLambda] r^2)/3-(2 M)/r),1/(1-( \[CapitalLambda] r^2)/3-(2 M)/r),r^2,r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"Reissner",
{g=DiagonalMatrix[{-(1-(2 M)/r+q^2/r^2),1/(1-(2 M)/r+q^2/r^2),r^2,r^2 Sin[\[Theta]]^2}]
;v={t,r,\[Theta],\[Phi]}}
,"Kerr",
{g= {{-1+(2 M r)/(r^2+(J^2 Cos[\[Theta]]^2)/M^2),0,0,-((2 J r Sin[\[Theta]]^2)/(r^2+(J^2 Cos[\[Theta]]^2)/M^2))},{0,(M^2 r^2+J^2 Cos[\[Theta]]^2)/(J^2+M^2 r (-2 M+r)),0,0},
{0,0,r^2+(J^2 Cos[\[Theta]]^2)/M^2,0},
{-((2 J r Sin[\[Theta]]^2)/(r^2+(J^2 Cos[\[Theta]]^2)/M^2)),0,0,Sin[\[Theta]]^2 (J^2/M^2+r^2+(2 J^2 M r Sin[\[Theta]]^2)/(M^2 r^2+J^2 Cos[\[Theta]]^2))}}
;v={t,r,\[Theta],\[Phi]}}
,"Kerr-Newman",
{g= {{-1+(2 M^2 (-q^2+2 M r))/(J^2+2 M^2 r^2+J^2 Cos[2 \[Theta]]),0,0,(J M (q^2-2 M r) Sin[\[Theta]]^2)/(M^2 r^2+J^2 Cos[\[Theta]]^2)},
{0,(r^2+(J^2 Cos[\[Theta]]^2)/M^2)/(J^2/M^2+q^2+r (-2 M+r)),0,0},{0,0,r^2+(J^2 Cos[\[Theta]]^2)/M^2,0},
{(J M (q^2-2 M r) Sin[\[Theta]]^2)/(M^2 r^2+J^2 Cos[\[Theta]]^2),0,0,(Sin[\[Theta]]^2 ((J^2+M^2 r^2)^2-J^2 (J^2+M^2 (q^2-2 M r+r^2)) Sin[\[Theta]]^2))/(M^4 r^2+J^2 M^2 Cos[\[Theta]]^2)}}
;v={t,r,\[Theta],\[Phi]}}
];

If[g==101,Return[{"Not a default metric","Not a default metric"}]];
Return[{g,v}];
]
End[]

Begin["`Private`"]



(*The program sets GMET as a global matrix *)
(*Default GMET = diag(-1,1,1,1) *)


GMET = {{-1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}};

GINV= {{-1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}};

(*Default tensor arrays which will 
store expressions for later use*)
CHARRAY = 0;
RARRAY = 0;
RSARRAY = Null;
GARRAY = 0;
COORDINATES = {t,x,y,z};
DIM=4;
(*Sets the global coordinates*)




(** The functions **)

(*Resets default values*)
setzero[a_]:=Block[{},
CHARRAY = 0;
RARRAY = 0;
RSARRAY = Null;
GARRAY = 0;
SPEEDOFLIGHT=1;
Return[Print["Metric Success"]];
]



(*Inputs the Metric and coordinates*)
Metin[gin__]:= Block[{g,V,vec},
vec={gin};
If[StringQ[vec[[1]]]==False,
g=vec[[1]];
V=vec[[2]];,
g=LoadMetric[vec[[1]]][[1]];
V=LoadMetric[vec[[1]]][[2]];
];
DIM = Length[V];
(*If[StringQ[g]==True,Return[g]];*)
If[Transpose[g]-g != IdentityMatrix[DIM]-IdentityMatrix[DIM], 
Return[Print["Invalid Metric"]],
GMET = g;
GINV=Simplify[Inverse[GMET]];
COORDINATES = V;
DIM = Length[COORDINATES];
setzero[0];
]]


Metric[i_,j_]:=Return[GMET[[i+1,j+1]]]

IMetric[i_,j_]:= Return[GINV[[i+1,j+1]]]

Metnorm[vec_]:= Sum[vec[[ii]] Metric[ii-1,jj-1] vec[[jj]],
{ii,1,DIM},{jj,1,DIM}]

Metprod[vec1_,vec2_]:= Sum[vec1[[ii]] Metric[ii-1,jj-1] vec2[[jj]],
{ii,1,DIM},{jj,1,DIM}]


Normalizevec[vec_]:= Block[{a},
If[Length[vec] != Length[COORDINATES], Print["Vector is of incorrect size"]];
Return[vec/Sqrt[-Metnorm[vec]]];
]



Christoffel[{{i_},{k_,l_}}]:=Block[{exp},
If[Length[CHARRAY] !=0, exp = CHARRAY[[i+1]][[k+1,l+1]],
(*populates the CHARRAY if this has not been done*)
CHARRAY = Table[Table[Simplify[(1/2) Sum[(GINV[[is,var]])
(D[GMET[[var,ks]],COORDINATES[[ls]]]
 + D[GMET[[var,ls]],COORDINATES[[ks]]]
+-D[GMET[[ks,ls]],COORDINATES[[var]]]),
{var,1,Length[COORDINATES]}]],
{ks,1,Length[COORDINATES]},
{ls,1,Length[COORDINATES]}],
{is,1, Length[COORDINATES]}];
exp = CHARRAY[[i+1]][[k+1,l+1]];
];
Return[exp]
]

Riemann[ind__]:= Block[{vec,l,i,j,k},
vec= Quiet[Check[Length[ind]*ind,4{ind}]];
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];
If[Length[vec]==2,
vec=vec/2;
{l=vec[[1]][[1]],i=vec[[2]][[1]],j=vec[[2]][[2]],k=vec[[2]][[3]]};
Return[
Simplify[
D[(CHARRAY[[l+1]][[i+1,k+1]]),COORDINATES[[j+1]] ]
-D[(CHARRAY[[l+1]][[i+1,j+1]]),COORDINATES[[k+1]] ]
+Sum[(CHARRAY[[l+1]][[j+1,ss]]) (CHARRAY[[ss]][[i+1,k+1]])
,{ss,1 Length[COORDINATES]}]
-Sum[(CHARRAY[[l+1]][[k+1,ss]]) (CHARRAY[[ss]][[i+1,j+1]])
,{ss,1 Length[COORDINATES]}]
]
]
,
vec=vec/4;
{l=vec[[1]],i=vec[[2]],j=vec[[3]],k=vec[[4]]};
Return[
Simplify[1/2 (D[Metric[l,k],COORDINATES[[i+1]],COORDINATES[[j+1]]]+D[Metric[i,j],COORDINATES[[l+1]],COORDINATES[[k+1]]]
-D[Metric[l,j],COORDINATES[[i+1]],COORDINATES[[k+1]]]-D[Metric[i,k],COORDINATES[[l+1]],COORDINATES[[j+1]]])+
Sum[Metric[nn,pp](Christoffel[{{nn},{i,j}}]Christoffel[{{pp},{l,k}}]-Christoffel[{{nn},{i,k}}]Christoffel[{{pp},{l,j}}])
,{nn,0,Length[COORDINATES]-1},{pp,0, Length[COORDINATES]-1}]
]
]
]]




Ricciint[i_,j_]:= Block[{sexp}, 
If[Length[RARRAY]==0,
RARRAY = Table[Simplify[
Sum[Riemann[{{ls}, {is, ls, js}}],{ls,0,DIM-1}]]
,{is,0,DIM-1},{js,0,DIM-1}];
];
sexp = RARRAY[[i+1,j+1]];
Return[sexp]
]

Ricci[m__]:=Block[{check},
check = Quiet[Check[0*(m[[1]]+m[[2]]),1]];
If[check==0, Return[Ricciint[m[[1]],m[[2]]] ]
,Return[Ricciint[m]] ]
]


Rscalar:=Block[{},
If[Length[RARRAY]==0, Ricci[0,0]];
If[RSARRAY==Null ,RSARRAY = Simplify[Tr[GINV.RARRAY]]];
Return[RSARRAY]]

Einsint[i_,j_]:=Block[{},
If[Length[RARRAY]==0,Ricci[0,0]];
If[Length[GARRAY]==0, 
GARRAY = Simplify[RARRAY - (Rscalar/2) GMET ]];
Return[GARRAY[[i+1,j+1]]]
]


Einstein[m__]:=Block[{check},
check = Quiet[Check[0*(m[[1]]+m[[2]]),1]];
If[check==0, Return[Einsint[m[[1]],m[[2]]] ]
,Return[Einsint[m]] ]
]


Weyl[ind__]:= Block[{vec,i,k,l,m},
vec= Quiet[Check[Length[ind]*ind,4{ind}]];
vec=vec/4;
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];
{i=vec[[1]],k=vec[[2]],l=vec[[3]],m=vec[[4]]};
Return[Riemann[{i,k,l,m}]+
(1/(DIM-2))(-Ricci[{i,l}] Metric[k,m]+Ricci[i,m] Metric[k,l]+Ricci[k,l] Metric[i,m]-Ricci[k,m] Metric[i,l])
+Rscalar/((DIM-1)(DIM-2)) (Metric[i,l]Metric[k,m]-Metric[i,m]Metric[k,l])]
]


Coderv[expi_,ind_,a_]:=Block[
{topi,boti,p,q,rank,dummy,codv,int,indvec,inter,interind,vector,exp,derv,codvp,codvq},
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];

If[StringQ[expi]==False && Length[expi]==0, exp=ToString[expi],exp=expi];

If[Length[ind[[1]] ]==0,topi=0,topi=ind[[1]]+1];
If[Length[topi]==0,boti=ind+1,boti=ind[[2]]+1];
If[Length[topi]==0,p=0,p=Length[topi]];
q= Length[boti];
rank = p+q;
(*vectors*)
If[rank==1 && StringQ[exp]==True, 
vector= Table[ToExpression[exp][ii],{ii,0,DIM-1}];
derv = ToExpression[exp][Switch[Length[ind[[1]]],0,ind[[1]],1,ind[[1]][[1]] ] ] ];

If[rank==1 && Length[exp]>0,
vector=exp;
derv = exp[[Switch[Length[ind[[1]]],0,ind[[1]]+1,1,ind[[1]][[1]]+1]]] ];

If[rank==1 && q>0,
Return[D[derv,COORDINATES[[a+1]]]
-Sum[CHARRAY[[dummy+1]][[a+1,ind[[1]]+1]]
(vector[[dummy+1]]),{dummy,0,DIM-1}]]];

If[rank==1 && p>0,
interind=ind[[1]][[1]];
Return[D[derv,COORDINATES[[a+1]]]
+Sum[CHARRAY[[interind+1]][[a+1,dummy+1]]
(vector[[dummy+1]]),{dummy,0,DIM-1}]]
];


(*tensors*)
indvec=ind;
codvp=If[p>0,Table[0,{k,1,p}],{0}];
codvq=If[q>0,Table[0,{k,1,q}],{0}];
If[p>0.1,
For[int=1,int<p+1,int++,
indvec=ind;
indvec[[1]][[int]]=dummy;
codvp[[int]] = Evaluate[Sum[CHARRAY[[ topi[[int]] ]][[a+1,dummy+1]] 
(ToExpression[exp][indvec])
,{dummy,0,DIM-1}]];
]];


If[q>0,
For[int=1,int<q+1,int++,
indvec=ind;
If[p>0,indvec[[2]][[int]]=dummy, indvec[[int]]=dummy];
codvq[[int]] = Evaluate[-(Sum[CHARRAY[[ dummy+1 ]][[a+1,boti[[int]] ]] 
(ToExpression[exp][indvec])
,{dummy,0,DIM-1}])];

]];
Return[Sum[codvp[[kk]],{kk,1,If[p>0,p,1]}] +Sum[codvq[[kk]],{kk,1,If[q>0,q,1]}] + 
D[ToExpression[exp][ind],COORDINATES[[a+1]]] ]

]


Geodesics[a_]:= Block[{v,int},
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];

v=Table[0,{int,1,DIM}];
Clear[int];
For[int=1,int < Length[COORDINATES]+1, int++,
v[[int]]=COORDINATES[[int]][a] ];
Table[D[v[[ss]],a,a]
+ Sum[ 
(CHARRAY[[ss]][[kk,tt]]/.Table[COORDINATES[[yy]]->v[[yy]],{yy,1,Length[COORDINATES]}])
D[v[[kk]],a] D[v[[tt]],a],{kk,1,Length[COORDINATES]},{tt,1,Length[COORDINATES]}],{ss,1,Length[COORDINATES]}]
]


Issol[vi_,s_]:=Block[{v,vec,val,dvec,ddvec,eqs,int,epss},
(*TODO: Make more efficient*)
(*We add a variable in the chanche there is an 1/r infinity*)
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];

v=vi+epss;
vec=Geodesics[s];
dvec=D[v,s];
ddvec=D[v,s,s];
eqs=Table[10,{kk,1,DIM}];
For[int=1,int<DIM+1,int++,
eqs[[int]] = Limit[Evaluate[FullSimplify[((vec[[int]]/.Table[COORDINATES[[ss]][s]->v[[ss]],{ss,1,DIM}])/.Table[
COORDINATES[[ss]]'[s]->dvec[[ss]],{ss,1,DIM}])/.Table[
COORDINATES[[ss]]''[s]->ddvec[[ss]],{ss,1,DIM}]]],epss->0] ];
val=Sum[eqs[[ii]]^2,{ii,1,DIM}];
If[val==0,Return[True],If[val==Infinity || val ==-Infinity,Print["Check wether initial point is well defined in this coordinate system"],Return[False],val],val]
]


ReplaceCoords[exp__,coords_]:=Block[{point,epss},
point=coords+epss;
Return[Limit[exp/.Table[COORDINATES[[ss]]->point[[ss]],{ss,1,DIM}],epss->0]];
]

Tenstr[text_]:= Sum[IMetric[ii,jj] ToExpression[text][jj,ii],
{ii,0,DIM-1},{jj,0,DIM-1}]

Setlight[val_]:=Block[{},SPEEDOFLIGHT=val;Return[val]]


Geoplot[param_,init_,vini_,range_,plotvars_]:=Block[
{invec,vinvec,eqvec,eqvec2,parv,epsi,checknum,eqsol,vinit,ti},
If[Length[CHARRAY]==0, Christoffel[{{0},{0,0}}]];

vinit=Join[{0},Table[vini[[kk]],{kk,2,DIM}]];

If[StringQ[vini[[1]]]==True,
eqsol=Solve[
((Metnorm[Join[{a},Table[vinit[[ii]],{ii,2,DIM}] ]])/.Table[
COORDINATES[[ii]]-> init[[ii]],{ii,1,DIM}])
==-SPEEDOFLIGHT^2,a];
If[vini[[1]]=="Max", vinit[[1]]= Max[a/.eqsol],
vinit[[1]]=Min[a/.eqsol]];
, vinit=vini;];


ti=range[[1]];
checknum = Simplify[(Metnorm[vinit])/.Table[
COORDINATES[[ii]]-> init[[ii]],{ii,1,DIM}]];
(*The strange looking conditions are meant to allow the
normalization to be correct within accuracy*)
If[ (Abs[checknum] < Min[10^-10,(10^-10)*SPEEDOFLIGHT^2]) || (-SPEEDOFLIGHT^2*(1+10^-10) < checknum <-SPEEDOFLIGHT^2*(1-10^-10)),
epsi=10^-20;
eqvec = Simplify[Geodesics[param]];
eqvec2 = Table[eqvec[[ii]] == 0,{ii,1, Length[eqvec]}];
parv = Join[{param},range];
(*The use of epsi avoids numerical issues (TODO:find a better way to deal with numerical issues) *)
invec = Table[COORDINATES[[ii]][ti]==init[[ii]]+epsi,{ii,1,Length[eqvec]}];
vinvec= Table[COORDINATES[[ii]]'[ti]==vinit[[ii]],{ii,1,Length[eqvec]}];
GEOSOL = NDSolve[Evaluate[Join[eqvec2,invec,vinvec],COORDINATES,parv]];
Return[
Table[Plot[Evaluate[plotvars[[ii]][param]/.GEOSOL],{param,range[[1]],range[[2]]},
AxesLabel->{param,plotvars[[ii]][param]}]
,{ii,1,Length[plotvars]}]]
,Print["Invalid timelike or null normilazation, 
or divergent Metric at initial point."]]
]



RaiseVector[vec_]:=Return[GINV.vec]

LowerVector[vec_]:=Return[GMET.vec]

SpatialMetric[ind_,vec_]:=Return[Metric[ind[[1]],ind[[2]]]+vec[[ind[[1]]+1]]vec[[ind[[2]]+1]]]


BExpansion[{aa_,bb_},vec_]:=Return[Coderv[vec,{aa},bb]]

ThetaExpansion[vec_]:=Return[Sum[IMetric[aa,bb] IMetric[cc,dd] BExpansion[{bb,dd},vec] SpatialMetric[{aa,cc},vec],{aa,0,DIM-1},{bb,0,DIM-1},{cc,0,DIM-1},{dd,0,DIM-1}]
]

Shear[{aa_,bb_},vec_]:=Block[{},
Return[1/2 (BExpansion[{aa,bb},vec]+BExpansion[{bb,aa},vec])-(1/3)ThetaExpansion[vec] SpatialMetric[{aa,bb},vec]]
]

Twist[{aa_,bb_},vec_]:=Return[1/2 (BExpansion[{aa,bb},vec]-BExpansion[{bb,aa},vec])]


Kretschmann:=Return[Sum[(Metric[aa,bb] Riemann[{{bb},{cc,dd,ee}}])(IMetric[cc,ff] IMetric[dd,gg] IMetric[ee,hh] Riemann[{{aa},{ff,gg,hh}}])
,{aa,0,DIM-1},{bb,0,DIM-1},{cc,0,DIM-1},{dd,0,DIM-1},{ee,0,DIM-1},{ff,0,DIM-1},{gg,0,DIM-1},{hh,0,DIM-1}]]




helpGRQUICK:= Print[ "The available functions are Metin, Metric, IMetric, Christoffel,Riemann,
Ricci,Rscalar,Einstein,Metprod, Metnorm, Normalizevec, RaiseVector, LowerVector, SpatialMetric and Setlight. 


After the Christoffel symbols have been computed at least once,
the set of functions Coderv, Geodesics, Geoplot, Issol, ReplaceCoords, and Tenstr become available.

Important objects/tensors can be displayed using the commands, (GINV; GMET; DIM; COORDINATES)
,CHARRAY, GARRAY, RARRAY, RSARRAY, SPEEDOFLIGHT, and GEOSOL. 
These object are populated once the functions (Metin), Christoffel,
Einstein, Ricci, Rscalar, Setlight, and Geoplot have been computed respectively."]


DefaultMet:=Print["Type ?DefaultMet to get a list of metrics"]


End[]                                                                           
                                                                                
EndPackage[]                                                                    
    
                                                                            
Print["The convention for this program follow Sean M. Carroll's (Spacetime and Geometry) and the indices run from 0 
to D-1.

While working do not use the variables GARRAY,RARRAY,RsARRAY, CHARRAY, SPEEDOFLIGHT.  

Type ?helpGRQUICK for a list of functions or ?Function for a function description.

More functions and improvements coming soon!!"']




