% Code to produce visualisation of heatmaps of UCN3 traces during UCN3
% optogenetic stimulation and restraint stress
clearvars; close all; clc
% load data for UCN3 stim
data = readtable('G16stim.csv', 'TextType', 'string');
% specify the time of start and end of the stim
time = data.Var1; % time column
t.start = 1202;
t.end = 2403;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end};
% Normalise the activity
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));
% plot the results
f=figure(1); clf
f.Units="centimeters";
f. InnerPosition = [20 10 31.1 6];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
imagesc(normalized_activity')
colormap('jet');
c = colorbar('Location', 'northoutside');
% customize color bar ticks
set(c, 'Ticks', [0, 0.2, 0.4, 0.6, 0.8, 1]); 
ylim([1 8])
xlim([0 1200])
xticks([])
yticks([])
% saveas(f, 'heatstim.svg')
% read data for restraint stress
clearvars; close all; clc
data = readtable('G16stress.csv', 'TextType', 'string');
time = data.Var1; % time column
% define the time of the start and end of the restraint
t.start = 1800;
t.end = 3300;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end};
% normalise the activity
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));
% plot the results
f=figure(2); clf
f.Units="centimeters";
f.InnerPosition = [20 10 31.1 6];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
imagesc(normalized_activity')
colormap('jet');
c = colorbar('Location', 'northoutside'); 
% customize color bar ticks
set(c, 'Ticks', [0, 0.2, 0.4, 0.6, 0.8, 1]); 
ylim([1 6])
xlim([0 1200])
xticks([])
yticks([])
% saveas(f, 'heatstress.svg')