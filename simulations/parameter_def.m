clearvars;clc;
% Define parameters for the coupled model 
% KNDy parameters
par.d1=0.2;
par.d2=1;
par.d3=10;
par.k1=4;
par.k2=40;
par.k01=0;
par.k02=0;
par.pr=0.008;
par.v0=25000;
par.KD=0.3;
par.KN=4;
par.Kr1=600; 
par.Kr2=200;
par.theta=0.5;
par.k=10;
par.je=1;
par.I0=0.19;
% MePD parameters
n=3;
par.dl= n;
par.di= n;
par.de= n;
par.cll= 16;
par.cil= 0;
par.cli= 0;
par.cii= 30;
par.cel= 16;
par.cei= 15;
par.cle= 11;
par.cie= 17;
par.cee= 0;
par.al= 1.3;
par.ai= 2;
par.ae= 2;
par.thetal= 4;
par.thetai= 3.7;
par.thetae= 3.7;
par.gamma1=1;
par.gamma2=0.115;
par.gamma3=0.0;
par.beta1=0.;
par.beta2=0.;
par.base_e=0;
par.base_l=0;%2.6
par.base_i=9;%9.3
% parameters for UCN3 stimulations
par.B=0; 
par.A=0.0; 
par.f=0.1*60;
% parameters for GABA stim
par.GABA_A=0;
par.GABA_B=0;
save('par.mat', "par")