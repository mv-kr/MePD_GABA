%% clear workspace, close figures, and clear command window
clearvars; close all; clc

%% load and process stimulation data
data = readtable('G16stim.csv', 'TextType', 'string');
time = data.Var1; % extract time column

% define time window for stimulation analysis
t.start = 1202;
t.end = 2403;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end}; % extract activity data

% normalize activity traces using min-max normalization
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));

% compute the average trace across all activity columns
average_trace = mean(normalized_activity, 2);

%% plot stimulation data
f = figure(1); clf;
f.Units = "centimeters";
f.OuterPosition = [20 10 23.6 4]; % set figure size
hold on; box on; grid off;
set(gca, 'FontSize', 15, 'FontName', 'DejaVu Sans'); % set axis font properties

% plot the average trace
plot(time_stim, average_trace, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Average Trace');

% customize axis labels and limits
xlim([120 240]);
xticklabels([0 30 60 90 120]);
xticks([]); % remove x-ticks
ylabel('\DeltaF/F');

% save figure
% saveas(f, 'stim.svg');

%% clear workspace and process stress data
clearvars; clc;
data = readtable('G15stress.csv', 'TextType', 'string');
time = data.Var1; % extract time column

% define time window for stress analysis
t.start = 1830;
t.end = 3300;
time_stim = time(t.start:t.end);
activity_columns = data{t.start:t.end, 2:end}; % extract activity data

% normalize activity traces using min-max normalization
normalized_activity = (activity_columns - min(activity_columns)) ./ ...
                      (max(activity_columns) - min(activity_columns));

% compute the average trace across all activity columns
average_trace = mean(normalized_activity, 2);

%% plot stress data
f = figure(2); clf;
f.Units = "centimeters";
f.OuterPosition = [20 20 23.6 4]; % set figure size
hold on; box on; grid off;
set(gca, 'FontSize', 15, 'FontName', 'DejaVu Sans'); % set axis font properties

% plot the average trace
plot(time_stim, average_trace, 'LineWidth', 2, 'Color', 'r', 'DisplayName', 'Average Trace');

% customize axis labels and limits
xlim([183 298]);
ylim([0 1]);
xticks([]); % remove x-ticks
ylabel('\DeltaF/F');

% save figure
% saveas(f, 'stress.svg');
