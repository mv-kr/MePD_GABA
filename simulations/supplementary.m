clc; clearvars; close all
% load and define specific parameters
load("par.mat")
dt=0.001;
par.tspan = 0:dt:100;
par.opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
par.I0=0.20; % KNDy baseline
par.k=10; 
par.je=0.5;
antag = 0.5; % interaction strength suppression 
stim = 0.5; % amplitude of stim sine wave
stimB = 2.6; % magnitude of the sine wave baseline
baseline = 0;
baselineB = par.B;
%% Simulate
par.IC = [0.0;0.0;0.0;0;0;0];
% Baseline
[T1,Y1]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y1(round(length(Y1)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(1) = mean(diff(locs)*dt);
% UCN3 stimulation
par.B=stimB;
par.A=stim;
[T2,Y2]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y2(round(length(Y2)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(2) = mean(diff(locs)*dt);
% GABA receptor antagonism
par.A=baseline;
par.B=baselineB;
par.beta1=antag;
[T3,Y3]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y3(round(length(Y2)/3):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(3) = mean(diff(locs)*dt);
% GABA receptor antagonism + UCN3 stim
par.A=stim;
par.B=stimB;
par.beta1=antag;
[T4,Y4]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y4(round(length(Y4)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(4) = mean(diff(locs)*dt);
par.beta1=0;
% Glut receptor antagonism
par.B=baselineB;
par.A=baseline;
par.beta2=antag;
[T5,Y5]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y5(round(length(Y5)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(5) = mean(diff(locs)*dt);
% GABA receptor antagonism + UCN3 stim
par.A=stim;
par.B=stimB;
par.beta2=antag;
[T6,Y6]=ode45(@KNDyXMePDU,par.tspan,par.IC,par.opts,par);
x1 = Y6(round(length(Y6)/2):end,6)/60;
[~, locs] = findpeaks(x1, 'MinPeakProminence',10);
PeriodMain(6) = mean(diff(locs)*dt);
% plot the results
f=figure(1); clf
f.Units="centimeters";
f.OuterPosition = [25 25 20 40];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
% plot baseline
subplot(3,2,1)
ylim([0,3000])
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T1, Y1(:,6), 'LineWidth', 2, 'Color', 'k')
title('A')
ylabel('KNDy activity [Hz]')
xlim([30,90])
ylim([0,2500])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
% plot stimulation
ylim([0,3000])
subplot(3,2,2)
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T2, Y2(:,6), 'LineWidth', 2, 'Color', 'k')
title('B')
xlim([30,90])
ylim([0,2500])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
ylim([0,3000])
% plot GABA supp
subplot(3,2,3)
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T3, Y3(:,6), 'LineWidth', 2, 'Color', 'k')
title('C')
ylabel('KNDy activity [Hz]')
xlim([30,90])
ylim([0,2500])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
ylim([0,3000])
% plot GABA supp + UCN3 stim
subplot(3,2,4)
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T4, Y4(:,6), 'LineWidth', 2, 'Color', 'k')
title('D')
xlim([30,90])
ylim([0,2500])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
ylim([0,3000])
% plot glut supp
subplot(3,2,5)
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T5, Y5(:,6), 'LineWidth', 2, 'Color', 'k')
title('E')
xlabel('Time [min]')
ylabel('KNDy activity [Hz]')
xlim([30,90])
ylim([0,3000])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
% plot glut supp + UCN3 stim 
subplot(3,2,6)
set ( gca , 'FontSize' , 15, 'fontname' , 'DejaVu Sans');
hold on; box on; grid off;
plot(T6, Y6(:,6), 'LineWidth', 2, 'Color', 'k')
title('F')
xlabel('Time [min]')
xlim([30,90])
ylim([0,3000])
xticks([30,50,70,90])
xticklabels([0,20,40,60])
% saveas(f, 'uro.svg')
% Check the period
disp(PeriodMain)