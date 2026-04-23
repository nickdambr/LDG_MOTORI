(* ::Package:: *)

(* ::Title:: *)
(*MODULES MAIN*)


(* ::Text:: *)
(*Version 2.3.1 (Feb 2025)*)
(*Credits: Mauro Valorani, RIccardo Malpica Galassi, Pietro Paolo Ciottoli*)
(*Special thanks to: Roberto Forte, Daniel D'Onghia, Matteo Buscicchio, Giovanni Pappalardi, Francesco Grani*)


(* ::Section:: *)
(*Initialization*)


SetDirectory[NotebookDirectory[]]
NiccoPythonExe="C:\\ProgramData\\anaconda3\\envs\\ct-env\\python.exe";
ElisaPythonExe="C:\\Users\\Elisa\\anaconda3\\envs\\ct-env\\python.exe";
FlacoPythonExe="/Users/Francesco Daniele/opt/anaconda3/envs/cantera-env/bin/python";
pythonExe=NiccoPythonExe;


BeginPackage["ModulesForAircraftEngine`",{"Units`"}]

(*ISA*)
zzz::usage = "zzz[h] computes geopotential altitude";
iii::usage ="";
Tstd::usage = " T[h] computes ISA temperature at altitude h ";
Tstd1::usage="";
Tstd2::usage="";
Tstd3::usage="";
\[Theta]std::usage = " \[Theta][h] computes dimensionless ISA temperature at altitude h ";
\[Theta]Std1::usage="";
\[Theta]Std2::usage="";
\[Theta]Std3::usage="";
pstd::usage = " p[h] computes ISA pressure at altitude h ";
\[Delta]std::usage = " \[Delta][h] computes dimensionless ISA pressure at altitude h ";
\[Rho]std::usage = " \[Rho][h,\[CapitalDelta]T] computes ISA density at altitude h, allowing for T deviations from ISA ";
\[Rho]std1::usage="";
\[Rho]std2::usage="";
\[Rho]std3::usage"";
\[Theta]func::usage="";
\[Theta]0func::usage"";
\[Sigma]func::usage"";
\[Rho]func::usage"";
\[Rho]funcSLUG::usage"";
\[Theta]0std::usage = " \[Theta][h,M] computes dimensionless freestream total temperature at altitude h and Mach M";
\[Delta]0std::usage = " \[Delta][h,M] computes dimensionless freestream total pressure at altitude h and Mach M ";
\[Theta]0std1::usage="";
\[Theta]0std2::usage="";
\[Theta]0std3::usage="";
\[Rho]::usage="";
s::usage="";


(*Mission*)

cd0::usage = "";
k1::usage = "";
k2::usage = "";
ki::usage="";
\[Alpha]TF::usage = "";
\[Alpha]LTFmax::usage = "";
\[Alpha]LTFmil::usage = "";
\[Alpha]TJmax::usage = "";
\[Alpha]TJmil::usage = "";
\[Alpha]1::usage = "";
\[Alpha]2::usage = "";
\[Alpha]3::usage = "";
\[Alpha]4::usage = "";
\[Alpha]5::usage = "";
\[Alpha]6::usage = "";
\[Alpha]7::usage = "";
\[Alpha]8::usage = "";
\[Alpha]9::usage = "";
\[Alpha]10::usage = "";
\[Alpha]4h1::usage = "";
\[Alpha]LTFmaxh1::usage = "";
\[Alpha]4h2::usage = "";
\[Alpha]LTFmaxh2::usage = "";
\[Alpha]4h3::usage = "";
\[Alpha]LTFmaxh3::usage = "";
\[Alpha]3func::usage = "";
\[Alpha]4func::usage = "";
\[Alpha]LTFmaxFUNC::usage = "";
\[Alpha]6h1::usage = "";
\[Alpha]LTFmilh1::usage = "";
\[Alpha]6h2::usage = "";
\[Alpha]LTFmilh2::usage = "";
\[Alpha]6h3::usage = "";
\[Alpha]LTFmilh3::usage = "";
\[Alpha]5func::usage = "";
\[Alpha]6func::usage = "";
\[Alpha]LTFmilFUNC::usage = "";


(*Engine*)
MFP::usage="";
mredPar::usage="";
mred::usage="";
FreeStream::usage="Restituisce le variabili di stato nella condizione di Flusso Indisturbato";
DiffuserCompression::usage="Restituisce le variabili di stato all'uscita del Diffusore";
CompressorCompression::usage="Restituisce le variabili di stato all'uscita del Compressore";
BurnerCombustion::usage="Restituisce le variabili di stato all'uscita del Combustore";
BurnerCombustionCantera::usage="Restituisce le variabili di stato all'uscita del Combustore usando Cantera";
BurnerCombustionInterpolation::usage="Restituisce le variabili di stato all'uscita del Combustore usando l'interpolazione";
EmissionCombustion::usage="Importa le emissioni da python";
TurbineExpansionHPT::usage="Restituisce le variabili di stato all'uscita della Turbina HPT";
TurbineExpansionLPT::usage="Restituisce le variabili di stato all'uscita della Turbina LPT";
TurbineExpansionLPTiterativo::usage="Restituisce le variabili di stato all'uscita della Turbina LPT nel caso iterativo";
CalcoloIterativo\[Beta]f::usage="Restituisce \[Beta]f in forma iterativa";
MixerMiscelation::usage="Restituisce le variabili di stato all'uscita del Miscelatore";
AfterBurnerCombustion::usage="Restituisce le variabili di stato all'uscita del PostBruciatore";
NozzleExpansion::usage="Restituisce le variabili di stato all'uscita dell'Ugello";
CalcTurbojetCycle::usage="Restituisce le variabili di stato e le prestazioni di un Turbogetto";
CalcTurboFanCycle::usage="Restituisce le variabili di stato e le prestazioni di un TurboFan a flussi associati con AB";
PRatioComp::usage=""
getEqns::usage=""
BuildEngine::usage=""
testOffDesignEquiPoint::usage=""
calcOffDesignEquiPoint::usage=""
rulet::usage=""
Test::usage=""
DiffuserOutlet::usage""
PsiMap::usage""
cp::usage""
importDataPy::usage=""
pointsTablePy::usage=""
fData::usage=""
cpBData::usage=""
fFun::usage=""
cpBFun::usage=""
multistageCompressorState::usage""
stageSizingAlongMeanPathLine::usage""
StagePerformanceAtOnePathLine::usage""
StaticPropertiesAcrossStage::usage""
StagePerformance::usage""
StageReducedProperties::usage""
AnnulusGeometry::usage""
InnerStage::usage""
FirstStage::usage""
SizeTurbineStage::usage""
SmartSizeTurbineStage::usage""
SizeTurbine::usage""
p0F::usage""
T0F::usage""
TF::usage""
pF::usage""
T0ratio::usage""
p0ratio::usage""
multistageCompressorMap::usage""
PlotCompressorMap::usage""
PRatioMultistageCompressor::usage""
findCompressorStabilityBoundary::usage""
\[Epsilon]::usage""
mredIntake::usage""
mredTurbine::usage""
PratioCrit::usage""
MakeOffDesignStates::usage""
plotCompressorMapFromFile::usage""
plotPoint::usage""
Deg2Rad::usage"";
Rad2Deg::usage"";
printEqns::usage""
runCantera::usage="Richiama il foglio py di Cantera"
SecantMethod::usage="Metodo delle secanti per trovare rapporto di equivalenza \[Phi]"


(*Compressor*)
triangleDesignFromEqns::usage = " Solves velocity triangle equations and return a plot";
triangleDesign::usage = " Solves velocity triangle equations starting from figures of merit and return a plot";
triangleDesignUpdated::usage="Risolve il triangolo di velocit\[AGrave] aggiornato";
estimateNofStages::usage = ""
estimateNofStagesAdvanced::usage = ""
designMultiStageCompressor::usage = ""
nicePlotFromDB::usage = ""
drawCompressor::usage = ""
extractPropertyAlongCompressor::usage = ""
designFullCompressorUpdated::usage="Progettazione compressore";
wheelSpeedDesign::usage="Calcola velocit\[AGrave] angolare e altro";
annulusDesign::usage="Dimensionamento sezione anulare mozzo";
plotTriangle::usage="Grafica il triangolo delle velocit\[AGrave]";
runTriangleDesign::usage="Aggiornamento del triangle design in cui si utilizza py";
collectCompressorGeometries::usage="Calcola grandezze principali del compressore";


(*Turbine*)
PsiTurb::usage"Carico di stadio adimensionale";
C2bar::usage = "";
Cabar::usage = "";
Cu2bar::usage = "";
Wu2bar::usage = "";
\[Beta]2::usage = "";
Tt2rOverTt1::usage = "";
\[Beta]3::usage = "";
Cu3bar::usage = "";
\[Alpha]3::usage = "";
T3OverTt1::usage = "";
\[Tau]ts::usage = "";
Wu3bar::usage = "";
Rt::usage = "";
\[Sigma]xr::usage = "";
Vprime::usage = "";
SizeTurbineStage::usage"Calcola i parametri dello stadio conoscendo gi\[AGrave] l\[CloseCurlyQuote]angolo di uscita statorica \[Alpha]2"
SmartSizeTurbineStage::usage"Calcola i parametri dello stadio determinando l\[CloseCurlyQuote]angolo di uscita statorica \[Alpha]2"
CalcNstages::usage" Calcola il numero di stadi e la distribuzione delle temperature di uscita e dei rapporti di temperatura per ciascuno stadio"
CalcNstagesTurbine::usage"Permette di specificare il tipo di turbina in funzione del carico massimo di stadio"
SizeTurbine::usage"Calcola e mostra le prestazioni di tutti gli stadi di una turbina multi-stadio dati i parametri di ingresso. Supporta sia turbine HPT che LPT"


plotOffDesignPerfo::usage = ""
plotOffDesignCycle::usage = ""


Begin["`Private`"]


(* ::Section:: *)
(*Utilities*)


(* ::Subsection::RGBColor[0, 0, 1]::Closed:: *)
(*Thermodynamics*)


(*Constant pressure specific heat -Cp- definition*)
cp[\[Gamma]_,Rgas_]:=(\[Gamma]  Rgas)/(\[Gamma]-1);

(*Density of a real gas \[Rho]=p/(RT) *)
\[Rho][p_,T_,Rgas_]:=p /(Rgas T);

(*Entropy s definition*)
s[p_,T_,\[Gamma]_, Rgas_]:=cp[\[Gamma],Rgas] Log[T/Tref]-Rgas Log[p/Pref]/.{Pref->101325.0,Tref->273.15};

(*Specific Volume*)
vsp[p_,T_,Rgas_]:=1/\[Rho][p,T,Rgas];

(*total pressure*)
p0F[p_,Ma_,\[Gamma]_]:=p (1+(\[Gamma]-1)/2 Ma^2)^(\[Gamma]/(\[Gamma]-1));

(*total temperature*)
T0F[T_,Ma_,\[Gamma]_]:=T(1+(\[Gamma]-1)/2 Ma^2);

(*Static temperature*)
TF[T0_,\[Gamma]air_,Ma_]:=T0/(1+(\[Gamma]air-1)/2 Ma^2);

(*Statica pressure*)
pF[p0_,\[Gamma]air_,Ma_]:=p0/(1+(\[Gamma]air-1)/2 Ma^2)^(\[Gamma]air/(\[Gamma]air-1));



(* ::Subsection::RGBColor[0, 0, 1]::Closed:: *)
(*Stagnation ratios*)


(*Pressure Ratio of Stagnation definition p0/p *)
p0ratio[\[Gamma]_,M_]:=(1+(\[Gamma]-1)/2 M^2)^(\[Gamma]/(\[Gamma]-1));

(*Temperature Ratio of Stagnation definition T0/T *)
T0ratio[\[Gamma]_,M_]:=(1+(\[Gamma]-1)/2 M^2);

(*Density Ratio of Stagnation definition \[Rho]0/\[Rho]*)
\[Rho]0ratio[\[Gamma]_,M_]:=T0ratio[\[Gamma],M]^(1/(\[Gamma]-1));




(* ::Subsection::RGBColor[0, 0, 1]::Closed:: *)
(*Massflow*)


(*Massflow parameter *)
MFP[\[Gamma]_,M_]:=Sqrt[\[Gamma]]*M*(1.+(\[Gamma]-1)/2 M^2)^(1/2-\[Gamma]/(\[Gamma]-1));

(*Massflow parameter as a function of Pratio*)
mredPar[pratio_,\[Eta]_,\[Gamma]_]:= Sqrt[(2 \[Gamma])/(\[Gamma]-1)](pratio)  Sqrt[\[Eta](1-(pratio)^((\[Gamma]-1)/\[Gamma]))]/(1-\[Eta](1-(pratio)^((\[Gamma]-1)/\[Gamma])))/;pratio>=2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma])));
mredPar[pratio_,\[Eta]_,\[Gamma]_]:= Sqrt[(2 \[Gamma])/(\[Gamma]-1)](2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))  Sqrt[\[Eta](1-(2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))^((\[Gamma]-1)/\[Gamma]))]/(1-\[Eta](1-(2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))^((\[Gamma]-1)/\[Gamma])))/;pratio<2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma])));

(*Reduced Massflow definition *)
mred[massflow_,T0_,p0_,rgas_,area_]:=(massflow Sqrt[rgas T0])/(p0 area);


(* ::Subsection::RGBColor[0, 0, 1]:: *)
(*Cantera*)


runCantera[pythonExe_,T0_,p0_,f_,fuel_,oxid_,equilibriumPath_]:=Module[
{fst,phi},
fst = 1/14.287159546238891;
phi=f/fst;
Run[pythonExe<>" ../../combustion-cantera/equilibrium_calculation_v2.py "<>ToString[T0]<>" "<>ToString[NumberForm[p0,ExponentFunction->(Null &)]]<>" "<>ToString[phi]<>" "<>fuel<>" "<>oxid<>" "<>equilibriumPath];
]


(*Metodo delle secanti utilizzato per determinare il rapporto di equialenza tramite l'ausilio di cantera*)
SecantMethod[f_,{x_,x1_,x2_},n_,tolX_,tolF_,bol_]:=Module[{l={x1,x2}},
	 Do[
l=Append[l,l[[-1]]-(l[[-1]]-l[[-2]])/(f[l[[-1]]]-f[l[[-2]]])f[l[[-1]]]];
If[bol,Print["x = ", l, ", f(xn) = ", f[l[[-1]]]]];
If[Abs[l[[-1]]-l[[-2]]]<=tolX \[Or] Abs[f[l[[-1]]]]<=tolF,Break[]],
			{i,n}
		];
		l
];


importDataPy = Import["../../combustion-cantera/tabella_combustione.json", "RawJSON"];
pointsTablePy = {#["T01"], #["p01"], #["T02"], #["f"], #["cpB"]} & /@ importDataPy;
fData = pointsTablePy[[All, {1, 2, 3, 4}]];
cpBData = pointsTablePy[[All, {1, 2, 3, 5}]];
fFun = Interpolation[fData, InterpolationOrder -> 1];
cpBFun = Interpolation[cpBData, InterpolationOrder -> 1];


(* ::Section::Closed:: *)
(*International Standard Atmosphere (ISA) Model*)


(* ::Text:: *)
(*Actual altitude and ISA index:*)
(*1 - Troposphere (-6.05 C/km)  0 < h < 10000 m *)
(*2 - Tropopause (+0.0 C/km)  11000 < h < 20000 m *)
(*3 - Stratosphere (+1.0 C/km)  20000 < h < 32000 m *)


zzz[h_]:=r0*h/(r0+h)/.r0->6356577.
iii[z_]:=Piecewise[{{1,z<=11000},{2,11000<z<=20000},{3,20000<z<32000}}]


(* ::Text:: *)
(*Temperature*)


Tstd[h_]:=Module[
{Lstd,zstd,T0,j,out},

(*Coefficients definitions*)
Lstd={-6.5,0.,1.};
zstd={0.,11000.,20000.};
T0={288.15,216.65,216.65};

(*Index i[z]*)
j=iii[zzz[h]];

(*ISA model*)
out=T0[[j]]+Lstd[[j]]/1000 (zzz[h]-zstd[[j]]);

Return[out];
]


(* ::Text:: *)
(*Temperature (only first interval)*)


Tstd1[h_]:=Module[
{Lstd,zstd,T0,out},

(*Coefficients definitions*)
Lstd1=-6.5;
zstd1=0.;
T01=288.15;
(*ISA model*)
out=T01+Lstd1/1000 (zzz[h]-zstd1);

Return[out];
]


(* ::Text:: *)
(*Temperature (only second interval)*)


Tstd2[h_]:=Module[
{Lstd,zstd,T0,out},

(*Coefficients definitions*)
Lstd2=0.;
zstd2=11000.;
T02=216.65;

(*Index i[z]*)
j=iii[zzz[h]];

(*ISA model*)
out=T02+Lstd2/1000 (zzz[h]-zstd2);

Return[out];
]


(* ::Text:: *)
(*Temperature (only third interval)*)


Tstd3[h_]:=Module[
{Lstd,zstd,T0,out},

(*Coefficients definitions*)
Lstd3=1.;
zstd3=20000.;
T03=216.65;

(*Index i[z]*)
j=iii[zzz[h]];

(*ISA model*)
out=T03+Lstd3/1000 (zzz[h]-zstd3);

Return[out];
]


(* ::Text:: *)
(*Dimensionless temperature*)


\[Theta]std[h_]:=Tstd[h]/288.15;


\[Theta]Std1[h_]:=Tstd1[h]/288.15;
\[Theta]Std2[h_]:=Tstd2[h]/288.15;
\[Theta]Std3[h_]:=Tstd3[h]/288.15;


(* ::Text:: *)
(*Pressure model*)


pstd[h_]:=100*((44331.514-h)/11880.516)^(1./0.1902632);


(* ::Text:: *)
(*Dimensionless pressure*)


\[Delta]std[h_]:=pstd[zzz[h]]/101325.;


(* ::Text:: *)
(*Density (according to ideal gas EOS) in ISA environment, allowing for Temperature deviations from ISA (\[CapitalDelta]T)*)


\[Rho]std[h_,\[CapitalDelta]T_]:=pstd[h]/(R (Tstd[h]+\[CapitalDelta]T) )/.R->287.;
\[Rho]std1[h_,\[CapitalDelta]T_]:=pstd[h]/(R (Tstd1[h]+\[CapitalDelta]T) )/.R->287.;
\[Rho]std2[h_,\[CapitalDelta]T_]:=pstd[h]/(R (Tstd2[h]+\[CapitalDelta]T) )/.R->287.;
\[Rho]std3[h_,\[CapitalDelta]T_]:=pstd[h]/(R (Tstd3[h]+\[CapitalDelta]T) )/.R->287.;


\[Theta]func[T_]:=T/288.15;
\[Theta]0func[T_,M0_]:=\[Theta]func[T](1+0.2 M0^2);
\[Sigma]func[h_,T_]:=\[Delta]std[h]/\[Theta]func[T];
\[Rho]func[h_,T_]:=1.225*\[Sigma]func[h,T]; (*kg/m^3*)
\[Rho]funcSLUG[h_,T_]:=\[Rho]func[h,T]*(0.3048^3)*(1/14.59);(*slug/ft^3*)


(* ::Text:: *)
(*Other useful functions (dimensionless freestream total temperature and pressure)*)


\[Theta]0std[h_,M0_]:=\[Theta]std[h](1+0.2 M0^2);
\[Delta]0std[h_,M0_]:=\[Delta]std[h](1+0.2 M0^2)^(\[Gamma]/(\[Gamma]-1))/.\[Gamma]->1.4;


\[Theta]0std1[h_,M0_]:=\[Theta]Std1[h](1+0.2 M0^2);
\[Theta]0std2[h_,M0_]:=\[Theta]Std2[h](1+0.2 M0^2);
\[Theta]0std3[h_,M0_]:=\[Theta]Std3[h](1+0.2 M0^2);


(* ::Section::Closed:: *)
(*Mission Analysis*)


(* ::Subsection:: *)
(*Aerodynamic model*)


k1[commercial_,fighter_,Mach_,AR_,e_]:=Piecewise[{{ki[AR,e]+kv,commercial},{Piecewise[{{0.18,Mach<1},{0.18*Mach,Mach>=1}}],fighter}}]/.kv->0.01;
k2[commercial_,fighter_]:=Piecewise[{{-2kv CLmin,commercial},{0,fighter}}]/.{kv->0.01,CLmin->0.2}; 
ki[AR_,e_]:=1/(Pi AR e);
cd0[commercial_,fighter_,Mach_]:=Piecewise[{{Piecewise[{{0.017,Mach<=0.8},{0.035*Mach-0.011,Mach>0.8}}]+kv CLmin^2,commercial},{Piecewise[{{0.014,Mach<=0.8},{0.035*Mach-0.014,0.8<Mach<1.2},{0.028,Mach>=1.2}}],fighter}}]/.{kv->0.01,CLmin->0.2};


(* ::Subsection:: *)
(*Thrust Lapse model*)


(* ::Subsubsection:: *)
(*High BPR TurboFan*)


\[Alpha]1[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-0.49 Sqrt[M0]);
\[Alpha]2[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-0.49 Sqrt[M0]-(3(\[Theta]0std[h,M0]-TR))/(1.5+M0));
\[Alpha]TF[h_,M0_,TR_]:=Piecewise[{{\[Alpha]1[h,M0,TR],\[Theta]0std[h,M0]<=TR},{\[Alpha]2[h,M0,TR],\[Theta]0std[h,M0]>TR}}];


(* ::Subsubsection:: *)
(*Low BPR TurboFan (Max Power)*)


\[Alpha]3[h_,M0_,TR_]:=\[Delta]0std[h,M0];
\[Alpha]4[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-(3.5*(\[Theta]0std[h,M0]-TR))/\[Theta]0std[h,M0]);
\[Alpha]LTFmax[h_,M0_,TR_]:=Piecewise[{{\[Alpha]3[h,M0,TR],\[Theta]0std[h,M0]<=TR},{\[Alpha]4[h,M0,TR],\[Theta]0std[h,M0]>TR}}];


\[Alpha]4h1[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-(3.5*(\[Theta]0std1[h,M0]-TR))/\[Theta]0std1[h,M0]);
\[Alpha]LTFmaxh1[h_,M0_,TR_]:=Piecewise[{{\[Alpha]3[h,M0,TR],\[Theta]0std1[h,M0]<=TR},{\[Alpha]4h1[h,M0,TR],\[Theta]0std1[h,M0]>TR}}];

\[Alpha]4h2[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-(3.5*(\[Theta]0std2[h,M0]-TR))/\[Theta]0std2[h,M0]);
\[Alpha]LTFmaxh2[h_,M0_,TR_]:=Piecewise[{{\[Alpha]3[h,M0,TR],\[Theta]0std2[h,M0]<=TR},{\[Alpha]4h2[h,M0,TR],\[Theta]0std2[h,M0]>TR}}];

\[Alpha]4h3[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-(3.5*(\[Theta]0std3[h,M0]-TR))/\[Theta]0std3[h,M0]);
\[Alpha]LTFmaxh3[h_,M0_,TR_]:=Piecewise[{{\[Alpha]3[h,M0,TR],\[Theta]0std3[h,M0]<=TR},{\[Alpha]4h3[h,M0,TR],\[Theta]0std3[h,M0]>TR}}];

\[Alpha]3func[h_,M0_,TR_]:=\[Delta]0std[h,M0];
\[Alpha]4func[h_,T_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-(3.5*(\[Theta]0func[T,M0]-TR))/\[Theta]0func[T,M0]);
\[Alpha]LTFmaxFUNC[h_,T_,M0_,TR_]:=Piecewise[{{\[Alpha]3func[h,M0,TR],\[Theta]0func[T,M0]<=TR},{\[Alpha]4func[h,T,M0,TR],\[Theta]0func[T,M0]>TR}}];


(* ::Subsubsection:: *)
(*Low BPR TurboFan (Military Power)*)


\[Alpha]5[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0];
\[Alpha]6[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0]*(1-(3.8*(\[Theta]0std[h,M0]-TR))/\[Theta]0std[h,M0]);
\[Alpha]LTFmil[h_,M0_,TR_]:=Piecewise[{{\[Alpha]5[h,M0,TR],\[Theta]0std[h,M0]<=TR},{\[Alpha]6[h,M0,TR],\[Theta]0std[h,M0]>TR}}];


\[Alpha]6h1[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0]*(1-(3.8*(\[Theta]0std1[h,M0]-TR))/\[Theta]0std1[h,M0]);
\[Alpha]LTFmilh1[h_,M0_,TR_]:=Piecewise[{{\[Alpha]5[h,M0,TR],\[Theta]0std1[h,M0]<=TR},{\[Alpha]6h1[h,M0,TR],\[Theta]0std1[h,M0]>TR}}];

\[Alpha]6h2[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0]*(1-(3.8*(\[Theta]0std2[h,M0]-TR))/\[Theta]0std2[h,M0]);
\[Alpha]LTFmilh2[h_,M0_,TR_]:=Piecewise[{{\[Alpha]5[h,M0,TR],\[Theta]0std2[h,M0]<=TR},{\[Alpha]6h2[h,M0,TR],\[Theta]0std2[h,M0]>TR}}];

\[Alpha]6h3[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0]*(1-(3.8*(\[Theta]0std3[h,M0]-TR))/\[Theta]0std3[h,M0]);
\[Alpha]LTFmilh3[h_,M0_,TR_]:=Piecewise[{{\[Alpha]5[h,M0,TR],\[Theta]0std3[h,M0]<=TR},{\[Alpha]6h3[h,M0,TR],\[Theta]0std3[h,M0]>TR}}];

\[Alpha]5func[h_,M0_,TR_]:=0.6*\[Delta]0std[h,M0];
\[Alpha]6func[h_,T_,M0_,TR_]:=0.6*\[Delta]0std[h,M0]*(1-(3.8*(\[Theta]0func[T,M0]-TR))/\[Theta]0func[T,M0]);
\[Alpha]LTFmilFUNC[h_,T_,M0_,TR_]:=Piecewise[{{\[Alpha]5func[h,M0,TR],\[Theta]0func[T,M0]<=TR},{\[Alpha]6func[h,T,M0,TR],\[Theta]0func[T,M0]>TR}}];


(* ::Subsubsection:: *)
(*TurboJet (Max Power)*)


\[Alpha]7[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-0.3(\[Theta]0std[h,M0]-1)-0.1* Sqrt[M0]);
\[Alpha]8[h_,M0_,TR_]:=\[Delta]0std[h,M0]*(1-0.3(\[Theta]0std[h,M0]-1)-0.1* Sqrt[M0]-(1.5*(\[Theta]0std[h,M0]-TR))/\[Theta]0std[h,M0]);
\[Alpha]TJmax[h_,M0_,TR_]:=Piecewise[{{\[Alpha]7[h,M0,TR],\[Theta]0std[h,M0]<=TR},{\[Alpha]8[h,M0,TR],\[Theta]0std[h,M0]>TR}}];


(* ::Subsubsection:: *)
(*TurboJet (Military Power)*)


\[Alpha]9[h_,M0_,TR_]:=0.8*\[Delta]0std[h,M0]*(1-0.16* Sqrt[M0]);
\[Alpha]10[h_,M0_,TR_]:=0.8*\[Delta]0std[h,M0]*(1-0.16* Sqrt[M0]-(24*(\[Theta]0std[h,M0]-TR))/((9+M0)*\[Theta]0std[h,M0]));
\[Alpha]TJmil[h_,M0_,TR_]:=Piecewise[{{\[Alpha]9[h,M0,TR],\[Theta]0std[h,M0]<=TR},{\[Alpha]10[h,M0,TR],\[Theta]0std[h,M0]>TR}}];


(* ::Section:: *)
(*Cycle Analysis*)


(* ::Subsection:: *)
(*Engine Components*)


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*FreeStream*)


(* ::Text:: *)
(*Modulo che calcola le grandezze statiche e di ristagno del FLUSSO INDISTURBATO*)
(**)
(*	INPUT : [h,M,\[Gamma]air,Rair,report]*)
(*		"h": quota (es. 5000);*)
(*		"M": n\[Degree]Mach di volo (es. 0.83);*)
(*		"\[Gamma]air , Rair" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*		"report": variabile booleana di stampa*)
(**)
(*	OUTPUT :  { pntOut { }, pnt0Out { }, Va }*)
(*		pntOut = {pa, Ta, \[Rho]a, sa}  --> Grandezze STATICHE:*)
(*			"pa": pressione atmosferica;*)
(*			"Ta": temperatura atmosferica;*)
(*			"\[Rho]a": densit\[AGrave] atmosferica;*)
(*			"sa": entropia atmosferica;*)
(*		pnt0Out = {p0a, T0a, \[Rho]0a, s0a} --> Grandezze GLOBALI:*)
(*			"p0a": pressione atmosferica globale;*)
(*			"T0a": temperatura atmosferica globale;*)
(*			"\[Rho]0a": densit\[AGrave] atmosferica globale;*)
(*			"s0a": entropia atmosferica globale;*)
(*		*)
(*		"Va": velocit\[AGrave] del flusso indisturbato ;*)


FreeStream[h_,M_,\[Gamma]air_,Rair_,report_]:=Module[
	{pa,Ta,\[Rho]a,sa,
	p0a,T0a,\[Rho]0a,s0a,
	pntOut,pnt0Out,
	Va,
	Values,Units,ValuesAndUnits},

(* Grandezze STATICHE *)
	pa=pstd[h];
	Ta=Tstd[h];
	\[Rho]a=\[Rho]std[h,0];
	sa=s[pa,Ta,\[Gamma]air, Rair];

		pntOut={pa,Ta,\[Rho]a,sa};

	Va=M Sqrt[\[Gamma]air Rair  Ta];


(* Grandezze GLOBALI o di RISTAGNO *)
	p0a=pa*p0ratio[\[Gamma]air,M];
	T0a=Ta*T0ratio[\[Gamma]air,M];
	\[Rho]0a=\[Rho][p0a,T0a,Rair];
	s0a=s[p0a,T0a,\[Gamma]air, Rair];

		pnt0Out={p0a,T0a,\[Rho]0a,s0a};

(*Stampa dei parametri*)

If[report,
		Units={" km",""," m/s"," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"};
		Values=Join[h/1000,M,Va,pa/1000,Ta,\[Rho]a,sa/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,7}];
		Print["Free Stream Static Condition"];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"Height","Mach","Speed","\!\(\*SubscriptBox[\"p\", \"a\"]\)","\!\(\*SubscriptBox[\"T\", \"a\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"a\"]\)","\!\(\*SubscriptBox[\"s\", \"a\"]\)"}},TableDirections->Row
		]];
		Print[""];
		
		Units={" kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"};
		Values=Join[p0a/1000,T0a,\[Rho]0a,s0a/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,4}];
		Print["Free Stream Stagnation Condition"];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"p\", 
