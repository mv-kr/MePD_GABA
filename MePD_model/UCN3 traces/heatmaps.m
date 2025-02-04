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

%% plot stimulation data as a heatmap
f = figure(1); clf;
f.Units = "centimeters";
f.InnerPosition = [20 10 23.4 5]; % set figure size
hold on;
set(gca, 'FontSize', 16, 'FontName', 'DejaVu Sans'); % set axis font properties

% plot heatmap of normalized activity
temp = pcolor(normalized_activity');
shading interp;
colormap('jet');

% configure colorbar settings
c = colorbar('Location', 'northoutside', 'FontName', 'DejaVu Sans', 'FontSize', 16);
set(c, 'Ticks', [0, 0.2, 0.4, 0.6, 0.8, 1]);

% set axis limits and labels
ylim([1 8]);
xlim([0 1200]);
xticks([]);
yticks([1, 8]);
yticklabels([0, 7]);

% optimize figure rendering
set(gcf, 'Renderer', 'Painters');

% save figure
% saveas(f, 'heatstim.svg');

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

%% plot stress data as a heatmap
f = figure(2); clf;
f.Units = "centimeters";
f.InnerPosition = [20 10 23.6 5]; % set figure size
hold on;
set(gca, 'FontSize', 16, 'FontName', 'DejaVu Sans'); % set axis font properties

% plot heatmap of normalized activity
temp = pcolor(normalized_activity');
shading interp;
colormap('jet');

% configure colorbar settings
c = colorbar('Location', 'northoutside', 'FontName', 'DejaVu Sans', 'FontSize', 16);

% set axis limits and labels
ylim([1 6]);
xlim([0 1200]);
xticks([]);
yticks([1, 6]);
yticklabels([0, 5]);

% optimize figure rendering
set(gcf, 'Renderer', 'Painters');

% save figure
% saveas(f, 'heatstress.svg', 'svg');
