% Code to produce visualisation of average UCN3 traces during UCN3
% optogenetic stimulation and restraint stress
clearvars; close all; clc
% load data for UCN3 stim
data = readtable('G16stim.csv', 'TextType', 'string');
time = data.Var1; % time column
% specify the time of start and end of the stim
t.start = 1202;
t.end = 2403;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end};
% normalise the traces
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));
% average the traces
average_trace = mean(normalized_activity, 2);
% plot the results
f=figure(1); clf
f.Units="centimeters";
f.OuterPosition = [20 10 23.6 4];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
num_traces = size(normalized_activity, 2);
plot(time_stim, average_trace, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Average Trace');
xlim([120 240])
xticklabels([0 30 60 90 120 ])
xticks([])
% ylabel('\DeltaF/F');
hold off;
% saveas(f, 'stim.svg')

clearvars; clc
% load data for restraint stress
data = readtable('G16stress.csv', 'TextType', 'string');
time = data.Var1; % time column
% define the time of the start and end of the restraint
t.start = 1700;
t.end = 3300;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end};
% normalise the activity
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));
% average the activity
average_trace = mean(normalized_activity, 2);
% plot the results
f=figure(2); clf
f.Units="centimeters";
f.OuterPosition = [20 20 23.6 4];
hold on; box on; grid off; 
set ( gca , 'FontSize' , 15 , 'fontname' , 'DejaVu Sans');
num_traces = size(normalized_activity, 2);
plot(time_stim, average_trace, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Average Trace');
xlim([178 298])
ylim([0 1])
xticks([])
% ylabel('\DeltaF/F');
hold off;
% saveas(f, 'stress.svg')