RowBox[{\"0\", \"a\"}]]\)","\!\(\*SubscriptBox[\"T\", 
RowBox[{\"0\", \"a\"}]]\)","\!\(\*SubscriptBox[\"\[Rho]\", 
RowBox[{\"0\", \"a\"}]]\)","\!\(\*SubscriptBox[\"s\", 
RowBox[{\"0\", \"a\"}]]\)"}},TableDirections->Row
		]];
		Print[""];
	];


	{pntOut,pnt0Out,Va}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*DiffuserCompression*)


(* ::Text:: *)
(*	Modulo che calcola la Compressione nel DIFFUSORE*)
(**)
(*		INPUT : [pntIn { }, Ma, pa, \[Epsilon]1,\[Epsilon]2,BPR,\[Eta]d, \[Gamma]air, Rair,report]*)
(*			pntIn  = { p01, T01, \[Rho]01, s01 } stato all'ingresso del Diffusore ;	*)
(*				"Ma": n\[Degree]Mach di volo all'ingresso del Diffusore (es. 0.83);*)
(*				"pa": pressione statica all'ingresso del Diffusore;*)
(*				"\[Epsilon]1": rapporto di bypass per raffreddamento della HPT*)
(*				"\[Epsilon]2": rapporto di bypass per raffreddamento della LPT*)
(*				"BPR": rapporto di bypass*)
(*				"\[Eta]d" : rendimento adiabatico del Diffusore;*)
(*				"\[Gamma]air , Rair" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*				"report": variabile booleana di stampa*)
(*			*)
(*		OUTPUT : {pntOut { }, work}*)
(*			pntOut = { p02, T02, \[Rho]02, s02 } stato all'esterno del Diffusore;*)
(*				"work": lavoro del diffusore per unit\[AGrave] di massa;*)


DiffuserCompression[pntIn_,Ma_,pa_,\[Epsilon]1_,\[Epsilon]2_,BPR_,\[Eta]d_,\[Gamma]air_,Rair_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,T02,s02,\[Rho]02,
	work,ratioDiffuser,
	pntOut,
    Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;

	ratioDiffuser=(1+\[Eta]d (\[Gamma]air-1)/2 Ma^2)^(\[Gamma]air/(\[Gamma]air-1));

	p02=pa*ratioDiffuser;  (* p2\[TildeFullEqual]p02 *)
	T02=T01*(1+(\[Gamma]air-1)/2*Ma^2);
	\[Rho]02=\[Rho][p02,T02,Rair];
	s02=s[p02,T02,\[Gamma]air, Rair];

	pntOut={p02,T02,\[Rho]02,s02};

	work=(1+\[Epsilon]1+\[Epsilon]2+BPR)*cp[\[Gamma]air,Rair](T02-T01);


(*Stampa dei parametri*)

	If[report,
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"," kJ/kg"};
		Values=Join[\[Gamma]air,\[Eta]d,p02/1000,T02,\[Rho]02,s02/1000,work/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\[Gamma]","\!\(\*SubscriptBox[\"\[Eta]\", \"d\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","Specific powerr"}},TableDirections->Row
		]];
		Print[""];
		
		
	];	


	{pntOut,work}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*CompressorCompression*)


(* ::Text:: *)
(*	Modulo che calcola la Compressione nel COMPRESSORE *)
(*		*)
(*		INPUT :  [pntIn { }, massflowIN,massflowOUT, \[Beta]c, \[Eta]pc, \[Gamma], Rair,report]*)
(*			pntIn = { p01, T01, \[Rho]01, s01 }  stato all'ingresso del Compressore/Fan ;*)
(*				"massflowIN": portata in massa d'aria specifica in input (specificata rispetto alla portata d'aria primaria);	*)
(*				"massflowOUT": portata in massa d'aria in output (es. Per il Turbofan si avr\[AGrave] nel Fan "massflow = 1+BPR" e nel Compressore "massflow = 1");*)
(*				"\[Beta]c": rapporto di compressione del Compressore/Fan;*)
(*				"\[Eta]pc" : rendimento politropico del compressore/fan;*)
(*				"\[Gamma]air , Rair" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*				"report": variabile booleana di stampa*)
(**)
(*		OUTPUT :  [pntOut { },\[Eta]c,work]*)
(*			pntOut { p02, T02, \[Rho]02, s02 } : stato all'esterno del Compressore/Fan;*)
(*			\[Eta]c: rendimento adiabatico del Compressore/Fan;*)
(*			work: lavoro del compressore/fan per unit\[AGrave] di massa;*)


CompressorCompression[pntIn_,massflowIN_,massflowOUT_,\[Beta]c_,\[Eta]pc_,\[Gamma]air_,Rair_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	\[Eta]c,
	p02,T02,\[Rho]02,s02,
	work,
	pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;

	\[Eta]c=(1-\[Beta]c^((\[Gamma]air-1)/\[Gamma]air))/(1-\[Beta]c^((\[Gamma]air-1)/(\[Eta]pc*\[Gamma]air)));

	p02=\[Beta]c*p01;
	T02=T01*(1+(\[Beta]c^((\[Gamma]air-1)/\[Gamma]air)-1)/\[Eta]c);
	\[Rho]02=\[Rho][p02,T02,Rair];
	s02=s[p02,T02,\[Gamma]air, Rair];
	pntOut={p02,T02,\[Rho]02,s02};

	work=massflowOUT*cp[\[Gamma]air, Rair]*T02-massflowIN*cp[\[Gamma]air, Rair]*T01; (*nel caso del fan, verr\[AGrave] stampato nella tabella in funzione del BPR poich\[EAcute] verr\[AGrave] ricavato in turbina*)

(*Stampa dei parametri*)

	If[report,
		
		Units={"","",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"," kJ/kg"};
		Values=Join[\[Beta]c,\[Gamma]air,\[Eta]c,p02/1000,T02,\[Rho]02,s02/1000,work/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Beta]\", \"c\"]\)","\[Gamma]","\!\(\*SubscriptBox[\"\[Eta]\", \"c\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","Specific power"}},TableDirections->Row
		]];
		Print[""];
			
	];	

	{pntOut,\[Eta]c,work}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*BurnerCombustion*)


(* ::Text:: *)
(*Modulo che calcola la Combustione nel COMBUSTORE*)
(**)
(*INPUT :  [pntIn { }, \[Eta]b,Qf, T02, \[Gamma]air, Rair, \[Gamma]gas, Rgas,report]*)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso del Combustore ;*)
(*	"\[Eta]b" : rendimento di combustione (es. \[Eta]b=0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Combustore (es. \[Eta]pb=0.95);*)
(*	"Qf": potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile.  es. Qf = 43*10^6J/kg);*)
(*	"T02": temperatura massima ammissibile in Turbina (es. T02 = 1420K);*)
(*	"\[Gamma]air, Rair, \[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*	"report": variabile booleana di stampa*)
(**)
(*OUTPUT :  { pntOut { }, f }*)
(*	pntOut { p02, T02, \[Rho]02, s02 } stato all'esterno del Combustore;*)
(*	"f": rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*	"heat": calore del combustore per unit\[AGrave] di massa;*)


BurnerCombustion[pntIn_,\[Eta]b_,\[Eta]pb_,Qf_,T02_,\[Gamma]air_,Rair_,\[Gamma]gas_,Rgas_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,\[Rho]02,s02,
	f,heat,
	pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;

	(* Dal bilancio entalpico in ingresso e in uscita dal combustore:
		m_air*cp_air*T01 + m_fuel*Qfuel*\[Eta]b = [m_air+m_fuel]*cp_gas*T02
	che introducendo f pu\[OGrave] essere riscritto come:
		cp_air*T01 + f*Qfuel*\[Eta]b = [1+f]*cp_gas*T02
	nota T02, si pu\[OGrave] ricavare f.
*)

	f= (cp[\[Gamma]gas,Rgas]*T02-cp[\[Gamma]air,Rair]*T01)/(\[Eta]b*Qf-cp[\[Gamma]gas,Rgas]*T02);

	p02=\[Eta]pb*p01;
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas, Rgas];

	pntOut={p02,T02,\[Rho]02,s02};

	heat=f*Qf*\[Eta]b;


	(*Stampa dei parametri*)

	If[report,
		Print["Burner Parameters"];
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K",""," kJ/kg"};
		Values=Join[\[Eta]pb,\[Eta]b,p02/1000,T02,\[Rho]02,s02/1000,f,heat/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Eta]\", \"pb\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"b\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","f","Specific heat"}},TableDirections->Row
		]];
		Print[""];
			
	];

	{pntOut,f,heat}
]


(* ::Subsubsection::RGBColor[0, 0, 1]:: *)
(*BurnerCombustionCantera*)


(* ::Text:: *)
(*Modulo che calcola la Combustione nel COMBUSTORE*)
(**)
(*INPUT :  [pntIn { }, \[Eta]b, Qf, T02, \[Gamma]air, Rair, \[Gamma]gas, Rgas, report]*)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all' ingresso del Combustore ;*)
(*	"\[Eta]b" : rendimento di combustione (es . \[Eta]b = 0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Combustore (es . \[Eta]pb = 0.95);*)
(*	"Qf" : potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile .  es . Qf = 43*10^6 J/kg);*)
(*	"T02" : temperatura massima ammissibile in Turbina (es . T02 = 1420 K);*)
(*	"\[Gamma]air, Rair, \[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es . Per gas combusti  \[Gamma]gas = 1.34, Rgas = 286.77 J/kg/K);*)
(*	"report" : variabile booleana di stampa*)
(**)
(*OUTPUT :  { pntOut { }, f, heat }*)
(*	pntOut { p02, T02, \[Rho]02, s02 } stato all' esterno del Combustore;*)
(*	"f" : rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*	 "heat" : calore (potenza) specifica del Combustore (specifica rispetto alla portata d' aria elaborata) [ KJ/kg = kW/(kg/s) ];*)


BurnerCombustionCantera[pythonExe_,pntIn_,\[Eta]b_,\[Eta]pb_,Qf_,T02_,\[Gamma]gas_,Rgas_,fuel_,oxid_,equilibriumPath_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,\[Rho]02,s02,
	equiT,equiP,equiY,filteredY,cp,phi,f,
	pntOut,heat,
	speciesOrder,speciesValues,
	Values,Units,fullTableHeaders,ValuesAndUnits},
	
	{p01,T01,\[Rho]01,s01}=pntIn;
	
	{equiT,equiP,equiY,filteredY,cp,phi,f}=runCantera[pythonExe,T01,p01,T02,fuel,oxid,equilibriumPath];

	p02=\[Eta]pb*p01;
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas,Rgas];
	pntOut={p02,T02,\[Rho]02,s02};
	heat=f*Qf*\[Eta]b;

	speciesOrder={"NO","NO2","CO","CO2","H2O","O2"};
	speciesValues=Table[Lookup[Association[filteredY],species,0],{species,speciesOrder}];
	
	If[report,Units=Join[{"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K",""," kJ/kg"," J/(kg*K)"},Table["",{Length[speciesValues]}]];
		Values=Join[{\[Eta]pb,\[Eta]b,p02/1000,T02,\[Rho]02,s02/1000,f,heat/1000,cp},speciesValues];
		fullTableHeaders=Join[{"\!\(\*SubscriptBox[\"\[Eta]\", \"pb\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"b\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","f","Specific power","cpProdotti"},{"NOem","NO2em","COem","CO2em","H2O","O2"}];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print["Burner Parameters"];
		Print[TableForm[{ValuesAndUnits},TableHeadings->{None,fullTableHeaders},TableDirections->Row]];
		Print[""];
	];

	{pntOut,f,heat,cp,filteredY}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*BurnerCombustionInterpolation*)


(* ::Text:: *)
(*Modulo che calcola la Combustione nel COMBUSTORE*)
(**)
(*INPUT :  [pntIn { }, \[Eta]b, Qf, T02, \[Gamma]air, Rair, \[Gamma]gas, Rgas, report]*)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all' ingresso del Combustore ;*)
(*	"\[Eta]b" : rendimento di combustione (es . \[Eta]b = 0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Combustore (es . \[Eta]pb = 0.95);*)
(*	"Qf" : potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile .  es . Qf = 43*10^6 J/kg);*)
(*	"T02" : temperatura massima ammissibile in Turbina (es . T02 = 1420 K);*)
(*	"\[Gamma]air, Rair, \[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es . Per gas combusti  \[Gamma]gas = 1.34, Rgas = 286.77 J/kg/K);*)
(*	"report" : variabile booleana di stampa*)
(**)
(*OUTPUT :  { pntOut { }, f, heat }*)
(*	pntOut { p02, T02, \[Rho]02, s02 } stato all' esterno del Combustore;*)
(*	"f" : rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*	 "heat" : calore (potenza) specifica del Combustore (specifica rispetto alla portata d' aria elaborata) [ KJ/kg = kW/(kg/s) ];*)


BurnerCombustionInterpolation[pntIn_,\[Eta]b_,\[Eta]pb_,Qf_,T02_,\[Gamma]gas_,Rgas_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,\[Rho]02,s02,
	f,fst,phi,cpB,
	pntOut,heat,
	Units,Values,ValuesAndUnits},

	
	{p01,T01,\[Rho]01,s01}=pntIn;

	f=fFun[T01,p01,T02];
	fst=1/14.287159546238891;
	phi= f/fst;
	cpB=cpBFun[T01,p01,T02];

	p02=\[Eta]pb*p01;
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas,Rgas];

	pntOut={p02,T02,\[Rho]02,s02};

	heat=f*Qf*\[Eta]b;
	


	(*Stampa dei parametri*)

	If[report,
		Print["Burner Parameters"];
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K","","",""," J/(kg*K)"," kJ/kg"};
		Values=Join[\[Eta]pb,\[Eta]b,p02/1000,T02,\[Rho]02,s02/1000,f,fst,phi,cpB,heat/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Eta]\", \"pb\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"b\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","f","\!\(\*SubscriptBox[\"f\", \"st\"]\)","\[Phi]","cpB","Specific heat"}},TableDirections->Row
		]];
		Print[""];
			
	];

	{pntOut,f,heat,cpB}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*MixerMiscelation*)


(* ::Text:: *)
(*	Modulo che calcola la Miscelazione che avviene nel Mixer*)
(**)
(*		INPUT : [pntIn { },massflowIN,BPR,Tfan,\[Gamma]air,Rair,\[Gamma]gas,Rgas] *)
(*			pntIn { p01, T01, \[Rho]01, s01 }: stato all'ingresso del Mixer ;	*)
(*			"massflowIN": portata in massa d'aria specifica in input nel Mixer (specificata rispetto alla portata d'aria primaria) [adimensionale] (massflow=1+f)*)
(*			"BPR": rapporto di Bypass;*)
(*			"Tfan": Temperatura a valle del Fan (T21);*)
(*			"\[Gamma]air , Rair,\[Gamma]gas,Rgas" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*			"report": variabile booleana di stampa*)
(*			*)
(*		OUTPUT :  pntOut { },*)
(*			pntOut { p02, T02, \[Rho]02, s02 }  stato all'esterno del Mixer;*)


MixerMiscelation[pntIn_,massflowIN_,BPR_,Tmix_,cpB_,\[Gamma]air_,Rair_,\[Gamma]gas_,Rgas_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,T02,\[Rho]02,s02,
	pntOut,
	Values,Units,ValuesAndUnits},
	
	
	{p01,T01,\[Rho]01,s01}=pntIn;
	
	p02=p01; (* la miscelazione tra flusso freddo e caldo deve avvenire alla stessa pressione*)
	T02=(cpB*massflowIN*T01+cp[\[Gamma]air,Rair]*BPR*Tmix)/(cpB*(massflowIN+BPR));
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas, Rgas];
	
	pntOut={p02,T02,\[Rho]02,s02};

(*Stampa dei parametri*)

	If[report,
		Units={"","kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"};
		Values=Join[\[Gamma]gas,p02/1000,T02,\[Rho]02,s02/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\[Gamma]","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)"}},TableDirections->Row
		]];
		Print[""];
			
	];	

	pntOut
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*TurbineExpansion HPT (CONSIDERANDO FLUSSI ASSOCIATI)*)


(* ::Text:: *)
(*	Modulo che calcola l'Espansione nella Turbina HPT considerando flussi associati iterando \[Beta]c1.*)
(**)
(*		INPUT : [pntIn { },\[Beta]c,\[Eta]pt,pfan,Tfan,Tc,\[Eta]c,\[Eta]mc,\[Eta]mt,\[Epsilon]1,\[Epsilon]2,massflowIN,massflowOUT,\[Gamma]air,Rair,\[Gamma]gas,Rgas,False]*)
(*			pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso della Turbina ;*)
(*			"pfan": pressione a valle del fan;*)
(*			"Tfan": temperatura a valle del fan;*)
(*			"Tc": temperatura a valle della HPC;*)
(*			"\[Eta]c": rendimento adiabatico compressore;*)
(*			"\[Eta]mc" : rendimento meccanico del Compressore/Fan collegato alla Turbina (es. 0.87);*)
(*			"\[Eta]mt" : rendimento meccanico della Turbina (es. 0.99);*)
(*			"\[Epsilon]1": portata in massa d'aria specifica a valle della HPC che verr\[AGrave] miscelata a valle della camera di combustione prima della HPT;*)
(*			"\[Epsilon]2":  portata in massa d'aria specifica intermedia nella HPC che verr\[AGrave] miscelata a valle della camera della HPT prima della LPT;*)
(*			"massflowIN": portata in massa d'aria specifica in input (specificata rispetto alla portata d'aria primaria);	*)
(*			"massflowOUT": portata in massa d'aria in output;*)
(*			"\[Gamma]air,Rair,\[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*			"report": variabile booleana di stampa*)
(**)
(*		OUTPUT :  {pntOut { }, work,\[Beta]c1}*)
(*			pntOut { p02, T02, \[Rho]02, s02 }  stato all'esterno della Turbina;*)
(*			"work": lavoro per unit\[AGrave] di massa della HPT;*)
(*			"\[Beta]c1": rapporto di pressione tra la pressione intermedia in qui \[Epsilon]2 viene spillata e la pfan;*)
(*			"Tfanb": temperatura della HPT in corrispondenza della spillatura di \[Epsilon]2;*)
(*			"\[Eta]t": rendimento adiabatico turbina*)


TurbineExpansionHPT[pntIn_,\[Beta]c_,\[Eta]pt_,pfan_,Tfan_,Tc_,\[Eta]c_,\[Eta]mc_,\[Eta]mt_,\[Epsilon]1_,\[Epsilon]2_,massflowIN_,massflowOUT_,\[Gamma]air_,Rair_,cpB_,\[Gamma]gas_,Rgas_,report_]:=Module[
	{maxIter,tolX,tolY,\[Beta]c1Iter,deltaP,
	p01,T01,\[Rho]01,s01,
	p02,T02,\[Rho]02,s02,
	\[Eta]t,
	Tfanb,pfanb,
	\[Beta]c1,err,
	work,pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;	
	

	\[Eta]t=(1-(1/\[Beta]c)^((\[Gamma]gas-1)*\[Eta]pt/\[Gamma]gas))/(1-(1/\[Beta]c)^((\[Gamma]gas-1)/\[Gamma]gas));
	
	deltaP[\[Beta]c1_]:=Module[{delta},
		pfanb=\[Beta]c1*pfan;
		Tfanb=Tfan (1+(\[Beta]c1^((\[Gamma]air-1)/\[Gamma]air)-1)/\[Eta]c);
	
		T02=T01-(cp[\[Gamma]air,Rair]*(1+\[Epsilon]1+\[Epsilon]2)*(Tfanb-Tfan)+(1+\[Epsilon]1)*(Tc-Tfanb))/(\[Eta]mc*\[Eta]mt*cpB*massflowIN);
		p02=p01*(1-(1-T02/T01)/(\[Eta]t))^(\[Gamma]gas/(\[Gamma]gas-1));
	
		delta=(pfanb-p02);
		delta
	];

	maxIter=100;
	tolX=10^-6;
	tolY=1;

	\[Beta]c1Iter=SecantMethod[deltaP,{x,4,5},maxIter,tolX,tolY,False];	

	\[Beta]c1=\[Beta]c1Iter[[-1]];
	
	pfanb=\[Beta]c1*pfan;
	Tfanb=Tfan (1+(\[Beta]c1^((\[Gamma]air-1)/\[Gamma]air)-1)/\[Eta]c);
			
	T02=T01-1/(\[Eta]mc*\[Eta]mt)*(cp[\[Gamma]air,Rair]/cpB*((1+\[Epsilon]1+\[Epsilon]2)*(Tfanb-Tfan)+(1+\[Epsilon]1)*(Tc-Tfanb))/massflowIN);
	p02=p01*(1-1/\[Eta]t*(1-T02/T01))^(\[Gamma]gas/(\[Gamma]gas-1));
		
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas,Rgas];

	work=massflowIN*cpB*T01-massflowOUT*cpB*T02;
	pntOut={p02,T02,\[Rho]02,s02};
	

(*Stampa dei parametri*)


	If[report,
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K",""," kJ/kg"};
		Values=Join[\[Gamma]gas,\[Eta]t,p02/1000,T02,\[Rho]02,s02/1000,\[Beta]c1,work/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Gamma]\", \"gas\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"t\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","\[Beta]c1","Specific power"}},TableDirections->Row
		]];
		Print[""];
			
	];
	
	{pntOut,work,\[Beta]c1,Tfanb,\[Eta]t}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*TurbineExpansion LPT (CONSIDERANDO FLUSSI ASSOCIATI)*)


(* ::Text:: *)
(*	Modulo che calcola la Espansione nella Turbina LPT considerando flussi associati (e quindi po02=p_a_valle_del_fan)*)
(**)
(*		INPUT : [pntIn { },massflowIN,massflowOUT,pfan, \[Gamma]gas, Rgas,report]*)
(*			pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso della Turbina ;*)
(*			"massflowIN": portata in massa d'aria specifica in input (specificata rispetto alla portata d'aria primaria);	*)
(*			"massflowOUT": portata in massa d'aria in output;*)
(*			"pfan": pressione a valle del fan*)
(*			"\[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*			"report": variabile booleana di stampa*)
(**)
(*		OUTPUT :  {pntOut { }, ratioTurbine, work,BPR}*)
(*			pntOut { p02, T02, \[Rho]02, s02 }  stato all'esterno della Turbina;*)
(*			"work": lavoro per unit\[AGrave] di massa della LPT;*)


TurbineExpansionLPT[pntIn_,massflowIN_,massflowOUT_,pfan_,\[Eta]t_,cpB_,\[Gamma]gas_,Rgas_,report_]:=Module[
	{p01,T01,\[Rho]01,s01,
	T02,p02,\[Rho]02,s02,
	work,
	pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;


	p02=pfan; (*la pressione a valle della turbina deve essere uguale a quella a valle del fan perch\[EAcute] poi in entrata del mixer,
						le due portate (calda e fredda) devono essere alla stessa pressione per essere miscelate*)
	T02=T01*(1-\[Eta]t*(1-(p02/p01)^((\[Gamma]gas-1)/\[Gamma]gas)));
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas, Rgas];
	work=massflowIN*cpB*T01-massflowOUT*cpB*T02;
	
	pntOut={p02,T02,\[Rho]02,s02};


(*Stampa dei parametri*)

	If[report,
		
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K","kJ/kg"};
		Values=Join[\[Gamma]gas,\[Eta]t,p02/1000,T02,\[Rho]02,s02/1000,work];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Gamma]\", \"gas\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"t\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","Specific power"}},TableDirections->Row
		]];
		Print[""];
			
	];

	{pntOut,work}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*AfterBurnerCombustion *)


(* ::Text:: *)
(*Modulo che calcola la Combustione nel Post Bruciatore*)
(**)
(*INPUT :  [pntIn { }, massflow,\[Eta]b,\[Eta]pb,Qf, T02, \[Gamma]air, Rair, \[Gamma]gas, Rgas,report]*)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso del Combustore ;*)
(*	"massflowIN": portata in massa d'aria specifica in input nel post bruciatore;*)
(*	"\[Eta]b" : rendimento di combustione del Post Bruciatore(es. \[Eta]b=0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Post Bruciatore (es. \[Eta]pb=0.95);*)
(*	"Qf": potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile.  es. Qf = 43*10^6J/kg);*)
(*	"T02": temperatura massima ammissibile a valle del Post Bruciatore (es. T02 = 1800K);*)
(*	"\[Gamma]air, Rair, \[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*	"report": variabile booleana di stampa*)
(**)
(*OUTPUT :  { pntOut { }, f, heat }*)
(*	pntOut { p02, T02, \[Rho]02, s02 } stato all'esterno del Combustore;*)
(*	"f": rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*	 "heat": calore (potenza) specifica dell'AfterBurner (specifica rispetto alla portata d'aria elaborata) [ KJ/kg = kW/(kg/s) ];*)


AfterBurnerCombustion[pntIn_,massflowIN_,\[Eta]b_,\[Eta]pb_,Qf_,T02_,cpB_,\[Gamma]gas_,Rgas_,report_,afterburner_:False]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,\[Rho]02,s02,
	f,heat,
	pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;


	If[afterburner,
	
		f= massflowIN*(cpB*T02-cpB*T01)/(\[Eta]b*Qf-cpB*T02);

		p02=\[Eta]pb*p01;
		\[Rho]02=\[Rho][p02,T02,Rgas];
		s02=s[p02,T02,\[Gamma]gas, Rgas];

		pntOut={p02,T02,\[Rho]02,s02};

		heat=f*Qf*\[Eta]b;
		
	(*Stampa dei parametri*)

	If[report,
		Print["AfterBurner Parameters"];
		Units={"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K","","kJ/kg"};
		Values=Join[\[Eta]pb,\[Eta]b,p02/1000,T02,\[Rho]02,s02/1000,f,heat/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Eta]\", \"pb\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"b\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)","f","Specific heat"}},TableDirections->Row
		]];
		Print[""];
			
	],
		
		If[report,Print["AfterBurner is off"]];
		pntOut=pntIn;
		f=0;
		heat=0;
	];
	
	{pntOut,f,heat}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*AfterBurnerCombustionCantera *)


(* ::Text:: *)
(*Modulo che calcola la Combustione nel Post Bruciatore*)
(**)
(*INPUT :  [pntIn { }, massflow,\[Eta]b,\[Eta]pb,Qf, T02, \[Gamma]air, Rair, \[Gamma]gas, Rgas,report]*)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso del Combustore ;*)
(*	"massflowIN": portata in massa d'aria specifica in input nel post bruciatore;*)
(*	"\[Eta]b" : rendimento di combustione del Post Bruciatore(es. \[Eta]b=0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Post Bruciatore (es. \[Eta]pb=0.95);*)
(*	"Qf": potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile.  es. Qf = 43*10^6J/kg);*)
(*	"T02": temperatura massima ammissibile a valle del Post Bruciatore (es. T02 = 1800K);*)
(*	"\[Gamma]air, Rair, \[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*	"report": variabile booleana di stampa*)
(**)
(*OUTPUT :  { pntOut { }, f, heat }*)
(*	pntOut { p02, T02, \[Rho]02, s02 } stato all'esterno del Combustore;*)
(*	"f": rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*	 "heat": calore (potenza) specifica dell'AfterBurner (specifica rispetto alla portata d'aria elaborata) [ KJ/kg = kW/(kg/s) ];*)


AfterBurnerCombustionCantera[pythonExe_,pntIn_,T02_,fuel_,oxid_,\[Eta]b_,\[Eta]pb_,Qf_,\[Gamma]gas_,Rgas_,report_]:=Module[
{p01,T01,\[Rho]01,s01,p02,\[Rho]02,s02,tol,maxIter,phiFunc,phiGoal,f,pntOut,heat,Values,Units,ValuesAndUnits,
species,selectedSpecies,speciesValues,fullTableHeaders,manyPhi,manyEqui,mainPlot,coPlot,noPlot,cpCantera},

{p01,T01,\[Rho]01,s01}=pntIn;
tol=10^-6;
maxIter=10;
phiFunc[phi_]:=T02-runCantera[pythonExe,T01,p01,phi,fuel,oxid][[1]];
phiGoal=SecantMethod[phiFunc,{x,0.3,0.9},maxIter,tol];
f=phiGoal[[-1]]/14.702534;


p02=\[Eta]pb*p01;
\[Rho]02=\[Rho][p02,T02,Rgas];
s02=s[p02,T02,\[Gamma]gas,Rgas];
pntOut={p02,T02,\[Rho]02,s02};
heat=f*Qf*\[Eta]b;

cpCantera=cpProdottiCantera[pythonExe,T01,p01,phiGoal[[-1]],fuel,oxid];
species=runCantera[pythonExe,T01,p01,phiGoal[[-1]],fuel,oxid][[3]];
selectedSpecies=Select[species,MemberQ[{"NO","NO2","CO","CO2","H2O","O2"},#[[1]]]&];
speciesValues=selectedSpecies[[All,2]];

manyPhi=Table[i,{i,0.2,2,0.05}];
manyEqui=Table[runCantera[pythonExe,T01,p01,manyPhi[[i]],fuel,oxid],{i,1,Length[manyPhi]}];
mainPlot=ListLinePlot[Table[{manyPhi[[i]],manyEqui[[i,1]]},{i,1,Length[manyPhi]}],PlotLabel->"Equilibrium Temperature vs Equivalence Ratio",AxesLabel->{"Phi","Temperature (K)"},PlotStyle->Red];
coPlot=ListLinePlot[Table[{manyPhi[[i]],"CO"/. manyEqui[[i,3]]},{i,1,Length[manyPhi]}],PlotLabel->"CO Concentration vs Equivalence Ratio",AxesLabel->{"Phi","CO Concentration"},PlotStyle->Blue];
noPlot=ListLinePlot[Table[{manyPhi[[i]],"NO"/. manyEqui[[i,3]]},{i,1,Length[manyPhi]}],PlotLabel->"NO Concentration vs Equivalence Ratio",AxesLabel->{"Phi","NO Concentration"},PlotStyle->Green];

If[report,Units=Join[{"",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K",""," kJ/kg"," J/(kg*K)"},Table["",{Length[speciesValues]}]];
Values=Join[{\[Eta]pb,\[Eta]b,p02/1000,T02,\[Rho]02,s02/1000,f,heat/1000,cpCantera},speciesValues];
fullTableHeaders=Join[{"\!\(\*SubscriptBox[\"\[Eta]\", \"pb\"]\)","\!\(\*SubscriptBox[\"\[Eta]\", \"b\"]\)","\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)",
"\!\(\*SubscriptBox[\"s\", \"02\"]\)","f","Specific power","cpProdotti"},{"NOem","NO2em","COem","CO2em","H2O","O2"}];
ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
Print["Burner Parameters"];
Print[TableForm[{ValuesAndUnits},TableHeadings->{None,fullTableHeaders},TableDirections->Row]];
Print[""];
Print[mainPlot];
Print[coPlot];
Print[noPlot];];

{pntOut,f,heat,cpCantera,selectedSpecies}

]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*NozzleExpansion*)


(* ::Text:: *)
(*Modulo che calcola la Espansione nell' Ugello*)
(**)
(*INPUT : [pntIn { }, massflow, pa, n, \[Gamma]gas, Rgas,report]*)
(**)
(*	pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso dell'Ugello ;*)
(*	"massflow": portata in massa d'aria specifica elaborata dall' Ugello (specificata rispetto alla portata d'aria primaria) [adimensionale]*)
(*	"pa": pressione atmosferica;*)
(*	"\[Eta]n": rendimento adiabatico dell' Ugello (es. 0.9);*)
(*	"\[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*	"report": variabile booleana di stampa*)
(*	*)
(*OUTPUT :  {pntOut { }, pnt0Out { }, ue, Me, ratioNozzle, work}*)
(**)
(*	pntOut { pe, Te, \[Rho]e, se }  grandezze STATICHE all'esterno dell' Ugello;*)
(*	pnt0Out { p02, T02, \[Rho]02, s02 }  grandezze GLOBALI all'esterno dell' Ugello;*)
(*	"ue": velocit\[AGrave] di efflusso [m/s];*)
(*	"ratioNozzle": rapporto di espansione dell' Ugello;*)
(*	"work": potenza specifica dell' Ugello (specifica rispetto alla portata d'aria primaria elaborata) [ KJ/kg = kW/(kg/s) ];*)


NozzleExpansion[pntIn_,massflow_,pa_,\[Eta]n_,cpB_,\[Gamma]gas_,Rgas_,report_,convergent_:True]:=Module[
	{p01,T01,\[Rho]01,s01,
	T02,p02,\[Rho]02,s02,
	Te,pe,\[Rho]e,se,
	ue,Me,gap,
	criticRatio,pCrit,ratioNozzle,work,
	pntOut,pnt0Out,
	Values,Units,ValuesAndUnits},

	
	{p01,T01,\[Rho]01,s01}=pntIn;

(* Calcolo della pressione critica pCrit
criticRatio = p01 / criticPressure *)

	criticRatio=1/(1-1/\[Eta]n ((\[Gamma]gas-1)/(\[Gamma]gas+1)))^(\[Gamma]gas/(\[Gamma]gas-1));

	pCrit=p01/criticRatio;



(* Controlla che la pressione a monte dell'ugello non sia pi\[UGrave] bassa della pressione ambiente *)
	If[pa>p01, If[report,Print["Error - Turbine exit Stagnation Pressure pe = ", pCrit," below atmospheric pressure ",pa," !"]];(*False second If*)
				Print["Edit design parameters!";Abort[]]];

(* Verifica le condizioni di ugello adattato o in chocking *)	
	If[pa>=pCrit,
		If[report,Print["Nozzle is adapted"]]; pe=pa; ratioNozzle=p01/pa,
		If[report,Print["Nozzle is choked"]];  
			If[convergent,
				ratioNozzle=criticRatio;pe=pCrit;If[report, Print["Convergent nozzle is underexpanded"]],
				ratioNozzle=p01/pa;pe=pa;If[report,Print["Convergent-divergent nozzle is adapted"]]
			]
	];



(* Grandezze STATICHE *)
	Te=T01 (1-\[Eta]n (1-ratioNozzle^(-((\[Gamma]gas-1)/\[Gamma]gas))));
	\[Rho]e=\[Rho][pe,Te,Rgas];
	se=s[pe,Te,\[Gamma]gas, Rgas];

	pntOut={pe,Te,\[Rho]e,se};


(* Grandezze GLOBALI *)
	T02=T01;
	p02 = p01 /(1+1/\[Eta]n (T02/Te-1))^((\[Gamma]gas-1)/\[Gamma]gas);
	s02=s[p02,T02,\[Gamma]gas, Rgas];
	\[Rho]02=\[Rho][p02,T02,Rgas];

	pnt0Out={p02,T02,\[Rho]02,s02};


	ue=Sqrt[2 cpB (T01-Te)];
	Me=ue/Sqrt[\[Gamma]gas*Rgas*Te];
	work=massflow *cpB*(T01-T02);



(*Stampa dei parametri*)

	If[report,

		Print["Nozzle Static Conditions"];
		Units={""," m/s",""," kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"};
		Values=Join[ratioNozzle,ue,Me,pe/1000,Te,\[Rho]e,se/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"Pressure ratio nozzle","Speed","Mach","\!\(\*SubscriptBox[\"p\", \"e\"]\)","\!\(\*SubscriptBox[\"T\", \"e\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"e\"]\)","\!\(\*SubscriptBox[\"s\", \"e\"]\)"}},TableDirections->Row
		]];
		
		Print[""];
		Units=0; Values=0;ValuesAndUnits;
		Print["Nozzle Stagnation Conditions"];
		Units={" kPa"," K"," kg/\!\(\*SuperscriptBox[\"m\", \"3\"]\)"," kJ/K"};
		Values=Join[p02/1000,T02,\[Rho]02,s02/1000];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"p\", \"02\"]\)","\!\(\*SubscriptBox[\"T\", \"02\"]\)","\!\(\*SubscriptBox[\"\[Rho]\", \"02\"]\)","\!\(\*SubscriptBox[\"s\", \"02\"]\)"}},TableDirections->Row
		]];
		Print[""];
	];	


	{pntOut,pnt0Out,ue,Me}
]


(* ::Subsection:: *)
(*Calcolo iterativo di \[Beta]f*)


(* ::Subsubsection::RGBColor[0, 0, 1]:: *)
(*Calcolo iterativo di \[Beta]f*)


(* ::Text:: *)
(*Modulo che calcola iterativamente \[Beta]f*)
(**)
(*		INPUT : [BPR,\[Epsilon]1,\[Epsilon]2,PNT02,\[Beta]c,\[Eta]pf,\[Eta]pc,\[Eta]pt,\[Eta]b,\[Eta]pb,\[Eta]mf,\[Eta]mc,\[Eta]mt,Qf,T4,\[Gamma]air,Rair,\[Gamma]gas,Rgas,eport]*)
(*			"BPR": rapporto di bypass;*)
(*			"\[Epsilon]1": rapporto di bypass per raffreddamento della HPT;*)
(*			"\[Epsilon]2": rapporto di bypass per raffreddamento della LPT;*)
(*			PNT02 { p02, T02, \[Rho]02, s02 }  stato all'ingresso del Fan ;*)
(*			"\[Beta]c": rapporto di compressione del Compressore*)
(*			"\[Eta]pf" : rendimento politropico del compressore/fan;*)
(*			"\[Eta]pc" : rendimento politropico del compressore/fan;*)
(*			"\[Eta]pt" : rendimento politropico della turbina;*)
(*			"\[Eta]b" : rendimento di combustione (es. \[Eta]b=0.99);*)
(*			"\[Eta]pb" : rendimento pneumatico del Combustore (es. \[Eta]pb=0.95);*)
(*			"\[Eta]mf" : rendimento meccanico del Fan collegato alla Turbina (es. 0.87);*)
(*			"\[Eta]mc" : rendimento meccanico del Compressore collegato alla Turbina (es. 0.87);*)
(*			"\[Eta]mt" : rendimento meccanico della Turbina (es. 0.99);*)
(*			"Qf": potere calorifico del combustibile (calore o energia rilasciata per unit\[AGrave] di massa del combustibile.  es. Qf = 43*10^6J/kg);*)
(*			"T4": temperatura massima ammissibile in Turbina (es. T02 = 1420K);*)
(*			"\[Gamma]air,Rair,\[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*			"report": variabile booleana di stampa*)
(**)
(*		OUTPUT : {\[Beta]f,err}*)
(*			"\[Beta]f": rapporto di compressione del Fan*)
(*			"err": errore finale tra la pressione in uscita dalla LPT e quella in uscita dal Fan*)


CalcoloIterativo\[Beta]f[pythonExe_,BPR_,\[Epsilon]1_,\[Epsilon]2_,PNT02_,\[Beta]c_,\[Eta]pf_,\[Eta]pc_,\[Eta]pt_,\[Eta]b_,\[Eta]pb_,\[Eta]mf_,\[Eta]mc_,\[Eta]mt_,Qf_,T4_,\[Gamma]air_,Rair_,\[Gamma]gas_,Rgas_,JP8_,oxid_,EquilibriumPath_,combustion_,report_]:=Module[
	{\[Beta]f,\[Beta]fIter,err,deltaP,maxIter,tolX,tolY,
	p02,T02,\[Rho]02,s02,
	p021,T021,\[Rho]021,s021,
	p03,T03,\[Rho]03,s03,
	p05,T05,\[Rho]05,s05,
	massflowIN,massflowOUT,cpB,
	selectedSpecies,
	PNT021,PNT03,PNT04,PNT04b,PNT041,PNT041b,PNT05,
	\[Eta]f,\[Eta]c,\[Eta]t,
	workF,workC,workHPT,heatB,
	f1,\[Beta]c1,T021b,
	Values,Units,ValuesAndUnits},
	
	{p02,T02,\[Rho]02,s02}=PNT02;
	
	deltaP[\[Beta]f_]:=Module[{delta},

	(* FAN OUTLET CONDITIONS *)
		massflowIN=massflowOUT=1.0+BPR+\[Epsilon]1+\[Epsilon]2;
		{PNT021,\[Eta]f,workF}=CompressorCompression[PNT02,massflowIN,massflowOUT,\[Beta]f,\[Eta]pf,\[Gamma]air,Rair,False];
		{p021,T021,\[Rho]021,s021}=PNT021;
	
	(* COMPRESSOR OUTLET CONDITIONS *)
		massflowIN=1.0+\[Epsilon]1+\[Epsilon]2;
		massflowOUT=1.0+\[Epsilon]1;
		{PNT03,\[Eta]c,workC}=CompressorCompression[PNT021,massflowIN,massflowOUT,\[Beta]c,\[Eta]pc,\[Gamma]air,Rair,False];
		{p03,T03,\[Rho]03,s03}=PNT03;

	(* BURNER *)
		Which[
			combustion == "default",
				{PNT04,f1,heatB}=BurnerCombustion[PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]air,Rair,\[Gamma]gas,Rgas,False];
				cpB=cp[\[Gamma]gas,Rgas],
			combustion == "cantera",
				{PNT04,f1,heatB,cpB,selectedSpecies}=BurnerCombustionCantera[pythonExe,PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]gas,Rgas,JP8,oxid,EquilibriumPath,False],
			combustion == "interpolation",
				{PNT04,f1,heatB,cpB}=BurnerCombustionInterpolation[PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]gas,Rgas,False]
		];

	(* COOLANT MIXER 1 OUTLET CONDITION (MOD) *)
		massflowIN=1.0+f1;
		massflowOUT=1.0+f1+\[Epsilon]1;
		PNT04b=MixerMiscelation[PNT04,massflowIN,\[Epsilon]1,T03,cpB,\[Gamma]air,Rair,\[Gamma]gas,Rgas,False];

	(* HPT TURBINE EXPANSION (MOD) *)
		massflowIN=massflowOUT=1.0+f1+\[Epsilon]1;
		{PNT041,workHPT,\[Beta]c1,T021b,\[Eta]t}=TurbineExpansionHPT[PNT04b,\[Beta]c,\[Eta]pt,p021,T021,T03,\[Eta]c,\[Eta]mc,\[Eta]mt,\[Epsilon]1,\[Epsilon]2,massflowIN,massflowOUT,\[Gamma]air,Rair,cpB,\[Gamma]gas,Rgas,False];

	(* COOLANT MIXER 2 OUTLET CONDITION (MOD) *)
		massflowIN=1.0+f1+\[Epsilon]1;
		massflowOUT=1.0+f1+\[Epsilon]1+\[Epsilon]2;
		PNT041b=MixerMiscelation[PNT041,massflowIN,\[Epsilon]2,T021b,cpB,\[Gamma]air,Rair,\[Gamma]gas,Rgas,False];

	(* LPT TURBINE EXPANSION ITERATIVO (MOD) *)
		PNT05=TurbineExpansionLPTiterativo[PNT041b,massflowIN,\[Epsilon]1,\[Epsilon]2,BPR,T021,T02,\[Eta]t,\[Eta]mf,\[Eta]mt,\[Gamma]air,Rair,cpB,\[Gamma]gas,Rgas];
		{p05,T05,\[Rho]05,s05}=PNT05;
		
		delta=(p021-p05);
		delta
	];
		maxIter=100;
		tolX=10^-6;
		tolY=1;
		\[Beta]fIter=SecantMethod[deltaP,{x,6,7},maxIter,tolX,tolY,False];	
		
		\[Beta]f=\[Beta]fIter[[-1]];
		err=deltaP[\[Beta]fIter[[-1]]];
	
	(*Stampa dei parametri*)

	If[report,
		
		Units={"",""," Pa"};
		Values=Join[\[Beta]c*\[Beta]f,\[Beta]f,err];
		ValuesAndUnits=Table[ToString[Values[[i]]]<>Units[[i]],{i,Length[Units]}];
		Print[TableForm[
			{ValuesAndUnits},TableHeadings->{None,{"\!\(\*SubscriptBox[\"\[Beta]\", \"cTOT\"]\)","\!\(\*SubscriptBox[\"\[Beta]\", \"f\"]\)","Errore"}},TableDirections->Row
		]];
		Print[""];
			
	];	
	
	{\[Beta]f,err}
]


(* ::Subsubsection::RGBColor[0, 0, 1]::Closed:: *)
(*TurbineExpansion LPT per l'iterazione di \[Beta]f*)


(* ::Text:: *)
(*	Modulo che calcola la Espansione nella Turbina LPT durante il ciclo while iterativo per ricavarsi \[Beta]f*)
(**)
(*		INPUT : [pntIn { }, massflowIN,\[Epsilon]1,\[Epsilon]2,BPR,Tfan,Td, \[Eta]t, \[Eta]mf, \[Eta]mt, \[Gamma]air,Rair,\[Gamma]gas, Rgas]*)
(*			pntIn { p01, T01, \[Rho]01, s01 }  stato all'ingresso della Turbina ;*)
(*			"massflowIN"*)
(*			"\[Epsilon]1": rapporto di bypass per raffreddamento della HPT;*)
(*			"\[Epsilon]2": rapporto di bypass per raffreddamento della LPT;*)
(*			"BPR": rapporto di bypass;*)
(*			"Tfan": temperatura in uscita dal fan*)
(*			"Td": temperatura in uscita dal diffusore*)
(*			"\[Eta]t": rendimento adiabatico della Turbina (es. 0.9);*)
(*			"f": rapporto fra le portate in massa di combustibile e aria elaborata dal Combustore ( f = m_fuel / m_air );*)
(*			"\[Eta]mf" : rendimento meccanico del Fan collegato alla Turbina (es. 0.87);*)
(*			"\[Eta]mt" : rendimento meccanico della Turbina (es. 0.99);*)
(*			"\[Gamma]air,Rair,\[Gamma]gas, Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*		*)
(*		NB. l'input "report" non \[EGrave] presente perch\[EAcute] questo modulo serve solo a darmi gli output della LPT senza considerare l'HP di pressione coincidente con quella in uscita dal Fan, il che mi servir\[AGrave] *)
(*			per confrontare le due pressione e stimare l'errore, cos\[IGrave] da poter andare avanti con l'iterazione*)
(**)
(*		OUTPUT :  pntOut { }*)
(*			pntOut { p02, T02, \[Rho]02, s02 }  stato all'esterno della Turbina;*)


TurbineExpansionLPTiterativo[pntIn_,massflowIN_,\[Epsilon]1_,\[Epsilon]2_,BPR_,Tfan_,Td_,\[Eta]t_,\[Eta]mf_,\[Eta]mt_,\[Gamma]air_,Rair_,cpB_,\[Gamma]gas_,Rgas_]:=Module[
	{p01,T01,\[Rho]01,s01,
	p02,T02,\[Rho]02,s02,
	pntOut,
	Values,Units,ValuesAndUnits},

	{p01,T01,\[Rho]01,s01}=pntIn;

	T02=T01-(cp[\[Gamma]air,Rair]*(1+\[Epsilon]1+\[Epsilon]2+BPR)*(Tfan-Td))/(\[Eta]mf*\[Eta]mt*cpB*massflowIN);
	p02=p01*(1-(1-T02/T01)/(\[Eta]t))^(\[Gamma]gas/(\[Gamma]gas-1));
	
	\[Rho]02=\[Rho][p02,T02,Rgas];
	s02=s[p02,T02,\[Gamma]gas, Rgas];
	


	pntOut={p02,T02,\[Rho]02,s02};


	pntOut
]


(* ::Subsection::GrayLevel[0]::Closed:: *)
(*Turbojet Cycle & Performance*)


(* ::Text:: *)
(*Modulo che calcola il ciclo di un motore Turbogetto *)
(**)
(*INPUT : [h, Ma, \[Gamma]air, Rair, \[Eta]d,, \[Beta]c, \[Eta]c, \[Eta]mc, \[Eta]b, \[Eta]pb, Qf, T4, \[Gamma]gas, Rgas, \[Eta]t, \[Eta]mt, \[Eta]n,report]*)
(**)
(*	"h": quota [m] ;*)
(*	"Ma": Mach di volo [adim.];*)
(*	"\[Gamma]air , Rair" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*	"\[Eta]d" : rendimento adiabatico del Diffusore [adim.];*)
(*	"\[Beta]c": rapporto di compressione del Compressore [adim.];*)
(*            "\[Eta]c": rendimento adiabatico del Compressore [adim.];*)
(*            "\[Eta]mc": rendimento meccanico del Compressore [adim.];*)
(*            "\[Eta]b" : rendimento di combustione (es. \[Eta]b=0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Combustore (es. \[Eta]pb=0.95);*)
(*            "Qf": potere calorifico del comcustibile [J/kg];*)
(*            "T4": temperatura max ammissibile in turbina [K];*)
(*            "\[Gamma]gas , Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K);*)
(*             "\[Eta]t": rendimento adiabatico della Turbina [adim.];*)
(*             "\[Eta]mt": rendimento meccanico della Turbina [adim.];*)
(*             "\[Eta]n": rendimento adiabatico dell'Ugello [adim.];*)
(*	"report": variabile booleana di stampa;*)
(*	"nozzleType" : [optional string] "convergent" o "adapted" *)
(*	*)
(*  OUTPUT : {Points, energy, performance}*)
(*   *)
(*   	"Points": vettore dei punti rappresentanti il ciclo *)
(*   	"energy": vettore contenente i lavori compiuti da ciascun componente (presa dinamica, compressore, turbina, ugello)*)
(*   	"performance": vettore contenente i valori delle principali prestazioni del motore 	*)
(*	*)


CalcTurbojetCycle[Ma_,h_,\[Gamma]air_,Rair_,\[Eta]d_,\[Eta]mc_,\[Eta]c_,\[Beta]c_,Qf_,\[Gamma]gas_,Rgas_,\[Eta]b_,\[Eta]pb_,T4_,\[Eta]t_,\[Eta]mt_,\[Eta]n_,report_,nozzleType_:"convergent"]:=Module[
	{pa,Ta,\[Rho]a,sa,
	p0a,T0a,\[Rho]0a,s0a,
	p02,T02,\[Rho]02,s02,
	p03,T03,\[Rho]03,s03,
	p04,T04,\[Rho]04,s04,
	p05,T05,\[Rho]05,s05,
	p09,T09,\[Rho]09,s09,
	p9,T9,\[Rho]9,s9,
	PNTa,PNT0a,PNT02,PNT03,PNT04,PNT05,PNT09,PNT9,
	convergentNozzle,
	Va,
	A9,
	massflow,f,heat,
	ue,Me,
	ratioD,ratioT,ratioN,
	workD,workF,workC,workT,workN,
	impulseSpecificCoreThrust,impulseSpecificFanThrust,impulseSpecificThrust,pressureSpecificCoreThrust,pressureSpecificFanThrust,pressureSpecificThrust,specificThrust,
	Ia,TSFC,
	ueff,
	Pav,Pp,Pd,Pj,
	\[Eta]th,\[Eta]p,\[Eta]o,
	Points,energy,performance,
	UnitMisPer,ValuePerfor
	},


	If[report,
		Print[Style["Engine Input Data",14,Bold,Red]];
		Print[Style["Engine Type: TurboJet"]];
		Print[TableForm[
			{\[Beta]c,T4},
			TableHeadings->{{"\[Beta]c","T4"},None}
		]];
		Print[""];
	
		Print[Style["Adiabatic efficiencies"]];
		Print[TableForm[
				{\[Eta]d,\[Eta]c,\[Eta]b,\[Eta]t,\[Eta]n},
				TableHeadings->{{"\[Eta]d","\[Eta]c","\[Eta]b","\[Eta]t","\[Eta]n"},None}
			]
		];
		Print[""];
		
		Print[Style["Mechanical & pneumatic efficiencies"]];
		Print[TableForm[
				{\[Eta]mc,\[Eta]mt,\[Eta]pb},
			TableHeadings->{{"\[Eta]mc","\[Eta]mt","\[Eta]pb"},None}
		]];
		Print[""];
		Print[Style["Analysis Output",14,Bold,Blue]];

	];



(* FREE STREAM CONDITIONS *)
	If[report,Print[Style["Free Stream Condition",12,Bold,Blue]]];
	{PNTa,PNT0a,Va}=FreeStream[h,Ma,\[Gamma]air,Rair,report];
	{pa,Ta,\[Rho]a,sa}=PNTa;
	{p0a,T0a,\[Rho]0a,s0a}=PNT0a;

(* DIFFUSOR OUTLET CONDITIONS *)
	If[report,Print[Style["Ram diffusion",12,Bold,Blue]]];
	{PNT02,ratioD,workD}=DiffuserCompression[PNT0a,Ma,pa,\[Eta]d,\[Gamma]air,Rair,report];
	{p02,T02,\[Rho]02,s02}=PNT02;

(* COMPRESSOR OUTLET CONDITIONS *)
	If[report,Print[Style["Compressor compression",12,Bold,Blue]]];
	massflow=1.0;
	{PNT03,workC}=CompressorCompression[PNT02,massflow,\[Beta]c,\[Eta]c,\[Gamma]air,Rair,report];
	{p03,T03,\[Rho]03,s03}=PNT03;

(* BURNER *)
	If[report,Print[Style["Burner",12,Bold,Blue]]];
	{PNT04,f,heat}=BurnerCombustion[PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]air,Rair,\[Gamma]gas,Rgas,report];
	{p04,T04,\[Rho]04,s04}=PNT04;

(* TURBINE EXPANSION *)
	If[report,Print[Style["Turbine expansion",12,Bold,Blue]]];
	{PNT05,ratioT,workT}=TurbineExpansion[PNT04,workC,\[Eta]t,f,\[Eta]mc,\[Eta]mt,\[Gamma]gas,Rgas,report];
	{p05,T05,\[Rho]05,s05}=PNT05;

(* NOZZLE EXPANSION *)
	If[nozzleType == "convergent",
       convergentNozzle=True,
       If[nozzleType == "adapted",
         convergentNozzle=False,
         Print["Unknown nozzle type ", nozzleType], Abort[]
      ]
    ];
	If[report,Print[Style["Nozzle expansion ",12,Bold,Blue]]];
	massflow=1.0;
	{PNT9,PNT09,ue,Me,ratioN,workN}=NozzleExpansion[PNT05,massflow,pa,\[Eta]n,\[Gamma]gas,Rgas,report,convergentNozzle];
	{p9,T9,\[Rho]9,s9}=PNT9;
	{p09,T09,\[Rho]09,s09}=PNT09;

	Points={PNTa,PNT02,PNT03,PNT04,PNT05,PNT9};
	energy={workD,workC,workT,workN};


(* ENGINE PERFORMANCE *)

(* aree delle sezioni di uscita degli ugelli -primario e secondario- specificate secondo la portata primaria e ottenute secondo la relazione isentropica portataMassa=\[Rho]*A*u *)
	A9=1/( \[Rho]9 ue);

(* Calcolo spinta specifica rispetto alla portata primaria *)
	impulseSpecificThrust=(1+f)ue-Va;
	pressureSpecificThrust=A9 (p9-pa);
	Ia=impulseSpecificThrust+pressureSpecificThrust;
	
	If[nozzleType=="convergent",
	ueff = Ia, (*use effective exhaust speed, which accounts for pressure thrust in power formulas*)
	ueff = ue];
	
(* Calcolo del consumo specifico in Kg/(h N)*)
	TSFC=3600 f/Ia;

(* Calcolo della potenza disponibile *)
	Pav=f (Qf+Va^2/2);

(* Calcolo della potenza propulsiva *)
	Pp=Ia Va;

(* Calcolo della potenza dissipata *)
	Pd=(1+f) (ueff-Va)^2;

(* Calcolo della potenza del getto  *)
	Pj = 0.5 * (1 + f) * ueff^2 - 0.5 * Va^2;
	
(* Calcolo dei rendimenti *)

(* Rendimento termodinamico*)
	\[Eta]th=Pj/Pav;

(* Rendimento propulsivo *)
	\[Eta]p=Pp/Pj;

(* Rendimento overall *)
	\[Eta]o=Pp/Pav;

	performance={Ia,TSFC,\[Eta]o,\[Eta]th,\[Eta]p,ue};

	If[report,
		UnitMisPer={" m/s"," N\[CenterDot]kg/h","","",""};
		ValuePerfor=Table[ToString[performance[[i]]]<>UnitMisPer[[i]],{i,5}];
		Print[Style["Engine Performance Parameters",12,Bold,Blue]];
		Print[TableForm[
			{ValuePerfor},TableHeadings->{None,{"Ia","TSFC","\[Eta]0","\[Eta]th","\[Eta]p"}},TableDirections->Row
		]];
	];

	{Points,energy,performance}
]


(* ::Subsection::GrayLevel[0]:: *)
(*Turbofan Cycle & Performance MOD: CONSIDERANDO FLUSSI ASSOCIATI CONSIDERANDO IL POST BRUCIATORE*)


(* ::Text:: *)
(*Modulo che calcola il ciclo di un motore TurboFan a Flussi Associati con Post Bruciatore iterando \[Beta]f*)
(**)
(*INPUT : [Ma, h,\[Gamma]air, Rair, \[Eta]d, \[Eta]pf, \[Eta]mf, BPR, \[Eta]pc, \[Eta]mc, \[Beta]c,\[Epsilon]1,\[Epsilon]2,Qf,\[Gamma]gas, Rgas,\[Eta]b, \[Eta]ab,\[Eta]pb,\[Eta]pab , T4, T7, \[Eta]pt, \[Eta]mt, \[Eta]n,report,nozzleType,afterburnerONOFF]*)
(**)
(*	"Ma": Mach di volo [adim.];*)
(*	"h": quota [m] ;*)
(*	"\[Gamma]air , Rair" : propriet\[AGrave] del gas (es. Per l'aria secca \[Gamma] = 1.4, R = 287.05 J/kg/K);*)
(*	"\[Eta]d" : rendimento adiabatico del Diffusore [adim.];*)
(*	"\[Eta]pf": rendimento politropico del Fan [adim.]; *)
(*	"\[Eta]mf": rendimento meccanico del Fan [adim.];*)
(*	"BPR": rapporto di by-pass [adim.]; *)
(*	"\[Eta]pc": rendimento politropico del Compressore [adim.];*)
(*	"\[Eta]mc": rendimento meccanico del Compressore [adim.];*)
(*	"\[Beta]c": rapporto di compressione del Compressore [adim.];*)
(*	"\[Epsilon]1": rapporto di bypass per raffreddamento della HPT*)
(*	"\[Epsilon]2": rapporto di bypass per raffreddamento della LPT*)
(*	"Qf": potere calorifico del comcustibile [J/kg];*)
(*	"\[Gamma]gas , Rgas" : propriet\[AGrave] del gas (es. Per gas combusti  \[Gamma]gas = 1.34, Rgas=286.77 J/kg/K); *)
(*	"\[Eta]b" : rendimento di combustione (es. \[Eta]b=0.99);*)
(*	"\[Eta]ab" : rendimento di combustione nel Post Bruciatore (es. \[Eta]b2=0.99);*)
(*	"\[Eta]pb" : rendimento pneumatico del Combustore (es. \[Eta]pb=0.95);*)
(*	"\[Eta]pab" : rendimento pneumatico del Post Bruciatore (es. \[Eta]pb2=0.95);*)
(*	"T4": temperatura max ammissibile in Turbina [K];*)
(*	"T7": temperatura max ammissibile a valle del Post Bruciatore [K]*)
(*	"\[Eta]pt": rendimento politropico della Turbina [adim.];*)
(*	"\[Eta]mt": rendimento meccanico della Turbina [adim.];*)
(*	"\[Eta]n": rendimento adiabatico dell'Ugello [adim.];*)
(*	"report": variabile booleana di stampa;*)
(*	"nozzleType": stringa che esprime se l'ugello \[EGrave] convergente oppure adattato*)
(*	"afterburnerONOFF": stringa che esprime se l'afterburner \[EGrave] acceso o spento*)
(*	*)
(*  OUTPUT : {corePoints, fanPoints, energy, performance}*)
(*   *)
(*   	"corePoints": vettore dei punti rappresentanti il ciclo relativo alla portata primaria*)
(*   	"fanPoints": vettore dei punti rappresentanti il ciclo relativo alla portata secondaria*)
(*   	"energy": vettore dei lavori specifici delle componenti meccaniche e dei bruciatori*)
(*   	"performance": vettore contenente i valori delle principali prestazioni del motore 	*)
(*	*)


CalcTurboFanCycle[pythonExe_,Ma_,h_,\[Gamma]air_,Rair_,\[Eta]d_,\[Eta]pf_,\[Eta]mf_,BPR_,\[Eta]pc_,\[Eta]mc_,\[Beta]c_,\[Epsilon]1_,\[Epsilon]2_,Qf_,\[Gamma]gas_,Rgas_,\[Eta]b_,\[Eta]ab_,\[Eta]pb_,\[Eta]pab_,T4max_,TR_,T7_,\[Eta]pt_,\[Eta]mt_,\[Eta]n_,JP8_,oxid_,equilibriumPath_,report_,nozzleType_:"adapted",afterburnerONOFF_:"off",combustion_:"interpolation"]:=Module[
	{\[Eta]f,\[Eta]c,\[Eta]t,
	pa,Ta,\[Rho]a,sa,
	p0a,T0a,\[Rho]0a,s0a,
	p02,T02,\[Rho]02,s02,
	p021,T021,\[Rho]021,s021,
	T021b,
	p03,T03,\[Rho]03,s03,
	p04,T04,\[Rho]04,s04,
	p04b,T04b,\[Rho]04b,s04b,
	p041,T041,\[Rho]041,s041,
	p041b,T041b,\[Rho]041b,s041b,
	p05,T05,\[Rho]05,s05,
	p06,T06,\[Rho]06,s06,
	p07,T07,\[Rho]07,s07,
	p9,T9,\[Rho]9,s9,
	p09,T09,\[Rho]09,s09,
	PNTa,PNT0a,PNT02,PNT021,PNT03,PNT04,PNT04b,PNT041,PNT041b,PNT05,PNT06,PNT07,PNT9,PNT09,
	Va,
	massflowIN,massflowOUT,f,f2,\[Beta]c1,\[Beta]f,err,
	f1,cpB,selectedSpecies,T4,
	ue,Me,
	workD,workF,workC,workHPT,workLPT,heatB,heatAB,
	A9,
	ueeff,
	convergentNozzle,afterburner,
	impulseSpecificThrust,pressureSpecificThrust,specificThrust,
	Ia,TSFC,
	Pav,Pp,Pd,Pj,
	\[Eta]th,\[Eta]p,\[Eta]o,
	corePoints,fanPoints,energy,performance,beta,
	UnitMisPer,ValuePerfor
	},
	

	T4 = If[\[Theta]0std[h, Ma] < TR, T4max * (\[Theta]0std[h, Ma] / TR), T4max];

	If[report,
		Print[Style["Engine Input Data",14,Bold,Red]];
		Print[Style["Engine Type: TurboFan separate flows"]];
		Print[TableForm[
			{\[Beta]c,BPR,T4,T7,\[Epsilon]1,\[Epsilon]2},
			TableHeadings->{{"\[Beta]c","BPR","T4","T7","\[Epsilon]1","\[Epsilon]2"},None}
		]];
		Print[""];
		
		Print[Style["Polytropic efficiencies"]];
		Print[TableForm[
				{\[Eta]pf,\[Eta]pc,\[Eta]pt},
				TableHeadings->{{"\[Eta]pf","\[Eta]pc","\[Eta]pt"},None}
			]
		];
		Print[""];
		
		Print[Style["Adiabatic efficiencies"]];
		Print[TableForm[
				{\[Eta]d,\[Eta]b,\[Eta]ab,\[Eta]n},
				TableHeadings->{{"\[Eta]d","\[Eta]b","\[Eta]ab","\[Eta]n"},None}
			]
		];
		Print[""];
		
		Print[Style["Mechanical & pneumatic efficiencies"]];
		Print[TableForm[
				{\[Eta]mf,\[Eta]mc,\[Eta]mt,\[Eta]pb,\[Eta]pab},
			TableHeadings->{{"\[Eta]mf","\[Eta]mc","\[Eta]mt","\[Eta]pb","\[Eta]pab"},None}
		]];
		Print[""];
		Print[Style["Analysis Output",14,Bold,Blue]];

	];
	
	If[nozzleType == "convergent",
       convergentNozzle=True,
       If[nozzleType == "adapted",
         convergentNozzle=False,
         Print["Unknown nozzle type ", nozzleType], Abort[]
      ]
    ];
	If[afterburnerONOFF == "off",
		afterburner=False,
		If[afterburnerONOFF == "on",
			afterburner=True,
			Print["Unknown if afterburner is on or off", afterburnerONOFF], Abort[]
		]
	];

(* FREE STREAM CONDITIONS *)
	If[report,Print[Style["Free Stream Condition",12,Bold,Blue]]];
	{PNTa,PNT0a,Va}=FreeStream[h,Ma,\[Gamma]air,Rair,report];
	{pa,Ta,\[Rho]a,sa}=PNTa;
	{p0a,T0a,\[Rho]0a,s0a}=PNT0a;

(* DIFFUSOR OUTLET CONDITIONS *)
	If[report,Print[Style["Ram diffusion",12,Bold,Blue]]];
	{PNT02,workD}=DiffuserCompression[PNTa,Ma,pa,\[Epsilon]1,\[Epsilon]2,BPR,\[Eta]d,\[Gamma]air,Rair,report];
	{p02,T02,\[Rho]02,s02}=PNT02;
	
(* Calcolo Iterativo \[Beta]f *)
	If[report,Print[Style["Risultato dell'iterazione di \[Beta]f",12,Bold,Blue]]];
	{\[Beta]f,err}=CalcoloIterativo\[Beta]f[pythonExe,BPR,\[Epsilon]1,\[Epsilon]2,PNT02,\[Beta]c,\[Eta]pf,\[Eta]pc,\[Eta]pt,\[Eta]b,\[Eta]pb,\[Eta]mf,\[Eta]mc,\[Eta]mt,Qf,T4,\[Gamma]air,Rair,\[Gamma]gas,Rgas,JP8,oxid,equilibriumPath,combustion,report];

(* FAN OUTLET CONDITIONS *)
	If[report,Print[Style["Fan compression",12,Bold,Blue]]];
	massflowIN=massflowOUT=1.0+BPR+\[Epsilon]1+\[Epsilon]2;
	{PNT021,\[Eta]f,workF}=CompressorCompression[PNT02,massflowIN,massflowOUT,\[Beta]f,\[Eta]pf,\[Gamma]air,Rair,report];
	{p021,T021,\[Rho]021,s021}=PNT021;

(* COMPRESSOR OUTLET CONDITIONS *)
	If[report,Print[Style["Compressor compression",12,Bold,Blue]]];
	massflowIN=1.0+\[Epsilon]1+\[Epsilon]2;
	massflowOUT=1.0+\[Epsilon]1;
	{PNT03,\[Eta]c,workC}=CompressorCompression[PNT021,massflowIN,massflowOUT,\[Beta]c,\[Eta]pc,\[Gamma]air,Rair,report];
	{p03,T03,\[Rho]03,s03}=PNT03;

(* BURNER *)
	If[report,Print[Style["Burner",12,Bold,Blue]]];
	Which[
		combustion == "default",
			{PNT04,f1,heatB}=BurnerCombustion[PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]air,Rair,\[Gamma]gas,Rgas,report];
			cpB=cp[\[Gamma]gas,Rgas],
		combustion == "cantera",
			{PNT04,f1,heatB,cpB,selectedSpecies}=BurnerCombustionCantera[pythonExe,PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]gas,Rgas,JP8,oxid,equilibriumPath,report],
		combustion == "interpolation",
			{PNT04,f1,heatB,cpB}=BurnerCombustionInterpolation[PNT03,\[Eta]b,\[Eta]pb,Qf,T4,\[Gamma]gas,Rgas,report]
	];
	runCantera[pythonExe,T03,p03,f1,JP8,oxid,equilibriumPath];

(* COOLANT MIXER 1 OUTLET CONDITION (MOD) *)
	If[report,Print[Style["Coolant Mixer 1",12,Bold,Blue]]];
	massflowIN=1.0+f1;
	massflowOUT=1.0+f1+\[Epsilon]1;
	PNT04b=MixerMiscelation[PNT04,massflowIN,\[Epsilon]1,T03,cpB,\[Gamma]air,Rair,\[Gamma]gas,Rgas,report];
	{p04b,T04b,\[Rho]04b,s04b}=PNT04b;

(* HPT TURBINE EXPANSION (MOD) *)
	If[report,Print[Style["High Pressure Turbine expansion",12,Bold,Blue]]];
	massflowIN=massflowOUT=1.0+f1+\[Epsilon]1;
	{PNT041,workHPT,\[Beta]c1,T021b,\[Eta]t}=TurbineExpansionHPT[PNT04b,\[Beta]c,\[Eta]pt,p021,T021,T03,\[Eta]c,\[Eta]mc,\[Eta]mt,\[Epsilon]1,\[Epsilon]2,massflowIN,massflowOUT,\[Gamma]air,Rair,cpB,\[Gamma]gas,Rgas,report];
	{p041,T041,\[Rho]041,s041}=PNT041;

(* COOLANT MIXER 2 OUTLET CONDITION (MOD) *)
	If[report,Print[Style["Coolant Mixer 2",12,Bold,Blue]]];
	massflowIN=1.0+f1+\[Epsilon]1;
	massflowOUT=1.0+f1+\[Epsilon]1+\[Epsilon]2;
	PNT041b=MixerMiscelation[PNT041,massflowIN,\[Epsilon]2,T021b,cpB,\[Gamma]air,Rair,\[Gamma]gas,Rgas,report];
	{p041b,T041b,\[Rho]041b,s041b}=PNT041b;
	
(* LPT TURBINE EXPANSION (MOD) *)
	If[report,Print[Style["Low Pressure Turbine expansion",12,Bold,Blue]]];
	massflowIN=massflowOUT=1.0+f1+\[Epsilon]1+\[Epsilon]2;
	{PNT05,workLPT}=TurbineExpansionLPT[PNT041b,massflowIN,massflowOUT,p021,\[Eta]t,cpB,\[Gamma]gas,Rgas,report];
	{p05,T05,\[Rho]05,s05}=PNT05;

(* MIXER OUTLET CONDITION (MOD) *)
	If[report,Print[Style["Mixer",12,Bold,Blue]]];
	massflowIN=1.0+f1+\[Epsilon]1+\[Epsilon]2;
	massflowOUT=1.0+f1+\[Epsilon]1+\[Epsilon]2+BPR;
	PNT06=MixerMiscelation[PNT05,massflowIN,BPR,T021,cpB,\[Gamma]air,Rair,\[Gamma]gas,Rgas,report];
	{p06,T06,\[Rho]06,s06}=PNT06;
	
(* AfterBURNER *)
	If[report,Print[Style["AfterBurner",12,Bold,Blue]]];
	massflowIN=1.0+f1+\[Epsilon]1+\[Epsilon]2+BPR;
	{PNT07,f2,heatAB}=AfterBurnerCombustion[PNT06,massflowIN,\[Eta]ab,\[Eta]pab,Qf,T7,cpB,\[Gamma]gas,Rgas,report,afterburner];
	f=f1+f2;
	{p07,T07,\[Rho]07,s07}=PNT07;
	
(* NOZZLE EXPANSION (MOD) *)
	If[report,Print[Style["Nozzle expansion ",12,Bold,Blue]]];
	massflowIN=massflowOUT=1.0+f+\[Epsilon]1+\[Epsilon]2+BPR;
	{PNT9,PNT09,ue,Me}=NozzleExpansion[PNT07,massflowIN,pa,\[Eta]n,cpB,\[Gamma]gas,Rgas,report,convergentNozzle];
	{p9,T9,\[Rho]9,s9}=PNT9;
	{p09,T09,\[Rho]09,s09}=PNT09;

	corePoints={PNTa,PNT02,PNT021,PNT03,PNT04,PNT05,PNT06,PNT07,PNT9};
	fanPoints= {PNTa,PNT02,PNT021};
	energy={workD,workF,workC,workHPT,workLPT,heatB,heatAB};
	beta={\[Beta]c*\[Beta]f,\[Beta]f};


(* ENGINE PERFORMANCE *)

(* area della sezione di uscita dell'ugello \[Dash] ottenuta secondo la relazione isentropica portataMassa=\[Rho]*A*u *)
	A9=1/( \[Rho]9 ue);

(* Calcolo spinta specifica rispetto alla portata complessiva *)
	impulseSpecificThrust=(1+f+\[Epsilon]1+\[Epsilon]2+BPR)ue-(1+BPR+\[Epsilon]1+\[Epsilon]2)Va;
	pressureSpecificThrust=A9 (p9-pa);
	specificThrust=impulseSpecificThrust+pressureSpecificThrust;

(* Calcolo della spinta specifica riferita alla portata complessiva*)
	Ia=specificThrust/(1+BPR+\[Epsilon]1+\[Epsilon]2);

(* Calcolo del consumo specifico in Kg/(h N)*)
	TSFC=3600 f/specificThrust;
(* Calcolo velocit\[AGrave] effettive, valide anche nel caso di ugello non adattato*)
	
	If[nozzleType=="convergent",
	ueeff = (impulseSpecificThrust+Va)/(1+f+BPR+\[Epsilon]1+\[Epsilon]2) + pressureSpecificThrust, (*use effective exhaust speed, which accounts for pressure thrust in power formulas*)
	ueeff = ue];
	
	
(* Calcolo della potenza disponibile riferita alla portata primaria *)
	Pav=f (Qf+Va^2/2);

(* Calcolo della potenza propulsiva riferita alla portata complessiva *)
	Pp=specificThrust Va;

(* Calcolo della potenza dissipata riferita alla portata complessiva*)
	Pd=(1+f+BPR+\[Epsilon]1+\[Epsilon]2) (ueeff-Va)^2/2;

(* Calcolo della potenza del getto riferita alla portata complessiva *)
	Pj= Pp + Pd;

(* Rendimento termodinamico*)
	\[Eta]th=Pj/Pav;

(* Rendimento propulsivo *)
	\[Eta]p=Pp/Pj;

(* Rendimento overall *)
	\[Eta]o=Pp/Pav;

	performance={Ia,TSFC,\[Eta]o,\[Eta]th,\[Eta]p,specificThrust};

	If[report,
		UnitMisPer={" m/s"," N\[CenterDot]kg/h","","",""};
		ValuePerfor=Table[ToString[performance[[i]]]<>UnitMisPer[[i]],{i,5}];
		Print[Style["Engine Performance Parameters",12,Bold,Blue]];
		Print[TableForm[
			{ValuePerfor},TableHeadings->{None,{"Ia","TSFC","\[Eta]0","\[Eta]th","\[Eta]p"}},TableDirections->Row
		]];
	];

	{corePoints,fanPoints,energy,performance,beta}
]


(* ::Section::Closed:: *)
(*Components sizing*)


(* ::Subsection::Closed:: *)
(*Intake*)


(* ::Subsubsection::Closed:: *)
(*Tools*)


SubsonicInletSizing[M3_,A3_,Rtip_,M1_,\[Gamma]air_]:=
Module[{A2,M2,Mach3,rule,A1,\[Gamma],Mach2,dum,Area2,Area3},

(*M3, A3 ed Rtip li ho trovati nello studio del fan mentre M1 lo impongo=0.7*)

A2=Pi*Rtip^2;
rule={\[Gamma]->\[Gamma]air,Area2->A2,Area3->A3,Mach3->M3};
dum=NSolve[Area2/Area3==Mach3/Mach2 ((1+(\[Gamma]-1)/2 Mach2^2)/(1+(\[Gamma]-1)/2 Mach3^2))^((\[Gamma]+1)/(2(\[Gamma]-1)))/.rule,Mach2];
M2=Mach2/.dum[[6]];
A1=A2*M2/M1((1+(\[Gamma]air-1)/2 M1^2)/(1+(\[Gamma]air-1)/2 M2^2))^((\[Gamma]air+1)/(2(\[Gamma]air-1)));


Return[{A1,A2,A3,M1,M2,M3}];
];


(* ::Subsection::Closed:: *)
(*Compressor *)


(* ::Subsubsection::Closed:: *)
(*Tools*)


(* ::Text:: *)
(*FUNZIONI ANGOLARI*)


(* Funzioni che convertono gli angoli da radianti a gradi e viceversa *)
Deg2Rad[x_]:=x*Degree;
Rad2Deg[x_]:=x*180/Pi;


(* ::Text:: *)
(*TRIANGLES TOOLS *)


(* Grafico del triangolo delle velocit\[AGrave] *)
plotTriangle[Ca_,U_,Cu1_,Cu2_,Wu1_,Wu2_]:=Module[{DH,def,AnnotatedArrow,plot},
DH=Sqrt[Wu2^2+Ca^2]/Sqrt[Wu1^2+Ca^2];
def=(ArcTan[Wu1/Ca]-ArcTan[Wu2/Ca])*360/(2 Pi);
AnnotatedArrow[p_,q_,label_]:={Arrowheads[{{.01,.5,Graphics[Inset[Style[label,Medium],{Center,Top}]]},{.03}}],Arrow[{p,q}]};
plot=Show[
Graphics[
{Black,AnnotatedArrow[{0,0},{U,0},"U"],
Inset[
Panel
[Grid[{{Text[Style["DH = "<>ToString[DH],16]]},{Text[Style["Deflection (\[Beta]1-\[Beta]2) = "<>ToString[def]<>"\[Degree]",16]]}}]
],
{U/2,1.2*Ca}]}
],
Graphics[{Red,AnnotatedArrow[{U-Cu1,Ca},{U,0},"C1"]}],
Graphics[{Blue,AnnotatedArrow[{U-Cu1,Ca},{0,0},"W1"]}],
Graphics[{Blue,AnnotatedArrow[{Wu2,Ca},{0,0},"W2"]}],
Graphics[{Red,AnnotatedArrow[{Wu2,Ca},{U,0},"C2"]}],PlotRange->{{-0.5,2.5},{-0.1,2.}},ImageSize->500];
Return[plot]
]


(* Partendo dai parametri caratteristici risolve le equazioni cinematiche inverse (non verr\[AGrave] usata) *)
triangleDesignFromEqns[psi_,phi_,lambda_]:=Module[{plotTriangles,\[Psi],\[Phi],\[CapitalLambda]R,\[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2,\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg,U,Ca,Cu1,Cu2,Wu1,Wu2,plot,eqns,desPars,angles},
eqns={\[Psi]==\[Phi](Tan[\[Beta]1]-Tan[\[Beta]2]),
\[CapitalLambda]R==0.5 \[Phi](Tan[\[Beta]1]+Tan[\[Beta]2]),
Tan[\[Alpha]1]+Tan[\[Beta]1]==1/\[Phi],
Tan[\[Alpha]2]+Tan[\[Beta]2]==1/\[Phi]};
desPars={\[Psi]->psi,\[Phi]->phi,\[CapitalLambda]R->lambda};
angles=First[Quiet[Solve[eqns/.desPars,{\[Beta]1,\[Beta]2,\[Alpha]1,\[Alpha]2}]]];
U=1;
Ca=U*\[Phi]/.desPars;
Cu1=Ca*Tan[\[Alpha]1]/.angles/.desPars;
Cu2=Ca*Tan[\[Alpha]2]/.angles/.desPars;
Wu1=Ca*Tan[\[Beta]1]/.angles/.desPars;
Wu2=Ca*Tan[\[Beta]2]/.angles/.desPars;
(*Convert to degrees*)
\[Alpha]1deg=Rad2Deg[\[Alpha]1];
\[Alpha]2deg=Rad2Deg[\[Alpha]2];
\[Beta]1deg=Rad2Deg[\[Beta]1];
\[Beta]2deg=Rad2Deg[\[Beta]2];
(*plot*)
plot=plotTriangle[Ca,U,Cu1,Cu2,Wu1,Wu2];
Return[{{\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg},{Ca,U,Cu1,Cu2,Wu1,Wu2},plot}]
];


(* Funzione per richiamare il codice Python Triangle Design e importare i risultati *)
runTriangleDesign[pythonExe_, \[Tau]stage_, DF_, \[Sigma]_, \[Gamma]_, \[Alpha]1deg_]:=Module[
{M1,\[Alpha]2deg,data},
Run[pythonExe<>" triangle_design_noigv.py "<>ToString[\[Tau]stage]<>" "<>ToString[DF]<>" "<>ToString[\[Sigma]]<>" "<>ToString[\[Gamma]]<>" "<>ToString[\[Alpha]1deg]];
data=Import["triangledesign.json","JSON"];
M1="M1"/. data;
\[Alpha]2deg="alpha2_degrees"/. data;
Return[{M1,\[Alpha]2deg}];
]


(*Funzione che calcola il triangolo di velocit\[AGrave] (non verr\[AGrave] usata)*)
triangleDesign[\[Tau]s_,DF_,M1_,\[Sigma]_,\[Gamma]_]:=Module[{eqns,sol,angles,\[Alpha]1,\[Alpha]2,U,Ca,Cu1,Wu1,\[Beta]1,Cu2,Wu2,\[Beta]2,\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg,plot},
(*Define \[Tau]=\[Tau](M1,\[Alpha]1,\[Alpha]2) and DF=DF(\[Alpha]1,\[Alpha]2,\[Sigma]) assuming repeating stage (\[CapitalLambda]=0.5) and constant axial speed*)

eqns={\[Tau]s==((\[Gamma]-1)M1^2)/(1+(\[Gamma]-1)M1^2/2) (Cos[\[Alpha]1]^2/Cos[\[Alpha]2]^2-1)+1,DF==(1-Cos[\[Alpha]2]/Cos[\[Alpha]1])+((Tan[\[Alpha]2]-Tan[\[Alpha]1])/(2\[Sigma]))Cos[\[Alpha]2]};
(*Solve sys of eqns to get (\[Alpha]1,\[Alpha]2)=f(DF,M1,\[Tau])*)
sol={\[Alpha]1,\[Alpha]2}/.Quiet[NSolve[eqns,{\[Alpha]1,\[Alpha]2}]];
(*Pick real and meaningful solution*)
angles=Select[sol,Element[#,Reals]&&#[[1]]<Pi/2&&#[[2]]<Pi/2 &];
(*Protect against no-solutions*)
If[angles=={},angles={{0,0}}];
{\[Alpha]1,\[Alpha]2}=angles[[1]];
(*Given \[Alpha]1 and \[Alpha]2, compute all other quantities as post-process. All velocities are normalized by C1*)
(*Rotor IN*)
U=Cos[\[Alpha]1](Tan[\[Alpha]1]+Tan[\[Alpha]2]);
Ca=Cos[\[Alpha]1];
Cu1=Sin[\[Alpha]1];
Wu1=U -Sin[\[Alpha]1];
\[Beta]1=ArcTan[Wu1/Ca];
(*Rotor OUT \[Equal] Stator IN*)
Cu2=Cos[\[Alpha]1]Tan[\[Alpha]2];
Wu2=U-Cu2;
\[Beta]2=ArcTan[Wu2/Ca];
(*Convert to degrees*)
\[Alpha]1deg=Rad2Deg[\[Alpha]1];
\[Alpha]2deg=Rad2Deg[\[Alpha]2];
\[Beta]1deg=Rad2Deg[\[Beta]1];
\[Beta]2deg=Rad2Deg[\[Beta]2];
(*plot*)
plot=plotTriangle[Ca,U,Cu1,Cu2,Wu1,Wu2];
Return[{{\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg},{Ca,U,Cu1,Cu2,Wu1,Wu2},plot}]
];


(*Funzione aggiornata per il calcolo dei triangoli di velocit\[AGrave] utilizzando l'eseguuibile Python*)
triangleDesignUpdated[pythonExe_, \[Tau]stage_, DF_, \[Sigma]_, \[Gamma]_, \[Alpha]1deg_]:=Module[
{M1,\[Alpha]2deg,\[Alpha]1,\[Alpha]2,U,Ca,Cu1,Wu1,\[Beta]1,Cu2,Wu2,\[Beta]2,\[Beta]1deg,\[Beta]2deg,plot},

(*Chiamata al codice Python per ottenere M1 e a2*)
{M1,\[Alpha]2deg}=runTriangleDesign[pythonExe, \[Tau]stage, DF, \[Sigma], \[Gamma], \[Alpha]1deg];
(*Conversione degli angoli da gradi a radianti*)
\[Alpha]1=Deg2Rad[\[Alpha]1deg];
\[Alpha]2=Deg2Rad[\[Alpha]2deg];
(*Given \[Alpha]1 and \[Alpha]2, compute all other quantities as post-process. All velocities are normalized by C1*)
(*Rotor IN*)
Ca=Cos[\[Alpha]1];
Cu1=Sin[\[Alpha]1];
U=Ca (Tan[\[Alpha]1]+Tan[\[Alpha]2]);
Wu1=U-Cu1;
\[Beta]1=ArcTan[Wu1/Ca];
(*Rotor OUT \[Equal] Stator IN*)
Cu2=Ca Tan[\[Alpha]2];
Wu2=U-Cu2;
\[Beta]2=ArcTan[Wu2/Ca];
(*Conversione in gradi*)
\[Beta]1deg=Rad2Deg[\[Beta]1];
\[Beta]2deg=Rad2Deg[\[Beta]2];
(*plot*)
plot=plotTriangle[Ca,U,Cu1,Cu2,Wu1,Wu2];
Return[{{\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg},{Ca,U,Cu1,Cu2,Wu1,Wu2},M1,plot}]
]


(* ::Text:: *)
(*GEOMETRY TOOLS *)


(*dimensionamento della sezione anulare tra il mozzo e la punta della pala*)
annulusDesign[massflow_,T_,p_,Ca_,\[Gamma]_,R_,rmean_]:=Module[{Area,a,Udim,rtip,rhub},

Area=massflow * R * T/(p* Ca);
rtip=(Area+4 Pi rmean^2)/(4 Pi rmean);
rhub=(-Area+4 Pi rmean^2)/(4 Pi rmean);
Return[{Area,rtip,rhub}]
];


(*Determina la velocit\[AGrave] angolare e il raggio medio del rotore*)
wheelSpeedDesign[massflow_,T_,p_,M_,U_,\[Alpha]1_,\[Alpha]2_,\[Gamma]_,R_,\[Sigma]c_,\[Rho]blade_,taper_]:=Module[{Area,a,C1,MRel,VRel,T0Rel,\[Omega],Udim,rmean,rtip,rhub},
a=Sqrt[\[Gamma] R T];
C1=M*a;
Area=massflow * R * T/(p* C1 Cos[\[Alpha]1*Pi/180]);
\[Omega]=Sqrt[4 Pi \[Sigma]c/(\[Rho]blade*Area*(1+taper))];
Udim=U*C1;
rmean=Udim/\[Omega];
Return[{\[Omega],Udim,rmean}]
];


(* ::Text:: *)
(*DRAWING TOOLS *)


(* Funzione per visualizzare i dati tabulati da un database (matrice DB) *)
nicePlotFromDB[DB_, ix_, iy1_, iy2_, labelx_, labely_] := Module[{pl},

  (* Costruisce due serie di punti {x,y} da plottare *)
  pl = ListPlot[
    {
      Table[{DB[[i, ix]], DB[[i, iy1]]}, {i, 1, Dimensions[DB, 1][[1]]}],  (* Prima serie: x=colonna ix, y=colonna iy1 *)
      Table[{DB[[i, ix]], DB[[i, iy2]]}, {i, 1, Dimensions[DB, 1][[1]]}]   (* Seconda serie: x=colonna ix, y=colonna iy2 *)
    },
    Joined -> True,                        
    Frame -> True,                        
    Axes -> False,                       
    FrameLabel -> {labelx, labely},     
    PlotStyle -> {Black, Red},           
    PlotRange -> {All, All},             
    FrameStyle -> Directive[Black, FontSize -> 16, FontFamily -> "Arial"], 
    ImageSize -> 500                   
  ];

  Return[pl]
]


(* Funzione per disegnare schematicamente il compressore visualizzando i differenti stadi*)
drawCompressor[DB_, iTip_, iHub_, nStages_] := Module[
  {
    x0, compressor, rTip, rHub, hRot, chordRot, gap, hStat, chordStat,
    GapBox0, gap0, RotBox, rot, HubBox, hub, diskBox, disk,
    GapBox1, gap1, StatBox, stat, pl
  },

  compressor = {};  (* Lista per raccogliere i disegni di ogni stadio *)
  x0 = 0;           (* Coordinata orizzontale iniziale *)

  Do[
    (* Estrae i raggi bordo esterno (tip) e bordo interno (hub) per le 3 stazioni di ciascuno stadio *)
    rTip = Table[DB[[j, iTip]], {j, (iStage - 1)*3 + 1, (iStage - 1)*3 + 3}];
    rHub = Table[DB[[j, iHub]], {j, (iStage - 1)*3 + 1, (iStage - 1)*3 + 3}];

    (* Calcola l'altezza del rotore (differenza tra raggio esterno e interno alla prima stazione) *)
    hRot = rTip[[1]] - rHub[[1]];
    chordRot = 0.4 * hRot;    (* Lunghezza del profilo rotore *)
    gap = 0.1 * chordRot;     (* Gap tra rotore e statore *)

    (* Calcola altezza e chord statore tra seconda e terza stazione *)
    hStat = rTip[[2]] - rHub[[2]];
    chordStat = 0.4 * hStat;

    (* Definisce il poligono bianco che simula il gap prima del rotore *)
    GapBox0 = Polygon[{{x0 - 4*gap, rHub[[1]]}, {x0, rHub[[1]]}, {x0 + 0.2*chordRot, rTip[[1]]}, {x0 - 4*gap, rTip[[1]]}}];
    gap0 = Graphics[{{EdgeForm[Thick], White, GapBox0}}];

    (* Poligono blu per il rotore *)
    RotBox = Polygon[{{x0, rHub[[1]]}, {x0 + chordRot, rHub[[2]]}, {x0 + 0.8*chordRot, rTip[[2]]}, {x0 + 0.2*chordRot, rTip[[1]]}}];
    rot = Graphics[{{EdgeForm[Thick], Blue, RotBox}, Text[Style["R" <> ToString[iStage], Medium, White], {x0 + 0.5*chordRot, rHub[[1]] + 0.5*hRot}]}];

    (* Poligono grigio per l'hub del rotore *)
    HubBox = Polygon[{{x0 + 0.47*chordRot, 0}, {x0 + 0.53*chordRot, 0}, {x0 + 0.53*chordRot, rHub[[2]] - 0.4*chordRot}, {x0 + 0.47*chordRot, rHub[[2]] - 0.4*chordRot}}];
    hub = Graphics[{{EdgeForm[Thick], Gray, HubBox}}];

    (* Poligono grigio per il disco *)
    diskBox = Polygon[{{x0, rHub[[1]]}, {x0 + chordRot, rHub[[2]]}, {x0 + chordRot, rHub[[2]] - 0.4*chordRot}, {x0, rHub[[2]] - 0.4*chordRot}}];
    disk = Graphics[{{EdgeForm[Thick], Gray, diskBox}}];

    (* Poligono bianco che simula il gap tra rotore e statore *)
    GapBox1 = Polygon[{{x0 + chordRot, rHub[[2]]}, {x0 + chordRot + gap + 0.2*chordStat, rHub[[2]]}, {x0 + chordRot + gap, rTip[[2]]}, {x0 + 0.8*chordRot, rTip[[2]]}}];
    gap1 = Graphics[{{EdgeForm[Thick], White, GapBox1}}];

    (* Poligono rosso per lo statore *)
    StatBox = Polygon[{{x0 + chordRot + gap + 0.2*chordStat, rHub[[2]]}, {x0 + chordRot + gap + 0.8*chordStat, rHub[[3]]}, {x0 + chordRot + gap + chordStat, rTip[[3]]}, {x0 + chordRot + gap, rTip[[2]]}}];
    stat = Graphics[{{EdgeForm[Thick], Red, StatBox}, Text[Style["S" <> ToString[iStage], Medium, White], {x0 + chordRot + gap + 0.5*chordStat, rHub[[2]] + 0.5*hStat}]}];

    (* Aggiorna la posizione orizzontale per il prossimo stadio *)
    x0 = x0 + chordRot + gap + chordStat + gap;

    (* Aggiunge il disegno dello stadio alla lista *)
    AppendTo[compressor, {gap0, rot, hub, disk, gap1, stat}],
    {iStage, 1, nStages}
  ];

  (* Combina e mostra tutti gli stadi, con frame e senza assi *)
  pl = Show[Reverse[compressor], PlotRange -> {All, All}, Axes -> False, Frame -> True, ImageSize -> 100 * nStages];

  Return[pl]
]



(* ::Text:: *)
(*DB TOOLS *)


(* Funzione per estrarre da DB una propriet\[AGrave] fisica specifica (colonna iProp) da ogni primo elemento di blocco di 3 righe, per nStages stadi del compressore*)
extractPropertyAlongCompressor[DB_, iProp_, nStages_] := Module[{prop, iStage, j},

  (* DB \[EGrave] strutturato in blocchi di 3 righe per stadio *)
  (* Estrae la riga corrispondente alla prima stazione di ogni stadio:
     parte da riga 1, salta 3 righe a ogni passo, fino a nStages*3 - 2 *)
  prop = Table[DB[[j, iProp]], {j, 1, nStages*3 - 2, 3}];

  Return[prop]
]


(* Funzione per raccogliere e visualizzare le geometrie del compressore *)
collectCompressorGeometries[allStates_, triangle_, nStages_, massflow_, Rair_] := 
 Module[{CompAreas, rMean, CompMeanDiameter, rTip, rRoot, \[Alpha]1m, 
   \[Beta]2m, phim, Ncomp, mredm, resAssoc,tableData},

  (* Estrazione delle aree delle sezioni lungo il compressore *)
  CompAreas = extractPropertyAlongCompressor[allStates, 9, nStages];

  (* Estrazione i raggi medi *)
  rMean = extractPropertyAlongCompressor[allStates, 6, nStages];

  (* Calcolo dei diametri medi: 2 * raggio medio *)
  CompMeanDiameter = 2 rMean;

  (* Estrazione i raggi al bordo esterno (tip)*)
  rTip = extractPropertyAlongCompressor[allStates, 7, nStages];

  (* Estrazione i raggi al bordo interno (root)*)
  rRoot = extractPropertyAlongCompressor[allStates, 8, nStages];

  (* Lista dell'angolo \[Alpha]1 medio in radianti per ciascuno stadio *)
  \[Alpha]1m = Table[Deg2Rad[triangle[[1]]], {i, 1, nStages}];

  (* Lista dell'angolo \[Beta]2 medio in radianti per ciascuno stadio *)
  \[Beta]2m = Table[Deg2Rad[triangle[[4]]], {i, 1, nStages}];

  (* Calcolo phi_m = Vax / U rapporto tra velocit\[AGrave] assiale e velocit\[AGrave] periferica costante per ciascuno stadio *)
  phim = Table[triangle[[5]]/triangle[[6]], {i, 1, nStages}];

  (* Calcolo della velocit\[AGrave] di rotazione (RPM) dal raggio medio del primo stadio *)
  Ncomp = triangle[[6]] / (2 Pi rMean[[1]]);
  
  (* Calcolo della portata massica ridotta media (m_red) *)
  mredm = massflow*Sqrt[Rair allStates[[1, 2]]] / (allStates[[1, 4]] CompAreas[[1]]);
  
  resAssoc = Association[
    "Aree delle sezioni (m\.b2)" -> CompAreas,
    "Raggi medi (m)" -> rMean,
    "Diametri medi (m)" -> CompMeanDiameter,
    "Raggi bordo esterno - tip (m)" -> rTip,
    "Raggi bordo interno - root (m)" -> rRoot,
    "Angolo medio \[Alpha]1 (rad)" -> \[Alpha]1m,
    "Angolo medio \[Beta]2 (rad)" -> \[Beta]2m,
    "Rapporto velocit\[AGrave] assiale/periferica \[CurlyPhi] " -> phim,
    "Velocit\[AGrave] rotazione (RPM)" -> Ncomp,
    "Portata massica ridotta media (kg/s)" -> mredm
  ];


  (* Visualizzazione dei risultati in una tabella leggibile *)
  
  tableData = Prepend[
    List @@@ Normal[resAssoc], 
    (* 'Normal' converte l'Association in lista di regole {key -> value, ...} 
         e 'List @@@' trasforma ogni regola in una lista {key, value} *)
    {Style["Parametro", Bold], Style["Valore", Bold]}
  ];
  
  Grid[
    tableData,
    Frame -> All,
    Alignment -> Left,
    Background -> {None, {{White}}}
  ]
]


(* ::Subsubsection::Closed:: *)
(*Size it!*)


(* Funzione che stima il numero di stadi nel compressore assiale con configurazione a stadi ripetuti *)
estimateNofStages[\[CapitalDelta]T0stage_,\[Beta]c_,T0in_,\[Eta]stage_,\[Gamma]_]:=Module[{n,Tin,T0out,\[CapitalDelta]T0,nStages,est\[CapitalDelta]T0stage},
n=(\[Gamma] \[Eta]stage)/(1-\[Gamma]+\[Gamma] \[Eta]stage);
Tin=TF[T0in,\[Gamma],Min];
T0out=T0in*(\[Beta]c)^((n-1)/n);
\[CapitalDelta]T0=T0out-T0in;
(*The repeating-row design is a constant \[CapitalDelta]T-stage design*)
nStages=Ceiling[\[CapitalDelta]T0/\[CapitalDelta]T0stage];
est\[CapitalDelta]T0stage=\[CapitalDelta]T0/nStages;
Print["With given conditions, #Stages = ",nStages, " with \!\(\*SubscriptBox[\(\[CapitalDelta]T0\), \(stage\)]\) = ", est\[CapitalDelta]T0stage];
Return[{nStages,est\[CapitalDelta]T0stage}];
];


(* Versione avanzata della stima del numero di stadi *)
estimateNofStagesAdvanced[\[CapitalDelta]T0stage_,\[Beta]c_,T0in_,\[Eta]stage_,\[Gamma]_]:=Module[{n,Tin,T0out,\[CapitalDelta]T0,nStages,est\[CapitalDelta]T0stage,T0,OPR,\[Beta]stage,act\[CapitalDelta]T0,\[Eta]comp,eps=10^-6,maxIter=100},

n=(\[Gamma] \[Eta]stage)/(1-\[Gamma]+\[Gamma] \[Eta]stage); (*polytropic index*)
T0out=T0in*(\[Beta]c)^((n-1)/n); (*compressor outlet T0, considering an infinite number of stages, having efficiency \[Eta]stage each*)
\[CapitalDelta]T0=T0out-T0in;

Do[

(*The repeating-row design is a constant \[CapitalDelta]T-stage design*)
nStages=Ceiling[\[CapitalDelta]T0/\[CapitalDelta]T0stage];
est\[CapitalDelta]T0stage=\[CapitalDelta]T0/nStages;


OPR=1;
T0=T0in;
Do[

\[Beta]stage=(1+\[Eta]stage*est\[CapitalDelta]T0stage/T0)^(\[Gamma]/(\[Gamma]-1));
T0=T0+est\[CapitalDelta]T0stage;
OPR=OPR*\[Beta]stage;
,{i,1,nStages}];

act\[CapitalDelta]T0=T0in*(OPR^((\[Gamma]-1)/\[Gamma])-1);
\[Eta]comp=act\[CapitalDelta]T0/\[CapitalDelta]T0;

\[CapitalDelta]T0=T0in*(\[Beta]c^((\[Gamma]-1)/\[Gamma])-1)/\[Eta]comp;

If[Abs[OPR-\[Beta]c]<eps,Break[]],
{j,1,maxIter}];

est\[CapitalDelta]T0stage=\[CapitalDelta]T0/nStages;
Print["With given conditions, #Stages = ",nStages, " with \!\(\*SubscriptBox[\(\[CapitalDelta]T0\), \(stage\)]\) = ", est\[CapitalDelta]T0stage];
Print["Compressor efficiency = ",\[Eta]comp, " with \!\(\*SubscriptBox[\(\[CapitalDelta]T0\), \(comp\)]\) = ", \[CapitalDelta]T0];
Return[{nStages,est\[CapitalDelta]T0stage,\[Eta]comp}];
];


(* Funzione completa per una progettazione preliminare di un compressore multistadio*)
designMultiStageCompressor[T0in_,p0in_,\[Beta]c_,\[Eta]stage_,\[Gamma]_,R_,cp_,Min_,DF_,\[Sigma]_,desired\[CapitalDelta]T0stage_,massflow_,\[Sigma]material_,\[Rho]blade_,taper_]:=Module[{pin,Tin,\[CapitalDelta]T0stage,nStages,\[Eta]comp,T0out,\[CapitalDelta]T0,p01,T01,T1,p1,a1,s1,T2,T02,p2,p02,a2,M2,M2rel,s2,T03,p3,s3,\[Tau]stage,\[Beta]stage,p03,\[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2,Ca,U,Cu1,Cu2,Wu1,Wu2,C1,M1,C3,T3,a3,M3,M3rel,\[Omega],Udim,M1rel,rmean,rtip1,rhub1,rtip2,rhub2,rtip3,rhub3,CrossSection1,CrossSection2,CrossSection3,saveTriangle,savePNT1,savePNT2,savePNT3,allStages,plot},

(*Inlet static*)
Tin=TF[T0in,\[Gamma],Min];
pin=pF[p0in,\[Gamma],Min];

(*Nr. of stages, \[CapitalDelta]T0stage, and multi-stage compressor efficiency*)
{nStages,\[CapitalDelta]T0stage,\[Eta]comp}=estimateNofStagesAdvanced[desired\[CapitalDelta]T0stage,\[Beta]c,T0in,\[Eta]stage,\[Gamma]];

(*Outlet total*)
T0out=T0in* (1+(\[Beta]c^((\[Gamma]-1)/\[Gamma])-1)/\[Eta]comp);
Print["T0in = ",T0in, " :: T0out = ",T0out];
Print["p0in = ",p0in, " :: p0out = ",p0in*\[Beta]c];
\[CapitalDelta]T0=T0out-T0in;


(*Loop over stages*)
p01=p0in;
T01=T0in;
T1=Tin;
p1=pin;
M1=Min;

allStages={};
Do[
T03=T02=T01+\[CapitalDelta]T0stage;
\[Tau]stage=T03/T01;
(*\[Beta]stage=(\[Tau]stage)^(n/(n-1));*)
\[Beta]stage=(1+\[Eta]stage  \[CapitalDelta]T0stage/T01)^(\[Gamma]/(\[Gamma]-1));
a1=Sqrt[\[Gamma]*R*T1];
C1=M1 * a1;

(*Note: if calculations are correct, next call will return the same results for every stage!*)
{{\[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2},{Ca,U,Cu1,Cu2,Wu1,Wu2},plot}=triangleDesign[\[Tau]stage,DF,M1,\[Sigma],\[Gamma]];
saveTriangle={\[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2,C1*Ca,C1*U,C1*Cu1,C1*Cu2,C1*Wu1,C1*Wu2,\[Omega]};


If[i==1,
{\[Omega],Udim,rmean}=wheelSpeedDesign[massflow,T1,p1,M1,U,\[Alpha]1,\[Alpha]2,\[Gamma],R,\[Sigma]material,\[Rho]blade,taper];
Print["Wheelspeed = ", \[Omega], " rad/s"];
Print["rmean = ", rmean]
];
{CrossSection1,rtip1,rhub1}=annulusDesign[massflow,T1,p1,Ca*C1,\[Gamma],R,rmean];
M1rel=M1*Cos[Deg2Rad[\[Alpha]1]]/Cos[Deg2Rad[\[Alpha]2]];
s1=s[p1,T1,\[Gamma], R];
savePNT1={T1,T01,p1,p01,s1,rmean,rtip1,rhub1,CrossSection1,M1,M1rel};
AppendTo[allStages,savePNT1];

(*(2) Rotor outlet / stator inlet *)
p2=p1 (1+\[Eta]stage  0.5*\[CapitalDelta]T0stage/T1)^(\[Gamma]/(\[Gamma]-1));(*degree of reaction is 0.5 and \[CapitalDelta]T0\[Equal]\[CapitalDelta]T*)
T2= T1 + 0.5*\[CapitalDelta]T0stage;(*degree of reaction is 0.5 and \[CapitalDelta]T0\[Equal]\[CapitalDelta]T*)
a2=Sqrt[\[Gamma]*R*T2];
M2rel=M1*a1/a2;(*because W2\[Equal]C1*)
M2=M1rel*a1/a2; (*because C2==W1*)
p02=p0F[p2,M2,\[Gamma]]; 
s2=s[p2,T2,\[Gamma], R];
{CrossSection2,rtip2,rhub2}=annulusDesign[massflow,T2,p2,Ca*C1,\[Gamma],R,rmean];
savePNT2={T2,T02,p2,p02,s2,rmean,rtip2,rhub2,CrossSection2,M2,M2rel};
AppendTo[allStages,savePNT2];

(*(3) Stator outlet  *)
p03=p01*\[Beta]stage;
C3=C1; (*Repeating stage!*)
T3=T03-(C3^2/(2*cp));
a3=Sqrt[\[Gamma]*R*T3];
M3=C3/a3;
p3=pF[p03,\[Gamma],M3];
M3rel=M1rel*a1/a3;
s3=s[p3,T3,\[Gamma], R];
Print["Stage # ",i," Pratio = ", \[Beta]stage," p0out = ",p03," T0out = ",T03," Mout= ",M3, " \[Alpha]1 = ",\[Alpha]1," \[Beta]2 = ",\[Beta]2 ", \[CapitalDelta]\[Beta] = ",\[Beta]1-\[Beta]2 ];
{CrossSection3,rtip3,rhub3}=annulusDesign[massflow,T3,p3,Ca*C1,\[Gamma],R,rmean];
savePNT3={T3,T03,p3,p03,s3,rmean,rtip3,rhub3,CrossSection3,M3,M3rel};
AppendTo[allStages,savePNT3];

(*Setting inflow of following stage*)
M1=M3;
T01=T03;
T1=T3;
p01=p03;
p1=p3;

,{i,1,nStages}];

Print["Database contains: T,T0,p,p0,s,rmean,rtip,rhub,CrossSection,M,Mrel"];
Print["Triangle contains: \[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2,Ca,U,Cu1,Cu2,Wu1,Wu2,\[Omega]"];

Return[{nStages,allStages,saveTriangle,plot}]
];


(* Funzione aggiornata in cui da in input \[Alpha]1 *)
designFullCompressorUpdated[pythonExe_,T0in_,p0in_,\[Beta]c_,\[Eta]stage_,\[Gamma]_,R_,cp_,\[Alpha]indeg_,DF_,\[Sigma]_,desired\[CapitalDelta]T0stage_,massflow_,\[Sigma]material_,\[Rho]blade_,taper_]:=Module[
{M1,T1,T01,p1,p01,M3,T3,T02,T03,p3,p03,nStages,\[CapitalDelta]T0stage,\[Eta]comp,T0out,\[CapitalDelta]T0,rmean,plot,allStages,\[Tau]stage,\[Beta]stage,C1,a1,Ca,U,Cu1,Cu2,Wu1,Wu2,CrossSection1,rtip1,rhub1,M1rel,\[Alpha]1deg,\[Alpha]2deg,s1,T2,p2,a2,\[Beta]1deg,\[Beta]2deg,M2rel,M2,p02,s2,CrossSection2,rtip2,rhub2,C3,a3,s3,M3rel,CrossSection3,rtip3,rhub3,i,\[Omega],Udim,savePNT1,savePNT2,savePNT3,saveTriangle},

(*Inlet total*)
p01=p0in;
T01=T0in;
\[Alpha]1deg=\[Alpha]indeg;

(*Nr. of stages, \[CapitalDelta]T0stage, and multi-stage compressor efficiency*)
{nStages,\[CapitalDelta]T0stage,\[Eta]comp}=estimateNofStagesAdvanced[desired\[CapitalDelta]T0stage,\[Beta]c,T0in,\[Eta]stage,\[Gamma]];

(*Outlet total*)
T0out=T0in*(1+(\[Beta]c^((\[Gamma]-1)/\[Gamma])-1)/\[Eta]comp);
Print["T0in = ",T0in, " :: T0out = ",T0out];
Print["p0in = ",p0in, " :: p0out = ",p0in*\[Beta]c];
\[CapitalDelta]T0=T0out-T0in;

(*Loop over stages*)

allStages={};
Do[
T02=T03=T01+\[CapitalDelta]T0stage;
\[Tau]stage=T03/T01;
(*\[Beta]stage=(\[Tau]stage)^(n/(n-1));*)
\[Beta]stage=(1+\[Eta]stage*\[CapitalDelta]T0stage/T01)^(\[Gamma]/(\[Gamma]-1));

(*Triangolo di velocit\[AGrave] con alpha1 noto*)
{{\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg},{Ca,U,Cu1,Cu2,Wu1,Wu2},M1,plot}=triangleDesignUpdated[pythonExe,\[Tau]stage,DF,\[Sigma],\[Gamma],\[Alpha]1deg];

saveTriangle={\[Alpha]1deg,\[Alpha]2deg,\[Beta]1deg,\[Beta]2deg,C1*Ca,C1*U,C1*Cu1,C1*Cu2,C1*Wu1,C1*Wu2,\[Omega]};

(*Calcoli statici ingresso*)
T1=TF[T01,\[Gamma],M1];
p1=pF[p01,\[Gamma],M1];
a1=Sqrt[\[Gamma]*R*T1];
C1=M1*a1;

If[i==1,
{\[Omega],Udim,rmean}=wheelSpeedDesign[massflow,T1,p1,M1,U,Deg2Rad[\[Alpha]1deg],Deg2Rad[\[Alpha]2deg],\[Gamma],R,\[Sigma]material,\[Rho]blade,taper];
Print["Wheelspeed = ", \[Omega], " rad/s"];
Print["rmean = ", rmean]
];

{CrossSection1,rtip1,rhub1}=annulusDesign[massflow,T1,p1,Ca*C1,\[Gamma],R,rmean];
M1rel=M1*Cos[Deg2Rad[\[Alpha]1deg]]/Cos[Deg2Rad[\[Alpha]2deg]];
s1=s[p1,T1,\[Gamma],R];
savePNT1={T1,T01,p1,p01,s1,rmean,rtip1,rhub1,CrossSection1,M1,M1rel};AppendTo[allStages,savePNT1];

(*(2) Rotor outlet / stator inlet *)
T2=T1+0.5*\[CapitalDelta]T0stage;(*degree of reaction is 0.5 and \[CapitalDelta]T0\[Equal]\[CapitalDelta]T*)
p2=p1*(1+\[Eta]stage*0.5*\[CapitalDelta]T0stage/T1)^(\[Gamma]/(\[Gamma]-1));(*degree of reaction is 0.5 and \[CapitalDelta]T0\[Equal]\[CapitalDelta]T*)
a2=Sqrt[\[Gamma]*R*T2];
M2rel=M1*a1/a2;(*because W2\[Equal]C1*)
M2=M1rel*a1/a2;(*because C2==W1*)
p02=p0F[p2,M2,\[Gamma]];
s2=s[p2,T2,\[Gamma],R];
{CrossSection2,rtip2,rhub2}=annulusDesign[massflow,T2,p2,Ca*C1,\[Gamma],R,rmean];
savePNT2={T2,T02,p2,p02,s2,rmean,rtip2,rhub2,CrossSection2,M2,M2rel};AppendTo[allStages,savePNT2];

(*(3) Stator outlet  *)
p03=p01*\[Beta]stage;
C3=C1;(*Repeating stage!*)
T3=T03-C3^2/(2*cp);
a3=Sqrt[\[Gamma]*R*T3];
M3=C3/a3;
p3=pF[p03,\[Gamma],M3];
M3rel=M1rel*a1/a3;
s3=s[p3,T3,\[Gamma],R];
Print["Stage # ",i," Pratio = ",\[Beta]stage," p0out = ",p03," T0out = ",T03," Mout = ",M3," \[Alpha]1 = ",\[Alpha]1deg," \[Beta]2 = ",\[Beta]2deg," \[CapitalDelta]\[Beta] = ",\[Beta]1deg-\[Beta]2deg];
{CrossSection3,rtip3,rhub3}=annulusDesign[massflow,T3,p3,Ca*C1,\[Gamma],R,rmean];
savePNT3={T3,T03,p3,p03,s3,rmean,rtip3,rhub3,CrossSection3,M3,M3rel};
AppendTo[allStages,savePNT3];

(*Setting inflow of following stage*)
T1=T3;
p1=p3;
T01=T03;
p01=p03;
M1=M3;
\[Alpha]1deg=\[Beta]2deg;
,{i,1,nStages}];

Print["Database contains: T,T0,p,p0,s,rmean,rtip,rhub,CrossSection,M,Mrel"];
Print["Triangle contains: \[Alpha]1,\[Alpha]2,\[Beta]1,\[Beta]2,Ca,U,Cu1,Cu2,Wu1,Wu2,\[Omega]"];

Return[{nStages,allStages,saveTriangle,plot}]
]


(* ::Subsection::Closed:: *)
(*Turbine*)


(* ::Subsubsection::Closed:: *)
(*Tools*)


(* Carico di stadio adimensionale *)
PsiTurb[\[CapitalDelta]T0_,U_,cp_]:=(cp*\[CapitalDelta]T0)/U^2;


(* Funzioni ausiliarie per i calcoli adimensionali *)
C2bar[\[Gamma]_,M2_]:=Sqrt[((\[Gamma]-1)M2^2)/(1+(\[Gamma]-1)M2^2/2)];
Cabar[\[Gamma]_,M2_,\[Alpha]2_]:=C2bar[\[Gamma],M2] Cos[\[Alpha]2];
Cu2bar[\[Gamma]_,M2_,\[Alpha]2_]:=C2bar[\[Gamma],M2] Sin[\[Alpha]2];
Wu2bar[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_]:=Cu2bar[\[Gamma],M2,\[Alpha]2]-\[CapitalOmega];

(* angolo di ingresso relativo sul rotore *)
\[Beta]2[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_]:=ArcTan[Wu2bar[\[Gamma],M2,\[Alpha]2,\[CapitalOmega]]/Cabar[\[Gamma],M2,\[Alpha]2]];
Tt2rOverTt1[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_]:=1+\[CapitalOmega]^2 (0.5-Cu2bar[\[Gamma],M2,\[Alpha]2]/\[CapitalOmega]);

(* angolo di uscita relativo dal rotore *)
\[Beta]3[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=ArcTan[Sqrt[Tt2rOverTt1[\[Gamma],M2,\[Alpha]2,\[CapitalOmega]]/Cabar[\[Gamma],M2,\[Alpha]2]^2 ((\[Gamma]-1)M3R^2)/(1+(\[Gamma]-1)M3R^2/2)-1]];
Cu3bar[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=Cabar[\[Gamma],M2,\[Alpha]2]Tan[\[Beta]3[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]]-\[CapitalOmega];

(* angolo di uscita dallo stadio *)
\[Alpha]3[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=ArcTan[Cu3bar[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]/Cabar[\[Gamma],M2,\[Alpha]2]];
T3OverTt1[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=Tt2rOverTt1[\[Gamma],M2,\[Alpha]2,\[CapitalOmega]]/(1+(\[Gamma]-1)M3R^2/2);
\[Tau]ts[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=T3OverTt1[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]+Cabar[\[Gamma],M2,\[Alpha]2]^2*(1+Tan[\[Alpha]3[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]]^2)/2;
Wu3bar[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=Cabar[\[Gamma],M2,\[Alpha]2]Tan[\[Beta]3[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]];

(* Grado di reazione *)
Rt[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_]:=(Wu3bar[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]^2-Wu2bar[\[Gamma],M2,\[Alpha]2,\[CapitalOmega]]^2)(1/(2(1-\[Tau]ts[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R])));

(* Rapporto di solidit\[AGrave] *)
\[Sigma]xr[\[Gamma]_,M2_,\[Alpha]2_,\[CapitalOmega]_,M3R_,Z_]:=1/Z 2 Cos[\[Beta]3[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]]^2(Tan[\[Beta]2[\[Gamma],M2,\[Alpha]2,\[CapitalOmega]]]+Tan[\[Beta]3[\[Gamma],M2,\[Alpha]2,\[CapitalOmega],M3R]]);

(* Calcolo della velocit\[AGrave] adimensionale *)
Vprime[cp_,T01_]:=Sqrt[cp*T01];



(* ::Subsubsection::Closed:: *)
(*Size it!*)


(* Calcolo dei parametri principali di uno stadio di turbina *)
(* Calcola i parametri dello stadio conoscendo gi\[AGrave] l\[CloseCurlyQuote]angolo di uscita statorica \[Alpha]2 *)

SizeTurbineStage[alfa2_,M2_,M3R_,U_,T0inlet_,cp_,\[Gamma]_]:=Module[
{\[CapitalOmega],tratio,turning,reaction,alfa3,beta2,beta3,axial,Ma2R},

\[CapitalOmega]=U/Sqrt[cp*T0inlet]; (* Velocit\[AGrave] adimensionale *)
tratio=\[Tau]ts[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega],M3R];
reaction=Rt[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega],M3R];
alfa3=Rad2Deg[\[Alpha]3[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega],M3R]];
beta2=Rad2Deg[\[Beta]2[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega]]];
beta3=Rad2Deg[\[Beta]3[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega],M3R]]; (* beta3=Rad2Deg[\[Beta]3[\[Gamma],M2,Deg2Rad[alfa2],\[CapitalOmega],M3R]]*)
turning=beta2+beta3;
axial=Cabar[\[Gamma],M2,Deg2Rad[alfa2]]; (* Componente assiale adimensionale *)

Return[{tratio,turning,reaction,beta2,alfa3,beta3,axial}]
]


(* Calcola i parametri principali di uno stadio di turbina, trovando l'angolo d'uscita ottimale (\[Alpha]2) in modo che il salto entalpico corrisponda al valore desiderato (TratioStage) *)
(* Esegue anche il calcolo delle grandezze cinematiche e termodinamiche nei punti chiave dello stadio *)

SmartSizeTurbineStage[M2_, M3R_, U_, T0inlet_, p0inlet_, TratioStage_, cp_, \[Gamma]_] := Module[
  {\[Alpha]2guess, \[Alpha]2, tratio, turning, reaction, beta2, alfa2, alfa3, beta3, axial, \[CapitalDelta]M,R, Cax, T01, p01, T02, p02, T2, p2, C2, W2, M2R, p02R, T02R, perfo2, 
    T03, T03R, p03, T3, p3, C3, W3, p03R, M3, perfo3, maxIterations, iteration,toll, foundSolution},

  (* Inizializza il guess iniziale per l'angolo \[Alpha]2 e i parametri di ciclo *)
  \[Alpha]2guess = 85; (* guess iniziale per l\[CloseCurlyQuote]angolo uscita statore *)
  maxIterations = 30;
  iteration = 0;
  toll=0.005;
  foundSolution = False; (* flag: soluzione trovata s\[IGrave]/no *)

  (* Loop iterativo per trovare l'angolo di uscita \[Alpha]2 che produce il salto entalpico richiesto (TratioStage).
    Alla fine del ciclo, foundSolution sar\[AGrave] True se la soluzione viene trovata entro la tolleranza.*)
 
   While[\[Alpha]2guess > 70 && iteration < maxIterations,
    iteration++;
    Quiet[
      Check[
        \[Alpha]2 = alfa2 /. FindRoot[
          SizeTurbineStage[alfa2, M2, M3R, U, T0inlet, cp, \[Gamma]][[1]] == TratioStage,
          {alfa2, \[Alpha]2guess},
          AccuracyGoal -> 6, PrecisionGoal -> 6, MaxIterations -> 50
        ];
        foundSolution = True, (* se trova soluzione, imposta flag *)
        foundSolution = False, (* se fallisce, flag rimane False *) 
        {FindRoot::lstol, FindRoot::cvmit, FindRoot::jsing}] (* codici di warning usati per "silenziare" e gestire i principali problemi numerici incontrati da FindRoot durante la ricerca di soluzioni *)
    ];
        
    If[foundSolution,
      {tratio, turning, reaction, beta2, alfa3, beta3, axial} =
        SizeTurbineStage[\[Alpha]2, M2, M3R, U, T0inlet, cp, \[Gamma]];
      If[Abs[tratio - TratioStage] <= toll, Break[];];  (* se salto entalpico entro tolleranza, esci dal ciclo *)
    ];

    (* Se non \[EGrave] stata trovata una soluzione soddisfacente, aggiorna Mach e guess per l'angolo per provare con condizioni leggermente diverse *)
    \[CapitalDelta]M = 0.02 + 0.01*iteration; (* incremento Mach ad ogni tentativo *)
    M2 = Min[M2 + \[CapitalDelta]M, 1.2]; (* aumenta M2 ma non oltre 1.2 *)
    M3R = Min[M3R + \[CapitalDelta]M, 0.9]; (* aumenta M3R ma non oltre 0.9 *)
    \[Alpha]2guess = Max[\[Alpha]2guess - 2, 70]; (* riduci il guess per l\[CloseCurlyQuote]angolo ma non sotto 70\[Degree] *)
  ];

  (* Se non \[EGrave] stata trovata alcuna soluzione fisica, mostra un warning e restituisce $Failed per interrompere il calcolo a monte *)
  
  If[!foundSolution,
    Print["[WARNING] No physical solution found for this stage."];
    Return[$Failed];
  ];

  (* Calcoli delle propriet\[AGrave] dei gas e velocit\[AGrave] assiali *)
  R = cp*(\[Gamma] - 1)/\[Gamma];
  Cax = axial * Vprime[cp, T0inlet];

  (* Calcolo delle condizioni nei punti caratteristici dello stadio *)
  (* Punto 1: ingresso statore *)
  T01 = T0inlet;
  p01 = p0inlet;

  (* Punto 2: uscita statore / ingresso rotore *)
  T02 = T01;
  p02 = p01;
  T2 = TF[T02, \[Gamma], M2];
  p2 = pF[p02, \[Gamma], M2];
  C2 = M2*Sqrt[\[Gamma]*R*T2];
  W2 = Cax/Cos[Deg2Rad[beta2]];
  M2R = W2/Sqrt[\[Gamma]*R*T2];
  p02R = p0ratio[\[Gamma], M2R]*p2;
  T02R = T0ratio[\[Gamma], M2R]*T2;
  perfo2 = {\[Alpha]2, beta2, T02, T2, p02, p2, p02R, C2, M2, W2, M2R};

  (* Punto 3: uscita rotore *)
  T03R = T02R;
  T3 = TF[T03R, \[Gamma], M3R];
  T03 = TratioStage*T0inlet;
  p03R = p02R;
  p3 = pF[p03R, \[Gamma], M3R];
  C3 = Cax/Cos[Deg2Rad[alfa3]];
  W3 = Cax/Cos[Deg2Rad[beta3]];
  M3 = C3/Sqrt[\[Gamma]*R*T3];
  p03 = p0ratio[\[Gamma], M3]*p3;
  perfo3 = {alfa3, beta3, T03, T3, p03, p3, p03R, C3, M3, W3, M3R};

  Return[{tratio, turning, reaction, axial, perfo2, perfo3}]
];


(* Calcola il numero di stadi e la distribuzione delle temperature di uscita e dei rapporti di temperatura per ciascuno stadio *)

CalcNstages[T0inlet_,T0outlet_,U_,cp_]:=Module[
{\[CapitalDelta]T0turbine,psiTotal,\[CapitalDelta]T0stage,nStages,dT0,ToutletStage,TratioStage,TinletStage},

\[CapitalDelta]T0turbine=T0inlet-T0outlet;(* Salto totale entalpico *)
psiTotal=PsiTurb[\[CapitalDelta]T0turbine,U,cp]; (* Carico totale di stadio *)
If[psiTotal>2.0,nStages=Ceiling[psiTotal/2.0](* Limite tipico per stadio *),nStages=1];
Print["Number of stages = ",nStages];
Print["Stage loadings =",psiTotal/nStages];
\[CapitalDelta]T0stage=dT0/.First[Solve[PsiTurb[dT0,U,cp]==psiTotal/nStages,dT0]];
ToutletStage={};
TratioStage={};
TinletStage=T0inlet;
Do[
AppendTo[ToutletStage,TinletStage-\[CapitalDelta]T0stage];
AppendTo[TratioStage,(TinletStage-\[CapitalDelta]T0stage)/TinletStage];
TinletStage=ToutletStage[[i]];,
{i,1,nStages}];
Return[{nStages,\[CapitalDelta]T0stage,ToutletStage,TratioStage}];

]


(* Calcola il numero di stadi e la distribuzione delle temperature di uscita e dei rapporti di temperatura *)
(* Permette di specificare il tipo di turbina in funzione del carico massimo di stadio *) 

CalcNstagesTurbine[T0inlet_,T0outlet_,U_,cp_,type_:"LPT"]:=Module[
{\[CapitalDelta]T0turbine,psiTotal,\[CapitalDelta]T0stage,nStages,dT0,ToutletStage,TratioStage,TinletStage,psiMax},

(* Imposta il carico massimo ammesso per stadio, in base al tipo di turbina *)
  psiMax = If[type === "HPT", 1.5, 1.1]; 
  
  (* Salto entalpico totale della turbina *)
  \[CapitalDelta]T0turbine = T0inlet - T0outlet;

  (* Calcolo del carico totale richiesto (psi totale) usando la funzione PsiTurb *)
  psiTotal = PsiTurb[\[CapitalDelta]T0turbine, U, cp];

  (* Determina il numero minimo di stadi necessario per rimanere entro il carico massimo per stadio *)
  If[psiTotal > psiMax,
    nStages = Ceiling[psiTotal/psiMax], (* Se troppo carico, aumenta gli stadi *)
    nStages = 1                          (* Altrimenti ne basta uno *)
  ];
  
  Print["TURBINE DESIGN PARAMETERS"];
  Print["Number of stages = ", nStages];
  Print["Stage loadings (\[Psi]) = ", psiTotal/nStages];

  (* Calcola il salto entalpico per stadio tale da rispettare il carico per stadio *)
  \[CapitalDelta]T0stage = dT0 /. First[Solve[PsiTurb[dT0, U, cp] == psiTotal/nStages, dT0]];

  (* Simula gli stadi successivi aggiornando le temperature *)
  TinletStage = T0inlet;
  ToutletStage={};
  TratioStage={};
  Do[
    AppendTo[ToutletStage, TinletStage - \[CapitalDelta]T0stage]; (* Temperatura in uscita stadio *)
    AppendTo[TratioStage, (TinletStage - \[CapitalDelta]T0stage)/TinletStage]; (* Rapporto di temperatura *)
    TinletStage = Last[ToutletStage]; (* Aggiorna per lo stadio successivo *)
  , {i, 1, nStages}];

  Return[{nStages, \[CapitalDelta]T0stage, ToutletStage, TratioStage}]
]


(* Calcola e visualizza le prestazioni di tutti gli stadi di una turbina multi-stadio *)

SizeTurbine[T0inlet_, T0outlet_, p0inlet_, U_, cp_, \[Gamma]_, type_:"LPT", detailed_:"on"] := Module[
  {nStages, \[CapitalDelta]T0stage, ToutletStage, TratioStage, allPerfo = {}, M2, M3R = 0.8, tratio, turning, reaction,
    alfa2, beta2, alfa3, beta3, axial, T0in, p0in, perfo, parnames, perfo2, perfo3, result,
    T02, T2, p02, p2, p02R, C2, T03, T3, p03, p3, p03R, C3, M3, W3, W2, M2R, keyPar},

  (* Calcolo preliminare del numero di stadi e dei rapporti termici per ciascuno *)
  {nStages, \[CapitalDelta]T0stage, ToutletStage, TratioStage} = CalcNstagesTurbine[T0inlet, T0outlet, U, cp, type];  

  (* Iterazione su ciascuno stadio *)
  Do[
    Print["\n========================================"];
    Print["stage #", n];

    (* Condizioni iniziali per il primo stadio; aggiorna per i successivi *)
    If[n == 1,  
      M2 = 1.0; 
      T0in = T0inlet;
      p0in = p0inlet,
      M2 = 0.9;
      T0in = ToutletStage[[n - 1]]; 
      p0in = perfo3[[5]];
    ];

    (* Output delle condizioni di ingresso dello stadio *)
    Print["Stage inlet conditions: T0in = ", T0in, " K, p0in = ", p0in, " Pa"];
    Print["M2 = ", M2, ", M3R = ", M3R, ", U = ", U];
    Print["Target \[Tau] = ", TratioStage[[n]]];

    (* Calcolo dimensionamento dello stadio *)
    result = SmartSizeTurbineStage[M2, M3R, U, T0in, p0in, TratioStage[[n]], cp, \[Gamma]];

    (* Gestione fallimento calcolo *)
    If[result === $Failed,
      Print["\n[ERROR] Stage ", n, " calculation failed "];
      Print["Possible solutions:"];
      Print["  1. Increase number of stages (currently ", nStages, ")"];
      Print["  2. Modify velocity U (current U=", U, ")"];
      Print["  3. Review inlet conditions (T0=", T0in, ", p0=", p0in, ")"];
      Return[$Failed]
    ];

    (* Estrazione dei risultati dello stadio *)
    {tratio, turning, reaction, axial, perfo2, perfo3} = result;

    (* Parametri di statore (2) e rotore (3) *)
    {alfa2, beta2, T02, T2, p02, p2, p02R, C2, M2, W2, M2R} = perfo2;
    {alfa3, beta3, T03, T3, p03, p3, p03R, C3, M3, W3, M3R} = perfo3;

    (* Vettore con tutti i parametri dello stadio *)
    perfo = {
      tratio, reaction, alfa2, beta2, T02, T2, p02, p2, p02R,
      C2, M2, W2, M2R, alfa3, beta3, T03, T3, p03, p3, p03R,
      C3, M3, W3, M3R, turning, axial * Vprime[cp, T02]
    };

    (* Parametri corrispondenti *)
    parnames = {
      "\[Tau]_stage", "R", "\[Alpha]2", "\[Beta]2", "T02", "T2", "p02", "p2", "p02R",
      "C2", "M2", "W2", "M2R", "\[Alpha]3", "\[Beta]3", "T03", "T3", "p03", "p3", "p03R",
      "C3", "M3", "W3", "M3R", "\[Beta]2+\[Beta]3", "Ca"
    };

    (* Parametri chiave da mostrare in versione compatta se detailed == "off" *)
    keyPar = {
      {Style["Temperature ratio (\[Tau])", Black, Bold], tratio},
      {Style["Reaction degree (R)", Black, Bold], reaction},
      {Style["Flow angles (\[Alpha]2, \[Beta]2, \[Alpha]3, \[Beta]3)", Black, Bold], {alfa2, beta2, alfa3, beta3}},
      {Style["Turning", Black, Bold], turning},
      {Style["Axial velocity (Ca)", Black, Bold], axial * Vprime[cp, T02]},
      {Style["Mach numbers (M2, M2R, M3, M3R)", Black, Bold], {M2, M2R, M3, M3R}}
    };

    (* Output formattato in base all'opzione "detailed" *)
    Print[
      If[detailed === "on",
        TableForm[perfo, TableHeadings -> {parnames, None}],
        Grid[keyPar, Frame -> All, Spacings -> {2, 2}]
      ]
    ];

    (* Salvataggio dei risultati dello stadio *)
    AppendTo[allPerfo, perfo]; 
    ,{n, 1, nStages}  (* Ciclo su tutti gli stadi *)
  ];

  (* Output finale: lista completa di tutti gli stadi *)
  Return[allPerfo]  
]


(* ::Section:: *)
(*Components Performance Maps*)


(* ::Subsection:: *)
(*Air Intake*)


mredIntakeIsen[A0_,M0_,\[Gamma]_]:=M0 A0 Sqrt[\[Gamma]] (1+(\[Gamma]-1)/2 M0^2)^((\[Gamma]+1)/(2(1-\[Gamma])));

\[Epsilon][M0_]:=1.0-0.1(M0-1)^1.5/; M0>1;
\[Epsilon][M0_]:=1.0/; M0\[LessSlantEqual]1;

mredIntake[A0_,M0_,\[Gamma]_]:=M0 A0 Sqrt[\[Gamma]] (1+(\[Gamma]-1)/2 M0^2)^((\[Gamma]+1)/(2(1-\[Gamma])))/; M0<=1;
mredIntake[A0_,M0_,\[Gamma]_]:=1/\[Epsilon][M0] M0 A0 Sqrt[\[Gamma]] (1+(\[Gamma]-1)/2 M0^2)^((\[Gamma]+1)/(2(1-\[Gamma])))/; M0>1;


(* ::Subsection::Closed:: *)
(*Turbine*)


mredTurbine[pratio_,\[Eta]_,area_,\[Gamma]_]:=area Sqrt[(2 \[Gamma])/(\[Gamma]-1)](pratio)  Sqrt[\[Eta](1-(pratio)^((\[Gamma]-1)/\[Gamma]))]/(1-\[Eta](1-(pratio)^((\[Gamma]-1)/\[Gamma])))/;pratio>=2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma])));
mredTurbine[pratio_,\[Eta]_,area_,\[Gamma]_]:=area Sqrt[(2 \[Gamma])/(\[Gamma]-1)](2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))  Sqrt[\[Eta](1-(2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))^((\[Gamma]-1)/\[Gamma]))]/(1-\[Eta](1-(2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma]))))^((\[Gamma]-1)/\[Gamma])))/;pratio<2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma])));

pratio2Turbs[pratioComp_,area4_,area3_,\[Eta]4_,\[Eta]3_,\[Gamma]_]:=Module[{dum,x},
dum=FindRoot[mredTurb[\!\(TraditionalForm\`x\)/pratioComp,\[Eta]4,area4,\[Gamma]]==mredTurb[1/x,\[Eta]3,area3,\[Gamma]]\!\(TraditionalForm\`x\) Sqrt[1-\[Eta]3(1-(1/x)^((\[Gamma]-1)/\[Gamma]))],\!\(TraditionalForm\`{x, 1.01}\)];
x/.dum[[1]]];


PratioCrit[\[Gamma]_]:=2^(\[Gamma]/(-1+\[Gamma])) (1+\[Gamma])^(-(\[Gamma]/(-1+\[Gamma])));


(* ::Subsection::Closed:: *)
(*Compressor*)


StageReducedProperties[massflow_,Ncomp_,diameter_,area_,alpha1_,p01_,T01_,Rgas_,\[Gamma]_]:=Module[
{sol,U,T,Ca1,Machd,Mach,phi,nred,mred,choked,a1},

nred=(Ncomp diameter)/Sqrt[Rgas T01];

mred=(massflow Sqrt[Rgas T01])/(area p01 );
sol=FindRoot[mred== Sqrt[\[Gamma]]  Machd Cos[alpha1] (1.+(\[Gamma]-1)/2 Machd^2)^(1/2-\[Gamma]/(\[Gamma]-1)),{Machd,0.5,0.,1.}];

Mach=Machd/.sol[[1]];

(*Print["mach : ",Mach];*)

choked=False;

If[Mach>0.99999,
choked=True;
(*Print["choked : ",choked," Mach = ", Mach];*)

Return[{choked,{0,0,0,0,0,0}}]
];

T = TF[T01,\[Gamma],Mach];


Ca1 = Mach Cos[alpha1] Sqrt[\[Gamma] Rgas T];

U = Pi Ncomp diameter;

phi = Ca1/U;


Return[{choked,{Ca1,T,Mach,phi,nred,mred}}]
];


Phi[mred_,nred_,Mach_,\[Gamma]_]:=Module[
{phi,delta},
delta=(\[Gamma]-1.)/2.;
phi=(1./Pi)(mred/nred)*(1.+delta Mach^2)^(1./(\[Gamma]-1.)) 
];

shockLosses[phi_,phid_,posIncidence_,negIncidence_]:=negIncidence (phi-phid)^2/;phi<phid;
shockLosses[phi_,phid_,posIncidence_,negIncidence_]:=posIncidence (phi-phid)^2/;phi>=phid;

Psi[phi_,phid_,alpha1_,beta2_,etaStage_]:=Module[
{psi,k,negIncidence,posIncidence=4,viscLossCoeff,psi0,phi0},
k=Tan[alpha1 ]+Tan[beta2];
viscLossCoeff=(PsiIdeal[phid,alpha1,beta2]/phid^2)*(1.-etaStage);

psi0=0.1;
phi0=0.;
negIncidence=(1. -k phi0-psi0-viscLossCoeff (phi0^2) )/(phi0-1. phid)^2;
psi0=0.0;
phi0=0.8/k;
posIncidence=(1. -k phi0-psi0-viscLossCoeff (phi0^2) )/(phi0-1. phid)^2;
psi=(1.-k  phi)-shockLosses[phi,phid,posIncidence,negIncidence]-viscLossCoeff phi^2;

Return[psi]
];

PsiIdeal[phi_,alpha1_,beta2_]:=Module[
{phimax,psi,k},
k=Tan[alpha1 ]+Tan[beta2];
psi=(1.-k  phi);
Return[psi]
];

EfficiencyComp[phi_,phid_,alpha1_,beta2_,etaStage_]:=Abs[Psi[phi,phid,alpha1,beta2,etaStage]/PsiIdeal[phi,alpha1,beta2]]/;Psi[phi,phid,alpha1,beta2,etaStage]>0;
EfficiencyComp[phi_,phid_,alpha1_,beta2_,etaStage_]:=0/;Psi[phi,phid,alpha1,beta2,etaStage]<=0;

PRatioComp[mred_,nred_,Mach_,phid_,alpha1_,beta2_,\[Gamma]_,etaStage_]:=Module[
{phi,psi,PRatio},
phi=Phi[mred,nred,Mach,\[Gamma]];
psi=Psi[phi,phid,alpha1,beta2,etaStage];
PRatio=(1.+Pi^2((\[Gamma]-1)/\[Gamma])nred^2 psi)^(\[Gamma]/(\[Gamma]-1.));
Return[PRatio]
];

plotPoint[x_,y_, color_] :=  Graphics[{PointSize[Large], color, Point[{x,y}]}];

multistageCompressorState[T01_,p01_,mflow_,Ncomp_  ,phid_,R_,\[Gamma]c_ ,alpha1_,beta2_,Area_,d_,etaStage_]:=Module[
{i,Z,delta,mredtot,nredtot,Ac1,dn,
T0n,p0n,perfo,mredn,nredn,betacn,delT0n,
sol,phin,Un,Mn,Tn,Can,betaCtot,delT0tot,
etaTot,T0nisen, 
nredOnD,mredOnD,choked,turbine,
betaCmap,etaCmap,nredCmap,delT0map,Machmap,
lastStage,lastStagemap,etaCmap1,
chokepoint},

delta=(\[Gamma]c-1.)/2.;

T0n=T01;
p0n=p01;

mredtot=mflow Sqrt[R T01]/(p01 Area[[1]]);
nredtot=(Ncomp d[[1]])/Sqrt[R T01];

Z=Length[d];
chokepoint={0,0};
perfo={};
Do[
lastStage=i;

{choked,{Can,Tn,Mn,phin,nredn,mredn}}=StageReducedProperties[mflow,Ncomp,d[[i]],Area[[i]],alpha1[[i]], p0n,T0n, R,\[Gamma]c];

If[choked,(*Print["choked at mred = ",mredtot," and nred = ", nredtot];*)chokepoint={mredtot,p0n/p01}; Break[]];

betacn=PRatioComp[mredn,nredn,Mn,phid[[i]],alpha1[[i]],beta2[[i]],\[Gamma]c,etaStage];

turbine=False;

If[betacn<1.,turbine=True;Break[]];

phin=Phi[mredn,nredn,Mn,\[Gamma]c];
delT0n=( betacn^((\[Gamma]c-1)/\[Gamma]c)-1)/EfficiencyComp[phin,phid[[i]],alpha1[[i]],beta2[[i]],etaStage];
T0n=T0n(1.+delT0n);

p0n=p0n * betacn ;

AppendTo[perfo,{betacn,delT0n,T0n,p0n,Can,Tn,Mn,phin,nredn,mredn}],
{i,1,Z}];

betaCtot=p0n/p01;
delT0tot=(T0n-T01)/T01;
T0nisen=T01*betaCtot^((\[Gamma]c-1)/\[Gamma]c);
etaTot=etaTotF[T01,T0nisen,T0n];

betaCmap={{mredtot,nredtot},betaCtot };
etaCmap1={{mredtot,nredtot}, etaTot};

etaCmap={mredtot,betaCtot, etaTot};
nredCmap={mredtot,betaCtot, nredtot};
delT0map={mredtot,betaCtot,delT0tot};
Machmap={mredtot,betaCtot,Mn};
lastStagemap={mredtot,betaCtot, lastStage};


Return[{betaCmap,etaCmap,nredCmap,delT0map,Machmap,lastStagemap,etaCmap1,perfo,chokepoint}]
];

etaTotF[T01_,T0nisen_,T0n_]:=(T0nisen-T01)/(T0n-T01)/;T0n-T01!=0; 

etaTotF[T01_,T0nisen_,T0n_]:=0/;T0n-T01==0; 




multistageCompressorMap[massflowOnD_, NcompOnD_, 
nrng_,nmflow_,T01_,p01_, phim_,
Rgas_,\[Gamma]_,
\[Alpha]1m_,\[Beta]2m_,Area_,meanDiameter_,
etaStage_,mapResolution_,dump_]:=Module[
{
rng,rngmin,rngmax,drng,
mflow,mflowmin,mflowmax,dmflow,
betaAll,etaAll,etaAll1,nredAll,delT0All,lastStageAll,MachAll,
betaCmap,etaCmap,nredmap,delT0map,Machmap,lastStagemap,etaCmap1,perfo,
betaF,etaCF,
xmin,xmax,ymin,ymax,
mssflow,Candum,Tndum,Mndum,phindum,nreddum,mreddum,choked,Ngiri,i,chokepoint,chokeAll,
mapPlot
},

(*Determination of maximum massflow as the massflow that causes first stage choking, aka right-hand map limit*)
Do[

Ngiri=NcompOnD*2;
mssflow=massflowOnD+i;
{choked,{Candum,Tndum,Mndum,phindum,nreddum,mreddum}}=StageReducedProperties[mssflow,Ngiri,meanDiameter[[1]],Area[[1]],\[Alpha]1m[[1]],p01,T01,Rgas,\[Gamma]];

If[choked,mflowmax=mssflow-0.5;Break[];],
{i,0,100,0.1}];

Print["First stage choking occurs at massflow = ", mssflow];



{rngmin,rngmax}={0.5 *NcompOnD, 1.08* NcompOnD};
mflowmin=0.0* massflowOnD;

drng=(rngmax-rngmin)/nrng;
dmflow=(mflowmax-mflowmin)/nmflow;

betaAll=etaAll=etaAll1=nredAll=delT0All=lastStageAll=MachAll=chokeAll={};
Do[
Do[
{betaCmap ,etaCmap ,nredmap ,delT0map ,Machmap ,lastStagemap ,etaCmap1 ,perfo, chokepoint }=multistageCompressorState[
T01 ,p01 ,mflow ,rng ,phim, Rgas, \[Gamma] ,\[Alpha]1m, \[Beta]2m, Area, meanDiameter, etaStage ];
AppendTo[betaAll,betaCmap];
AppendTo[etaAll,etaCmap];
AppendTo[etaAll1,etaCmap1];
AppendTo[nredAll,nredmap];
AppendTo[delT0All,delT0map];
AppendTo[MachAll,Machmap];
AppendTo[lastStageAll,lastStagemap];
AppendTo[chokeAll,chokepoint];
,{rng,rngmin,rngmax,drng}
]
,{mflow,mflowmin,mflowmax,dmflow}
];

(*betaF = Interpolation[betaAll];*)
betaF = Interpolation[betaAll,InterpolationOrder->6];
etaCF = Interpolation[etaAll1];

{{xmin,xmax},{ymin,ymax}}=betaF[[1]];

mapPlot=plotCompressorMap[mapResolution,betaF,{xmin,xmax,ymin,ymax},chokeAll];

If[dump,
(*betaAll>>PRatioCompMSdata.m;*)
betaF>>PRatioCompMS.m;
{{xmin,xmax,ymin,ymax},chokeAll}>>PRatioCompMSaux.m,
Return[{
{betaAll,etaAll,etaAll1,nredAll,delT0All,lastStageAll,MachAll},
{betaF,etaCF},
{xmin,xmax,ymin,ymax},chokeAll
}]
];
Return[mapPlot];

];


findCompressorStabilityBoundary[betaF_, xmin_, xmax_,ymin_,ymax_,nrng_,color_]:=Module[
{x,y,plStab,stabBnd,sol,xopt,yopt,point,stabBndF},
plStab={};
stabBnd={};
xopt=xmin;
Do[
(*sol=FindMaximum[betaF[x,y],{x,0.5(xmin+ xmax),xmin, xmax}];*)
sol=FindMaximum[betaF[x,y],{x,xopt,xmin, xmax}];
xopt=x/.sol[[2]];
yopt=sol[[1]];
AppendTo[stabBnd,{xopt,yopt}];
point=plotPoint[xopt,yopt,color] ;
AppendTo[plStab,point],
{y,ymin,ymax,(ymax-ymin)/nrng}
];
stabBndF=Interpolation[stabBnd];

Return[{plStab,stabBnd,stabBndF}]
];



findCompressorChokingBoundary[chokeList_]:=Module[{sortedList,boundaryList,interpBoundary},

sortedList=GatherBy[Sort[chokeList,#1[[1]]<#2[[1]]&],First];
boundaryList=Table[sortedList[[i,1]],{i,1,Length[sortedList]}];
interpBoundary=Interpolation[boundaryList,InterpolationOrder->2];

Return[{boundaryList,interpBoundary}];

];


plotCompressorMap[mapResolution_,PRatioCompMS_,range_,chokeAll_]:=Module[{nrng,nmflow,xmin,xmax,ymin,ymax,lowerLimit,upperlimit,plStab,stabBnd,stabBndF,boundaryList,interpBoundary,betaPlotMap,mapPlot},

nrng=mapResolution;nmflow=mapResolution;
{xmin,xmax,ymin,ymax}=range;

(*compute and plot stability boundary*)
{plStab,stabBnd,stabBndF}=findCompressorStabilityBoundary[PRatioCompMS, xmin, xmax,ymin,ymax,nrng,Red];

(*plot betaMap*)
lowerLimit=1.05*stabBnd[[1,1]];
betaPlotMap=Plot[Table[PRatioCompMS[x,y],{y,ymin,ymax,(ymax-ymin)/nrng}],{x,xmin,xmax},Frame->True,RegionFunction->Function[{x,y},x>lowerLimit]];

{boundaryList,interpBoundary}=findCompressorChokingBoundary[chokeAll];

upperlimit=1.2*stabBnd[[nrng+1,2]];
mapPlot=Show[betaPlotMap,
Plot[interpBoundary[x],{x,xmin,xmax},PlotStyle->White,Filling->Bottom,FillingStyle->Directive[Opacity[1],White]],
ListPlot[chokeAll,PlotStyle->LightGray],
Plot[stabBndF[x],{x,stabBndF["Domain"][[1,1]],stabBndF["Domain"][[1,2]]},Filling->Top,FillingStyle->Directive[Opacity[1],White]],plStab,PlotRange->{{lowerLimit,xmax},{1,upperlimit}},Frame->True,Axes->False,FrameLabel->{"\!\(\*SubscriptBox[\(m\), \(red\)]\)","\[CapitalPi]"}];
Return[mapPlot];
];


plotCompressorMapFromFile[mapResolution_]:=Module[{PRatioCompMS,xmin,xmax,ymin,ymax,chokeAll,mapPlot},

PRatioCompMS=<<"PRatioCompMS.m";
{{xmin,xmax,ymin,ymax},chokeAll}=<<"PRatioCompMSaux.m";
mapPlot=Quiet[plotCompressorMap[mapResolution,PRatioCompMS,{xmin,xmax,ymin,ymax},chokeAll]];
Return[mapPlot];

];


plotPoint[x_,y_, color_] :=  Graphics[{PointSize[Large], color, Point[{x,y}]}];


(* ::Section::Closed:: *)
(*Dimensional Analysis*)


(* ::Text:: *)
(*Module that computes non-dimensional parameters at design point*)


CalcNonDimPars[massflow_,cyclePNTs_,FlightMach_,CompressorPars_,\[Eta]t_,\[Eta]n_,\[Gamma]air_,\[Gamma]gas_,Rair_,Rgas_]:=Module[
{PNTa,PNT02,PNT03,PNT04,PNT05,PNTe,
pa,Ta,rhoa,sa,
p02,T02,rho02,s02,
p03,T03,rho03,s03,
p04,T04,rho04,s04,
p05,T05,rho05,s05,
pe,Te,rhoe,se,
AreaComp, DiameterComp, RPMcomp, etaC,
PratioRam,AreaRam,
mredComp,NredComp,PratioComp,TratioComp,\[CapitalDelta]T0Comp,
PratioBurner,TratioBurner,
TratioMax,
mredTurb,NredTurb,PratioTurb,TratioTurb,\[CapitalDelta]T0Turb,AreaTurb,
PratioNozzle,AreaNozzle,
NonDimPars},



{PNTa,PNT02,PNT03,PNT04,PNT05,PNTe}=cyclePNTs;
{pa,Ta,rhoa,sa}=PNTa;
{p02,T02,rho02,s02}=PNT02;
{p03,T03,rho03,s03}=PNT03;
{p04,T04,rho04,s04}=PNT04;
{p05,T05,rho05,s05}=PNT05;
{pe,Te,rhoe,se}=PNTe;

{AreaComp, DiameterComp, RPMcomp}=CompressorPars;

(*Intake*)
PratioRam=\[Epsilon][FlightMach](1+(\[Gamma]air-1)/2 FlightMach^2)^(\[Gamma]air/(\[Gamma]air-1));
(*AreaRam=(massflow Sqrt[Rair T02]/p02  \[Epsilon][FlightMach](1+(\[Gamma]air-1)/2 FlightMach^2)^(\[Gamma]air/(\[Gamma]air-1)))/mredIntake[1,FlightMach,\[Gamma]air]; *)
AreaRam=(massflow Sqrt[Rair T02]/p02  \[Epsilon][FlightMach])/mredIntake[1,FlightMach,\[Gamma]air];(* 2/6/2024*)

(*Compressor: Area, Diameter, RPM are known from compressor design*)
mredComp=massflow Sqrt[Rair T02]/p02;(*NOT normalized with Area*)
NredComp=(RPMcomp*DiameterComp)/Sqrt[Rair T02];

PratioComp=p03/p02;
TratioComp=T03/T02;
\[CapitalDelta]T0Comp=T03-T02;


(*Burner*)

PratioBurner=p04/p03;
TratioBurner=T04/T03;

TratioMax=T04/T02;

(*Turbine*)

PratioTurb=p04/p05;
TratioTurb=T04/T05;
\[CapitalDelta]T0Turb=T04-T05;
mredTurb=massflow Sqrt[Rgas T04]/p04; (*NOT normalized with Area*)
NredTurb=(RPMcomp DiameterComp)/Sqrt[Rgas T04];
AreaTurb=massflow/mredTurbine[1/PratioTurb,\[Eta]t,1.,\[Gamma]gas]  Sqrt[Rgas T04]/p04;

(*Nozzle*)
PratioNozzle=Min[(PratioComp PratioBurner PratioRam)/PratioTurb  ,1/PratioCrit[\[Gamma]gas]];

AreaNozzle=massflow/mredTurbine[1/PratioNozzle,\[Eta]n,1.,\[Gamma]gas]  Sqrt[Rgas T05]/ p05;

NonDimPars={PratioRam,AreaRam,
mredComp,NredComp,PratioComp,TratioComp,\[CapitalDelta]T0Comp,
PratioBurner,TratioBurner,
TratioMax,
mredTurb,NredTurb,PratioTurb,TratioTurb,\[CapitalDelta]T0Turb,AreaTurb,
PratioNozzle,AreaNozzle};


Return[NonDimPars]

];


(* ::Section:: *)
(*Build it*)


(* ::Subsection:: *)
(*Engine On-Design and Performance maps*)


BuildEngine[enginePars_,mapResolution_,report_]:=Module[
	{MOnD,z,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,\[Beta]c,Qf,\[Gamma]gas,Rgas,\[Eta]b,\[Eta]pb,T4,\[Eta]t,\[Eta]mt,\[Eta]n,massflowOnD,
	Ma1,etaStage,DF,\[CapitalDelta]T0stage,solidity,\[Sigma]material,\[Rho]blade,taper,
	compressorDesignChoices,
    p0aOnD,T0aOnD,\[Rho]0aOnD,s0aOnD,
	p02OnD,T02OnD,\[Rho]02OnD,s02OnD,
	p03OnD,T03OnD,\[Rho]03OnD,s03OnD,
	p04OnD,T04OnD,\[Rho]04OnD,s04OnD,
	p05OnD,T05OnD,\[Rho]05OnD,s05OnD,
	p9OnD,T9OnD,\[Rho]9OnD,s9OnD,
	PNTa,PNT02,PNT03,PNT04,PNT05,PNT9,
	cyclePNTs,energy,performance,
    nStages,allStates,triangle,plotComp,
    CompAreasD,rMeanD,DiameterD,rTipD,rRootD,\[Alpha]1D,\[Beta]2D,phiD,NcompD,mredD,
    plotCompressor,
    CompressorPars,NonDimPars,
	PratioRamOnD,AreaRamOnD,mredCompOnD,NredCOnD,
    PratioCompOnD,TratioCOnD,\[CapitalDelta]T0CompOnD,PratioBurnerOnD,
    TratioBurnerOnD,TratioMaxOnD,mredTurbOnD,NredTurbOnD,
    PratioTurbOnD,TratioTurbOnD,\[CapitalDelta]T0TurbOnD,AreaTurbOnD,
    PratioNozzleOnD,AreaNozzleOnD,
    varsOnD,designPars,m3m1=1.0,
    nrng,nmflow,dump,mapPlot
	},
		
	{MOnD,z,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,\[Beta]c,Qf,\[Gamma]gas,Rgas,\[Eta]b,\[Eta]pb,T4,\[Eta]t,\[Eta]mt,\[Eta]n,massflowOnD,compressorDesignChoices}=enginePars;
	{Ma1,\[CapitalDelta]T0stage,etaStage,DF,solidity,\[Sigma]material,\[Rho]blade,taper}=compressorDesignChoices;
	
	{cyclePNTs,energy,performance}=CalcTurbojetCycle[MOnD,z,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,\[Beta]c,Qf,\[Gamma]gas,Rgas,\[Eta]b,\[Eta]pb,T4,\[Eta]t,\[Eta]mt,\[Eta]n,report];
	{PNTa,PNT02,PNT03,PNT04,PNT05,PNT9}=cyclePNTs;
	{p0aOnD,T0aOnD,\[Rho]0aOnD,s0aOnD}=PNTa;
	{p02OnD,T02OnD,\[Rho]02OnD,s02OnD}=PNT02;
	{p03OnD,T03OnD,\[Rho]03OnD,s03OnD}=PNT03;
	{p04OnD,T04OnD,\[Rho]04OnD,s04OnD}=PNT04;
	{p05OnD,T05OnD,\[Rho]05OnD,s05OnD}=PNT05;
	{p9OnD,T9OnD,\[Rho]9OnD,s9OnD}=PNT9;

    If[report,
		Print[Style["Sizing Multi Stage Compressor",12,Bold,Blue]];
	];

	{nStages,allStates,triangle,plotComp}=designMultiStageCompressor[T02OnD,p02OnD,\[Beta]c,etaStage,\[Gamma]air,Rair,cp[\[Gamma]air,Rair],Ma1,DF,solidity,\[CapitalDelta]T0stage,massflowOnD,\[Sigma]material,\[Rho]blade,taper];
	
    If[report,
    Show[plotComp]
	];
	
	{CompAreasD,rMeanD,DiameterD,rTipD,rRootD,\[Alpha]1D,\[Beta]2D,phiD,NcompD,mredD}=collectCompressorGeometries[allStates,triangle,nStages,massflowOnD,Rair];
    
    If[report,
    plotCompressor=drawCompressor[allStates,7,8,nStages];Show[plotCompressor]
	];	

    CompressorPars={CompAreasD[[1]], DiameterD[[1]], NcompD};
    NonDimPars=CalcNonDimPars[massflowOnD,cyclePNTs,MOnD,CompressorPars,\[Eta]t,\[Eta]n,\[Gamma]air,\[Gamma]gas,Rair,Rgas];

    {PratioRamOnD,AreaRamOnD,mredCompOnD,NredCOnD,PratioCompOnD,TratioCOnD,\[CapitalDelta]T0CompOnD,PratioBurnerOnD,TratioBurnerOnD,TratioMaxOnD,mredTurbOnD,NredTurbOnD,PratioTurbOnD,TratioTurbOnD,\[CapitalDelta]T0TurbOnD,AreaTurbOnD,PratioNozzleOnD,AreaNozzleOnD} = NonDimPars;

	If[report,
		Print[Style["On Design Parameters",12,Bold,Blue]];
		Print["mredCompOnD :",mredCompOnD];
		Print["PratioCOnD :",PratioCompOnD];
		Print["PratioCombOnD :",PratioBurnerOnD];
        Print["TRatioMaxOnD :", TratioMaxOnD];
		Print["PratioTOnD :",PratioTurbOnD];
		Print["mredTOnD :",mredTurbOnD];
		Print["PratioNOnD :",PratioNozzleOnD];
		Print["NredTOnD :",NredTurbOnD];
		Print["AreaTurbOnD :",AreaTurbOnD];
		Print["AreaNozzleOnD :",AreaNozzleOnD];
		Print["AreaIntakeOnD :",AreaRamOnD];
        Print["AreaCompOnD :",CompAreasD[[1]]];

		
	];

    (*Generating Compressor Map*)
    nrng=mapResolution;nmflow=mapResolution;
    dump=True;
    mapPlot=Quiet[multistageCompressorMap[massflowOnD, NcompD, nrng,nmflow,T02OnD,p02OnD, phiD,Rgas,\[Gamma]air,\[Alpha]1D,\[Beta]2D,CompAreasD,DiameterD,etaStage,mapResolution,dump]];

    (*Generating Other Maps -- TBD*)

    designPars={MOnD,NredCOnD,CompAreasD[[1]],DiameterD[[1]],PratioBurnerOnD,m3m1,AreaTurbOnD,AreaNozzleOnD,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]mc,\[Gamma]gas,\[Gamma]gas,\[Gamma]air,Rgas,z};
	varsOnD={AreaRamOnD,mredCompOnD,TratioMaxOnD,NredTurbOnD,PratioTurbOnD,PratioNozzleOnD};

    Return[{designPars,varsOnD,mapPlot}];

	
]


(* ::Section:: *)
(*Off-Design exploration *)


(* ::Subsection::Closed:: *)
(*Equilibrium Point Calculation*)


(* ::Text:: *)
(*Module that tests the design equilibrium point*)


testOffDesignEquiPoint[designPars_,varsOnD_,print_]:=Module[
{eqns,
MOnD,alt,NredComp,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n=\[Gamma]t,\[Gamma]c,Rgas,
Mach,nredC,
nredT0,T03T010,mredC0,areaIntake0,pratioTurb0,pratioNozzle0,
vars,
test,
fac,varsSecant,
Pars,
equiState,
T01,p01,
AreaRam,mredComp,TratioMax,NredTurb,PratioTurb,PratioNozzle,
systemSol,equipoint,PratioComp,RPM,mflow,\[CapitalDelta]T012,T03,\[CapitalDelta]T034,Wcomp,Wturb,relerr,
OffDesignPars},

{MOnD,NredComp,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas,alt}=designPars;
Pars=Drop[designPars,-1];
{areaIntake0,mredC0,T03T010,nredT0,pratioTurb0,pratioNozzle0}=varsOnD; (*To be used as first guess for findroot, and to test the AE system*)


(*Setting variables vector*)
vars={{T03T01,T03T010},{nredT,nredT0},{mredC,mredC0},{areaIntake,areaIntake0},{pratioTurb,pratioTurb0},{pratioNozzle,pratioNozzle0}};

(*Adapting variables vector to secant method*)
fac=0.05;
varsSecant={{T03T01,(1-fac)T03T010,(1+fac)T03T010},{nredT,(1-fac)nredT0,(1+fac)nredT0},{mredC,(1-fac)mredC0,(1+fac)mredC0},{areaIntake,(1-fac)areaIntake0,(1+fac)areaIntake0},{pratioTurb,(1-fac)pratioTurb0,(1+fac)pratioTurb0},{pratioNozzle,(1-fac)pratioNozzle0,(1+fac)pratioNozzle0}};

(*Self-Test: verify that design values for vars are solution of the system*)
eqns=getEqns[Pars];
test=eqns/.{areaIntake->areaIntake0,mredC->mredC0,T03T01->T03T010,nredT->nredT0,pratioTurb->pratioTurb0,pratioNozzle->pratioNozzle0};

Do[
relerr=(Abs[test[[i]]]);
Print[ToString[Subscript["f",ToString[i]],TraditionalForm]<>"[\!\(\*SubscriptBox[\(x\), \(DES\)]\)] = "<>ToString[relerr, TraditionalForm]];
If[relerr>10^(-3),Print["SelfTest NOT passed",test];Abort[]]
,{i,1,6}
];
If[print,Print["SelfTest passed"]];


(*Getting system of algebraic equations*)
eqns=getEqns[Pars];

(*Solving system of algebraic equations (6 by 6)*)
equiState=solveAEsys[eqns,vars,False];

Print[equiState];

(*Solution*)
mredComp=mredC/.equiState;                    
TratioMax=T03T01/.equiState;        
NredTurb=nredT/.equiState;           
AreaRam=areaIntake/.equiState;    
PratioTurb=pratioTurb/.equiState;    
PratioNozzle=pratioNozzle/.equiState;

(*Computing other observables*)
T01=Tstd[alt]*(1+0.2 (MOnD)^2);
p01=pstd[alt]*(1+0.2 (MOnD)^2)^(\[Gamma]c/(\[Gamma]c-1));
PratioComp=PRatioCompMS[mredComp/areaComp,NredComp]; 
RPM=NredComp Sqrt[Rgas T01]/diameter;           
equipoint={mredComp,PratioComp};  
mflow=mredComp p01/Sqrt[Rgas T01];
\[CapitalDelta]T012=T01/\[Eta]c (PratioComp^((\[Gamma]c-1)/\[Gamma]c)-1);
T03=T01 TratioMax;
\[CapitalDelta]T034=\[Eta]t T03 (1-(1/\!\(TraditionalForm\`PratioTurb\))^((\[Gamma]t-1)/\[Gamma]t));
Wcomp=(mflow m3m1)/\[Eta]m cp[\[Gamma]c,Rgas] \[CapitalDelta]T012/1000.; 
Wturb=mflow cp[\[Gamma]t,Rgas] \[CapitalDelta]T034/1000. ;    

(*Printing results, if requested*)
If[print,
Print["Equilibrium Point              :",equipoint];
Print["Compressor Reduced MFlow       :",mredComp];
Print["Compressor Reduced Shaft Speed :",NredComp];
Print["Compression Ratio              :",PratioComp];
Print["RPM                            :",RPM];
Print["Maximum Temperature Ratio      :",TratioMax];
Print["Turbine Reduced Shaft Speed    :",NredTurb];
Print["Intake Capture Area            :",AreaRam];
Print["Turbine Expansion Ratio        :",PratioTurb];
Print["Nozzle Expansion Ratio         :",PratioNozzle];
Print["Critical Expansion Ratio       :",1/PratioCrit[\[Gamma]n]];
Print["Wcomp [KW]                     :",Wcomp];
Print["Wturb [KW]                     :",Wturb];
];

(*Setting output vector*)
systemSol={AreaRam,mredComp,TratioMax,NredTurb,PratioTurb,PratioNozzle};
OffDesignPars={systemSol,equipoint,NredComp,PratioComp,RPM,mflow,\[CapitalDelta]T012,T03,\[CapitalDelta]T034,Wcomp,Wturb};

Return[OffDesignPars];

]



(* ::Text:: *)
(*Module that computes an off-design equilibrium point*)


calcOffDesignEquiPoint[designPars_,offDesignVars_,firstGuess_,print_]:=Module[
{eqns,
MOnD,alt,NredComp,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas,
Mach,nredC,
nredT0,T03T010,mredC0,areaIntake0,pratioTurb0,pratioNozzle0,
vars,
test,
fac,varsSecant,
Pars,
equiState,
AreaRam,mredComp,TratioMax,NredTurb,PratioTurb,PratioNozzle,
systemSol,equipoint,T01,p01,PratioComp,RPM,mflow,\[CapitalDelta]T012,T03,\[CapitalDelta]T034,Wcomp,Wturb,
OffDesignPars},

{MOnD,NredComp,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas}=Drop[designPars,-1];
{Mach,nredC,alt}=offDesignVars;
{areaIntake0,mredC0,T03T010,nredT0,pratioTurb0,pratioNozzle0}=firstGuess; (*To be used as first guess for findroot, and to test the AE system*)


(*Setting variables vector*)
vars={{T03T01,T03T010},{nredT,nredT0},{mredC,mredC0},{areaIntake,areaIntake0},{pratioTurb,pratioTurb0},{pratioNozzle,pratioNozzle0}};

(*Adapting variables vector to secant method*)
fac=0.05;
varsSecant={{T03T01,(1-fac)T03T010,(1+fac)T03T010},{nredT,(1-fac)nredT0,(1+fac)nredT0},{mredC,(1-fac)mredC0,(1+fac)mredC0},{areaIntake,(1-fac)areaIntake0,(1+fac)areaIntake0},{pratioTurb,(1-fac)pratioTurb0,(1+fac)pratioTurb0},{pratioNozzle,(1-fac)pratioNozzle0,(1+fac)pratioNozzle0}};

(*Substituting off-design values for {Mach,nredC} in the parametrs vector *)
Pars={Mach,nredC,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas};

(*Getting system of algebraic equations*)
eqns=getEqns[Pars];

(*Solving system of algebraic equations (6 by 6)*)
equiState=solveAEsys[eqns,vars,False];

If[print,Print[equiState]];

(*Solution*)
T01=Tstd[alt]*(1+0.2 (Mach)^2);
p01=pstd[alt]*(1+0.2 (Mach)^2)^(\[Gamma]c/(\[Gamma]c-1));
mredComp=mredC/.equiState;                    
TratioMax=T03T01/.equiState;        
NredTurb=nredT/.equiState;           
AreaRam=areaIntake/.equiState;    
PratioTurb=pratioTurb/.equiState;    
PratioNozzle=pratioNozzle/.equiState;

(*Computing other observables*)
PratioComp=PRatioCompMS[mredComp/areaComp,nredC]; 
RPM=nredC Sqrt[Rgas T01]/diameter;           
equipoint={mredComp,PratioComp};  
mflow=mredComp p01/Sqrt[Rgas T01];
\[CapitalDelta]T012=T01/\[Eta]c (PratioComp^((\[Gamma]c-1)/\[Gamma]c)-1);
T03=T01 TratioMax;
\[CapitalDelta]T034=\[Eta]t T03 (1-(1/\!\(TraditionalForm\`PratioTurb\))^((\[Gamma]t-1)/\[Gamma]t));
Wcomp=(mflow m3m1)/\[Eta]m cp[\[Gamma]c,Rgas] \[CapitalDelta]T012/1000.; 
Wturb=mflow cp[\[Gamma]t,Rgas] \[CapitalDelta]T034/1000. ;    

(*Printing results, if requested*)
If[print,
Print["Equilibrium Point              :",equipoint];
Print["Compressor Reduced MFlow       :",mredComp];
Print["Compressor Reduced Shaft Speed :",nredC];
Print["Compression Ratio              :",PratioComp];
Print["RPM                            :",RPM];
Print["Maximum Temperature Ratio      :",TratioMax];
Print["Turbine Reduced Shaft Speed    :",NredTurb];
Print["Intake Capture Area            :",AreaRam];
Print["Turbine Expansion Ratio        :",PratioTurb];
Print["Nozzle Expansion Ratio         :",PratioNozzle];
Print["Critical Expansion Ratio       :",1/PratioCrit[\[Gamma]n]];
Print["Wcomp [KW]                     :",Wcomp];
Print["Wturb [KW]                     :",Wturb];
];

(*Setting output vector*)
systemSol={AreaRam,mredComp,TratioMax,NredTurb,PratioTurb,PratioNozzle};
OffDesignPars={systemSol,equipoint,nredC,PratioComp,RPM,mflow,\[CapitalDelta]T012,T03,\[CapitalDelta]T034,Wcomp,Wturb};

Return[OffDesignPars];

]



(* ::Subsection::Closed:: *)
(*System of Equations, solver and utilities*)


(* ::Subsubsection::Closed:: *)
(*Equations definition*)


getEqns[Pars_]:=Module[
{Mach,nredC,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas,
eqns},

{Mach,nredC,areaComp,diameter,p03p02,m3m1,areaTurb,areaNozzle,\[Eta]t,\[Eta]c,\[Eta]n,\[Eta]m,\[Gamma]t,\[Gamma]n,\[Gamma]c,Rgas}=Pars;
eqns={};

(*Import Multi Stage Compressor map*)
PRatioCompMS=<<"PRatioCompMS.m";
(*Print["Compressor Map import: Successful"];*)

(*Note that the variable mredC is defined without Area, while the compressor performance map has been built with the reduced massflow with Area*)

(* Compressor/Intake flow compatibility; it defines the capture area in off-design *)  
AppendTo[eqns,mredIntake[areaIntake,Mach,\[Gamma]c]-mredC  \[Epsilon][Mach](1+(\[Gamma]c-1)/2 Mach^2)^(\[Gamma]c/(\[Gamma]c-1))];
(*AppendTo[eqns,mredIntake[areaIntake,Mach,\[Gamma]c]-mredC  \[Epsilon][Mach]];(*2/6/2024*)*)

(* Compressor/Turbine flow compatibility*)
AppendTo[eqns,mredTurbine[1/pratioTurb,\[Eta]t,areaTurb,\[Gamma]t]-(  (mredC Sqrt[T03T01] m3m1)/(PRatioCompMS[mredC/areaComp,nredC] p03p02)  )];  

(* Turbine/Nozzle flow compatibility; *)
AppendTo[eqns,mredTurbine[1/pratioNozzle,\[Eta]n,areaNozzle,\[Gamma]n]-mredTurbine[1/pratioTurb,\[Eta]t,areaTurb,\[Gamma]t]\!\(TraditionalForm\`pratioTurb\) Sqrt[1-\[Eta]t(1-(1/pratioTurb)^((\[Gamma]t-1)/\[Gamma]t))]];

(* Compressor/Turbine Power balance*)   
AppendTo[eqns, m3m1  \[Eta]t T03T01  (1-(1/pratioTurb)^((\[Gamma]t-1)/\[Gamma]t)) - (1 /\[Eta]m  1/\[Eta]c cp[\[Gamma]c,Rgas]/cp[\[Gamma]t,Rgas] (PRatioCompMS[mredC/areaComp,nredC]^((\[Gamma]c-1)/\[Gamma]c)-1) ) ];

(* Reduced RPM compatibility*)   
AppendTo[eqns,nredT -( nredC Sqrt[1/T03T01])];

(* Pressure ratios compatibility:   Subscript[\[CapitalPi], d]Subscript[\[CapitalPi], C]Subscript[\[CapitalPi], CC] = Subscript[\[CapitalPi], T1] Min[Subscript[\[CapitalPi], N],Subsuperscript[\[CapitalPi], N, *]]  *)  
AppendTo[eqns,pratioNozzle-Evaluate[Min[1/PratioCrit[\[Gamma]n],1/pratioTurb p03p02 PRatioCompMS[mredC/areaComp,nredC] (1+(\[Gamma]c-1)/2 Mach^2)^(\[Gamma]c/(\[Gamma]c-1))]]];

Return[eqns];

]


printEqns[Pars_]:=Module[{eqns},

eqns=getEqns[Pars]/.{areaIntake->Global`Adiffuser,mredC->Global`mRedComp,T03T01->Global`tauMax,nredT->Global`NRedTurb,pratioTurb->Global`\[CapitalPi]Turb,pratioNozzle->Global`\[CapitalPi]Nozzle};
Print[eqns//TableForm];

]


(* ::Subsubsection::Closed:: *)
(*Solver*)


(* ::Text:: *)
(*Solver, with secant method (requires variables with two initial conditions) *)


solveAEsys[eqns_,varsSecant_,debug_]:=Module[
{s=0,e=0,
sol,equiState},

If[debug,Print["Solving algebraic system..."]];

If[debug,Print[eqns]];
If[debug,Print[varsSecant]];

equiState=FindRoot[eqns,varsSecant,Method->"Newton",DampingFactor->0.5,StepMonitor:>s++,EvaluationMonitor:>e++,MaxIterations->10000];
Print["Steps"->s;"Evaluations"->e];

Return[equiState];

]


(* ::Subsubsection::Closed:: *)
(*List of States Generator*)


(* ::Text:: *)
(*Module to Generate Off-Design List of States*)


MakeOffDesignStates[n_,xmin_,xmax_,ymin_,ymax_]:=Module[
{npnts,pnts,i,j,k,listStates},
pnts={};
For[i=2,i\[LessSlantEqual]n+1,
(*Print["Sum i :",i];*)
If[Mod[i,2]!=0,
For[j=1,j\[LessSlantEqual]i-1,
AppendTo[pnts,{j,i-j}];
(*Print[{j,i-j}];*)
j++];
,
For[j=i-1,j\[GreaterSlantEqual]1,
AppendTo[pnts,{j,i-j}];
(*Print[{j,i-j}];*)
j--];
];
i++];
k=0;
For[i=n+2,i\[LessSlantEqual]2 n,
(*Print["Sum i :",i];*)
k=k+1;
If[Mod[i,2]!=0,
For[j=k+1,j\[LessSlantEqual]i-1-k,
AppendTo[pnts,{j,i-j}];
(*Print[{j,i-j}];*)
j++];
,
For[j=i-1-k,j\[GreaterSlantEqual]k+1,
AppendTo[pnts,{j,i-j}];
(*Print[{j,i-j}];*)
j--];
];
i++];
npnts=Dimensions[pnts][[1]];
listStates=Table[{xmax-(pnts[[i,1]]-1)((xmax-xmin)/(n-1)),ymax-(pnts[[i,2]]-1)((ymax-ymin)/(n-1))},{i,1,npnts}];
listStates];


(* ::Subsubsection::Closed:: *)
(*Plot utilities*)


(* ::Text:: *)
(*Module to plot Off-Design List of States*)


plotOffDesignPerfo[perfo_,listorderedpoints_,ipar_,name_]:=Module[{mach,nred,n,orderingMach,orderingNred,pointsMach,pointsNred,plotM,plotN,plot},
mach = perfo[[All,1]];
nred=perfo[[All,10]];
n=Sqrt[Length[mach]];
orderingMach = Ordering[listorderedpoints[[All,1]]];
orderingNred = Ordering[listorderedpoints[[All,2]]];
pointsMach=Table[{mach[[i]],perfo[[i,ipar]]},{i,1,n^2}];
pointsNred=Table[{nred[[i]],perfo[[i,ipar]]},{i,1,n^2}];
plotM=ListLinePlot[Table[pointsMach[[orderingMach]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"Mach",name},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotN=ListLinePlot[Table[pointsNred[[orderingNred]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"RPM",name},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plot=GraphicsRow[{plotM,plotN},ImageSize->1000];
Return[plot]
]


plotOffDesignCycle[perfo_,cyclePars_,listorderedpoints_]:=Module[{n,samples,color,allPlots1,allPlots2,PointsTJ,energyTJ,performanceTJ,allPointsTJ,allperformanceTJ,ioffd,plCore,plIsobaraAmb,plIsobaraTop,alt,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,Qf,\[Gamma]t,Rgas,\[Eta]b,\[Eta]pb,\[Eta]t,\[Eta]mt,\[Eta]n,mach,nred,orderingMach,orderingNred,pointsMach,pointsNred,plotM,plotN,plotThrust,plotFC,plotUexit,plotcycle1,plotcycle2},
{alt,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,Qf,\[Gamma]t,Rgas,\[Eta]b,\[Eta]pb,\[Eta]t,\[Eta]mt,\[Eta]n}=cyclePars;
n=Sqrt[Length[perfo]];

color=ColorData["LightTemperatureMap"]/@(Range[0,n]/n);

allPointsTJ={};
allperformanceTJ={};
Do[
{PointsTJ,energyTJ,performanceTJ}=CalcTurbojetCycle[perfo[[i,1]],alt,\[Gamma]air,Rair,\[Eta]d,\[Eta]mc,\[Eta]c,perfo[[i,9]],Qf,\[Gamma]t,Rgas,\[Eta]b,\[Eta]pb,perfo[[i,13]],\[Eta]t,\[Eta]mt,\[Eta]n,False];
AppendTo[allPointsTJ,PointsTJ];
AppendTo[allperformanceTJ,performanceTJ],
{i,1,Length[perfo]}];

mach=perfo[[All,1]];
nred=perfo[[All,10]];
orderingMach = Ordering[listorderedpoints[[All,1]]];
orderingNred = Ordering[listorderedpoints[[All,2]]];
pointsMach=Table[{mach[[i]],allperformanceTJ[[i,1]]*perfo[[i,11]]},{i,1,n^2}];
pointsNred=Table[{nred[[i]],allperformanceTJ[[i,1]]*perfo[[i,11]]},{i,1,n^2}];
plotM=ListLinePlot[Table[pointsMach[[orderingMach]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"Mach","Thrust [N]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotN=ListLinePlot[Table[pointsNred[[orderingNred]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"RPM","Thrust [N]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotThrust=GraphicsRow[{plotM,plotN},ImageSize->1000];

pointsMach=Table[{mach[[i]],allperformanceTJ[[i,2]]*allperformanceTJ[[i,1]]*perfo[[i,11]]},{i,1,n^2}];
pointsNred=Table[{nred[[i]],allperformanceTJ[[i,2]]*allperformanceTJ[[i,1]]*perfo[[i,11]]},{i,1,n^2}];
plotM=ListLinePlot[Table[pointsMach[[orderingMach]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"Mach","Fuel Consumption [Kg/h]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotN=ListLinePlot[Table[pointsNred[[orderingNred]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"RPM","Fuel Consumption [Kg/h]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotFC=GraphicsRow[{plotM,plotN},ImageSize->1000];

pointsMach=Table[{mach[[i]],allperformanceTJ[[i,6]]},{i,1,n^2}];
pointsNred=Table[{nred[[i]],allperformanceTJ[[i,6]]},{i,1,n^2}];
plotM=ListLinePlot[Table[pointsMach[[orderingMach]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"Mach","nozzle exit V [m/s]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotN=ListLinePlot[Table[pointsNred[[orderingNred]][[(i*n)+1;;(i+1)*n]],{i,0,n-1}],PlotRange->{All,All},Frame->True,FrameLabel->{"RPM","nozzle exit V [m/s]"},PlotTheme->"Business",PlotStyle->ColorData["LightTemperatureMap"]/@(Range[0,n]/n)];
plotUexit=GraphicsRow[{plotM,plotN},ImageSize->1000];

(*Plot cycles at highest Mach number*)
allPlots1={};
samples = Ordering[listorderedpoints[[All,2]]][[-n;;]];
Do[
PointsTJ=allPointsTJ[[samples[[i]]]];
If[i==1,
plIsobaraAmb=Plot[{PointsTJ[[1,2]]*Exp[(S-PointsTJ[[1,4]])/cp[\[Gamma]t, Rgas]]},{S,0,PointsTJ[[6,4]]},PlotStyle->{Black,Dashed}]
];
plCore=ListPlot[Table[{PointsTJ[[i,4]],PointsTJ[[i,2]]},{i,1,Length[PointsTJ]}],Joined->True,PlotMarkers->{Automatic, Small},AspectRatio->1,ImageSize->700,Frame->True,FrameLabel->{"s","T"},PlotStyle->color[[-i]]];
AppendTo[allPlots1,plCore],
{i,1,n}];
(*plIsobaraTop=Plot[{PointsTJ[[3,2]]*Exp[(S-PointsTJ[[3,4]])/cp[\[Gamma]t, Rgas]]},{S,0,PointsTJ[[6,4]]},PlotStyle->{Black,Dashed}];*)
plotcycle1=Show[{allPlots1,plIsobaraAmb},PlotRange->{All,All}];

(*Plot cycles at lowest Mach number*)
allPlots2={};
samples = Ordering[listorderedpoints[[All,2]]][[;;n]];
Do[
PointsTJ=allPointsTJ[[samples[[i]]]];
If[i==1,
plIsobaraAmb=Plot[{PointsTJ[[1,2]]*Exp[(S-PointsTJ[[1,4]])/cp[\[Gamma]t, Rgas]]},{S,0,PointsTJ[[6,4]]},PlotStyle->{Black,Dashed}]
];
plCore=ListPlot[Table[{PointsTJ[[i,4]],PointsTJ[[i,2]]},{i,1,Length[PointsTJ]}],Joined->True,PlotMarkers->{Automatic, Small},AspectRatio->1,ImageSize->700,Frame->True,FrameLabel->{"s","T"},PlotStyle->color[[-i]]];
AppendTo[allPlots2,plCore],
{i,1,n}];
(*plIsobaraTop=Plot[{PointsTJ[[3,2]]*Exp[(S-PointsTJ[[3,4]])/cp[\[Gamma]t, Rgas]]},{S,0,PointsTJ[[6,4]]},PlotStyle->{Black,Dashed}];*)
plotcycle2=Show[{allPlots2,plIsobaraAmb},PlotRange->{All,All}];

Return[{plotThrust,plotFC,plotUexit,plotcycle1,plotcycle2}]
]


End[]
EndPackage[]
