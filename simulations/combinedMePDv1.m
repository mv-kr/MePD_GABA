%Simulate the MePD circuit during UCN3 optogenetic stimulation & 
% restraint stress
clc; clearvars
% set up parameters
dt=0.01;
par.tspan = 0:dt:150;
par.opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
% see MePDU.m and MePD_stress.m for details
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
par.base_l=0;
par.base_i=9;
%% parameters for UCN stimulations
par.B=2.6; 
par.A=0.5; 
par.f=0.1*60;
%% parameters for GABA stimulation (leave as 0)
par.GABA_A=0;
par.GABA_B=0;
%% Simulate MePD during UCN3 optogentic stimulation
par.IC = [0.0;0.0;0.0];
[T1,Y1]=ode45(@MePDU,par.tspan,par.IC,par.opts,par);
n=length(Y1(:,2))-round(length(Y1(:,2))/15.001);
% GABA colours
colour.bgreen = [0, 0.784, 0];
colour.dgreen = [0.247, 0.502, 0];
% plot the results
f=figure(1); clf
f.Units="centimeters";
f.InnerPosition = [20 10 31 10];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 18 , 'fontname' , 'DejaVu Sans');
yyaxis left
ax = gca; 
ax.YAxis(1).Color = colour.bgreen;
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen) % GABA interneurins
yticks([0.07, 0.1, 0.13])
ylim([min(Y1(n:end,2)) max(Y1(n:end,2))])
yyaxis right
ax = gca; 
ax.YAxis(2).Color = colour.dgreen;
plot(T1, Y1(:,3), 'LineWidth', 2,'Color',colour.dgreen) % GABA efferent neurons
ylim([min(Y1(n:end,3)) max(Y1(n:end,3)) ])
xlim([147.3,149.3])
xlabel('time [sec]')
xticks([147.3,147.8,148.3,148.8,149.3])
xticklabels([0,30,60,90,120])
hold off
% uncomment next line to produce a .svg
% saveas(f, 'uro.svg')
%% parameters for restraint stress
par.a=10;
par.b=3.9;
par.r1=10;
par.r2=1;
%% simulate MePD during restraint stress
par.IC = [0.5;0.1;0.15];
par.tspan = 0:dt:2;
[T1,Y1]=ode45(@MePD_stress,par.tspan,par.IC,par.opts,par);
% plot the results
f=figure(2); clf
f.Units="centimeters";
f.InnerPosition = [20 10 31.2 10];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 16 , 'fontname' , 'DejaVu Sans');
yyaxis left
ax = gca;
ax.YAxis(1).Color = colour.bgreen;
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen) % GABA interneurons
yticks([0.04, 0.08, 0.12])
ylim([min(Y1(:,2))-0.01 max(Y1(:,2))+0.01])
yyaxis right
ax = gca; 
ax.YAxis(2).Color = colour.dgreen;
plot(T1, Y1(:,3), 'LineWidth', 2,'Color',colour.dgreen) % GABA efferent neurons
xlim([0.0 2])
ylim([min(Y1(:,3))-0.01 max(Y1(:,3))+0.01])
xlabel('time [sec]')
xticks([0 0.5 1 1.5 2 ])
xticklabels([0,30,60,90,120])
yticks([0.2 0.3 0.4])
hold off
% saveas(f, 'stress.svg')




