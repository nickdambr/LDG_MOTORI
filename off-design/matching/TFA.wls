#!/usr/bin/env wolframscript
(* ::Package:: *)

Clear["Global'"]
SetDirectory[DirectoryName[$InputFileName]];
Get["ModulesForAircraftEngine.wl"];

NiccoLaptopPythonExe="C:\\Users\\nickd\\AppData\\Local\\Programs\\Python\\Python39\\python.exe";
pythonExe=NiccoLaptopPythonExe;

\[Gamma]air=1.4;
Rair=287.;
\[Eta]d=.9;
\[Eta]pf=.89;
\[Eta]mc=\[Eta]mf=.99;
\[Eta]pc=.9;
\[Epsilon]1 = \[Epsilon]2 = 0.075;
Qf=43500000.;
\[Gamma]gas=1.33;
Rgas=287.;
\[Eta]b=.995;
\[Eta]ab=.97;
\[Eta]pb=\[Eta]pab=.95;
T4max=2000.;
TR=1.09916;
T7=2200.;
\[Eta]pt=.89;
\[Eta]mt=.99;
\[Eta]n=.97;
JP8="CYC9H18:0.292,AC10H21:0.319,NC10H22:0.090,NAPHT:0.228,TOLUEN:0.071";
oxid="O2:1,N2:3.76";

inputFile="input.json";
input = Import[inputFile, "JSON"];
BPR="BPR"/. input;
\[Beta]c="Beta_c"/. input;
Ma="Mach"/. input;
z="quota"/. input;




equilibriumFile="equilibrium.json";
{corePointsTF, fanPointsTF, energyTF, performanceTF, betaTF}=CalcTurboFanCycle[pythonExe,Ma,z,\[Gamma]air,Rair,\[Eta]d,\[Eta]pf,\[Eta]mf,BPR,\[Eta]pc,\[Eta]mc,\[Beta]c,\[Epsilon]1,\[Epsilon]2,Qf,\[Gamma]gas,Rgas,\[Eta]b,\[Eta]ab,\[Eta]pb,\[Eta]pab,T4max,TR,T7,\[Eta]pt,\[Eta]mt,\[Eta]n,JP8,oxid,equilibriumFile,False,"adapted","off","interpolation"];


corePointsTF



input2 = Import[equilibriumFile,"JSON"];
If[!FileExistsQ[equilibriumFile],
  Print["File not found: ", equilibriumFile];
  Exit[1];
];
{Ia,TSFC}=performanceTF[[1;;2]]
fs = "normalized_species" /. input2;
NOmassfrac = "NO" /. fs;
NO2massfrac = "NO2" /. fs;
COmassfrac = "CO" /. fs;

EINOX = (NOmassfrac + NO2massfrac)*10^(3);
EICO = (COmassfrac)*10^(3);
Export[outputFile,<|"Ia"->Ia,"TSFC"->TSFC,"EINOX"-> EINOX, "EICO"-> EICO|>];
