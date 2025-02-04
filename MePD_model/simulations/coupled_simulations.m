clc; clearvars; close all
% load and define specific parameters
load("par.mat")
dt=0.001;
tau=98;
par.tspan = 0:dt:tau;
par.opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
par.I0=0.2;
par.k=10;
par.je=0.5;
antag = 0.5; % suppression strength
stim = 0.5; %amplitude stim
stimB = 2.6; % baseline of sine wave for UCN3
baseline = 0;
baselineB = par.B;
%% Simulations
par.IC = [0.0;0.0;0.0;0;0;0];
% Baseline
[T1,Y1]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y1(round(length(Y1)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(1) = mean(diff(locs)*dt);
tau2=120;
par.tspan = 0:dt:tau2;
% UCN3 stimulation
par.B=stimB;
par.A=stim;
par.IC = Y1(end,:);
[T2,Y2]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y2(round(length(Y2)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(2) = mean(diff(locs)*dt);
% GABA receptor antagonism + UCN3 stim
par.A=stim;
par.B=stimB;
par.beta1=0.5;
par.GABA_B=-0;
par.GABA_A=0.0;
par.je=0.5;
[T3,Y3]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y3(round(length(Y3)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(3) = mean(diff(locs)*dt);
% GABA stim
par.A=baseline;
par.B=baselineB;
par.beta1=0;
par.GABA_A=4;
par.GABA_B=8.15;
[T4,Y4]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y4(round(length(Y4)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(4) = mean(diff(locs)*dt);
% Plot results
f=figure(1); clf
f.Units="centimeters";
f.InnerPosition = [20 25 20 40];
hold on; box on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
% plot UCN3 stimulation
subplot(4,1,1)
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
hold on; box on;box on; grid off; 
plot(T1, Y1(:,6), 'LineWidth', 2, 'Color', 'k')
plot(T2+tau, Y2(:,6), 'LineWidth', 2, 'Color', 'k')
ylabel('KNDy activity (Hz)')
xlim([tau-60,tau+120])
ylim([0,3500])
xticks([tau-60,tau-30,tau,tau+30,tau+60,tau+90 tau+120 tau+150 tau+180])
xticklabels([0,30,60,90,120,150,180 140 160 180])
% plot UCN3 stim + GABA supp
subplot(4,1,3)
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
hold on; box on; box on; grid off; 
plot(T1, Y1(:,6), 'LineWidth', 2, 'Color', 'k')
plot(T3+tau, Y3(:,6), 'LineWidth', 2, 'Color', 'k')

ylabel('KNDy activity (Hz)')
xlim([tau-60,tau+120])
ylim([0,3500])
xticks([tau-60,tau-30,tau,tau+30,tau+60,tau+90 tau+120 tau+150 tau+180]) 
xticklabels([0,30,60,90,120,150,180 140 160 180])
%plot GABA stimulation
subplot(4,1,2)
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
hold on; box on; box on; grid off; 
plot(T1, Y1(:,6), 'LineWidth', 2, 'Color', 'k')
plot(T4+tau, Y4(:,6), 'LineWidth', 2, 'Color', 'k')
% title('Basal')
ylabel('KNDy activity (Hz)')
xlim([tau-60,tau+120])
ylim([0,3500])
xticks([tau-60,tau-30,tau,tau+30,tau+60,tau+90 tau+120 tau+150 tau+180])
xticklabels([0,30,60,90,120,150,180 140 160 180])
%% Parameters for stress stimulations
par.IC = Y1(end,:);
par.a=8;
par.r2=3;
par.b=3.9;
par.r1=15;
% simulate restraint stress
[T5,Y5]=ode45(@KNDyXMePD_stress,par.tspan,par.IC,par.opts,par);
x1 = Y5(:,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(5) = mean(diff(locs)*dt);
% plot restraint stress
subplot(4,1,4)
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
hold on; box on; box on; grid off; 
plot(T1, Y1(:,6), 'LineWidth', 2, 'Color','k')
plot(T5+tau, Y5(:,6), 'LineWidth', 2, 'Color','k')
ylabel('KNDy activity (Hz)')
xlabel('Time (sec)')
xlim([tau-60,tau+120])
ylim([0,3500])
xticks([tau-60,tau-30,tau,tau+30,tau+60,tau+90 tau+120 tau+150 tau+180])
xticklabels([0,30,60,90,120,150,180 140 160 180])
xlabel('Time [min]')
saveas(f, 'fig1.svg')
disp(PeriodMain)
% Colours for MePD GABA curves
colour.bgreen = [0, 0.784, 0];
colour.dgreen = [0.247, 0.502, 0];
%% Plot supplementary dipiciting long-term behaviour in MePD during
% interventions
f=figure(2); clf
f.Units="centimeters";
f.InnerPosition = [20 25 20 35];
hold on; box on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
% plot UCN3 stim
subplot(4,1,1)
set ( gca , 'FontSize' , 18 , 'fontname' , 'DejaVu Sans');
hold on; box on
plot(T1, Y1(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T2+tau, Y2(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T2+tau, Y2(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T1, Y1(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
plot(T2+tau, Y2(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
xlim([tau-5 tau+40])
xticks([tau,tau+10,tau+20,tau+30, tau+40])
xticklabels([60,70,80,90, 100])
ylim([-0.05 0.6])
% plot UCN3 stim + GABA supp
subplot(4,1,3)
set ( gca , 'FontSize' , 18 , 'fontname' , 'DejaVu Sans');
hold on; box on
plot(T1, Y1(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T2+tau, Y3(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T2+tau, Y3(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T1, Y1(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
plot(T2+tau, Y3(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
xlim([tau-5 tau+40])
xticks([tau,tau+10,tau+20,tau+30, tau+40])
xticklabels([60,70,80,90, 100])
ylim([-0.05 0.6])
% plot GABA stim
subplot(4,1,2)
set ( gca , 'FontSize' , 18 , 'fontname' , 'DejaVu Sans');
hold on; box on
plot(T1, Y1(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T2+tau, Y4(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T2+tau, Y4(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T1, Y1(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
plot(T2+tau, Y4(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
xlim([tau-5 tau+40])
xticks([tau,tau+10,tau+20,tau+30, tau+40])
xticklabels([60,70,80,90, 100])
ylim([-0.05 0.6])
% plot restraint stress
subplot(4,1,4)
set ( gca , 'FontSize' , 18 , 'fontname' , 'DejaVu Sans');
hold on; box on
plot(T1, Y1(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T2+tau, Y5(:,1), 'LineWidth', 2, 'Color','b',LineStyle='-')
plot(T1, Y1(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T2+tau, Y5(:,2), 'LineWidth', 2, 'Color',colour.bgreen,LineStyle='-')
plot(T1, Y1(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
plot(T2+tau, Y5(:,3), 'LineWidth', 2, 'Color',colour.dgreen,LineStyle='-')
xlim([tau-5 tau+40])
xticks([tau,tau+10,tau+20,tau+30, tau+40])
xticklabels([60,70,80,90, 100])
ylim([-0.05 0.6])
% saveas(f, 'fig2.svg')