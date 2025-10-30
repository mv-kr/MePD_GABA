clc; clearvars; close all
% Define the normalize function as an anonymous function
normalize = @(x) (x - min(x)) / (max(x) - min(x));

% Define indices
n1 = 1200;
n2 = 2400;
base_path = './data/UCN3_stimulation/';

data_paths5HZ = {
    'G7 20231110 5hz 222sti.csv',
    'G7 20240201 5hz 223sti.csv',
    'G8 20231217 5hz 222sti.csv',
    'G8 20240202 5hz 223sti.csv',
    'G8 20240220 5hz 223sti.csv',
     'G8 20240301 5hz 223sti.csv',
     'G9 20231217 5hz 222sti.csv',
     'G9 20240202 5hz 223sti.csv',
     'G9 20240301 5hz 223sti.csv',
     'G9 20240307 5hz 223sti.csv',
     'G28 20240701 5hz 223sti.csv',
     'G28 20240704 5hz 223sti.csv',
     'G28 20240709 5hz 223sti.csv',
     'G29 20240703 5hz 223sti.csv',
     'G29 20240705 5hz 223sti.csv',
     'G29 20240711 5hz 223sti.csv',
     'G37 5hz 223sti 20240720 A.csv',
     'G37 5hz 223sti 20240720 B.csv',
     'G37 5hz 223sti 20240720 C.csv',
     'G37 5hz 223sti 20240724.csv'
    };

data_paths10HZ = {
    'G7 20231110 10hz 222sti.csv',
    'G7 20240201 10hz 223sti.csv',
    'G8 20231218 10hz 222sti.csv',
    'G8 20240202 10hz 223sti.csv',
    'G8 20240220 10hz 223sti.csv',
     'G8 20240301 10hz 223sti.csv',
     'G9 20231218 10hz 222sti.csv',
     'G9 20240202 10hz 223sti.csv',
     'G9 20240228 10hz 223sti.csv',
     'G9 20240307 10hz 223sti.csv',
     'G28 20240701 10hz 223sti.csv',
     'G28 20240704 10hz 223sti.csv',
     'G28 20240709 10hz 223sti.csv',
     'G29 20240703 10hz 223sti.csv',
     'G29 20240705 10hz 223sti.csv',
     'G29 20240711 10hz 223sti.csv',
     'G37 10hz 223sti 20240720 A.csv',
     'G37 10hz 223sti 20240720 B.csv',
     'G37 10hz 223sti 20240721 A.csv',
     'G37 10hz 223sti 20240721 B.csv'
    };

data_paths20HZ = {
    'G7 20231110 20hz 222sti.csv',
    'G7 20240202 20hz 223sti.csv',
    'G8 20231217 20hz 222sti.csv',
    'G8 20240202 20hz 223sti.csv',
    'G8 20240220 20hz 223sti.csv',
     'G8 20240301 20hz 223sti.csv',
     'G9 20231217 20hz 222sti.csv',
     'G9 20240202 20hz 223sti.csv',
     'G9 20240221 20hz 223sti.csv',
     'G9 20240307 20hz 223sti.csv',
     'G28 20240701 20hz 223sti.csv',
     'G28 20240704 20hz 223sti.csv',
     'G28 20240709 20hz 223sti.csv',
     'G29 20240703 20hz 223sti.csv',
     'G29 20240705 20hz 223sti.csv',
     'G29 20240711 20hz 223sti.csv',
     'G37 20hz 223sti 20240720 A.csv',
     'G37 20hz 223sti 20240720 B.csv',
     'G37 20hz 223sti 20240721 A.csv',
     'G37 20hz 223sti 20240721 B.csv'
    };

paths = [data_paths5HZ; data_paths10HZ; data_paths20HZ];

%%
len_dat = length(paths);
A = zeros(1,len_dat);
for j=1:len_dat
    % load data file
    filename =  [base_path paths{j}];
    opts = detectImportOptions(filename);
    opts = setvartype(opts, 'double'); % ensure all data are treated as numeric
    calcium = readtable(filename, opts);
    % Drop the first row - contains info whether the cell is accepted (all are here)
    calcium(1,:) = [];
    % Rename the first column to 'time'
    calcium.Properties.VariableNames{1} = 'time';
    % Convert table to matrix
    calcium_array = table2array(calcium);
    % Extract time and signals
    time_all = calcium_array(:,1);
    time_stim= time_all(n1:n2) - time_all(n1);
    calcium_stim = calcium_array(n1:n2, 2:end);
    % Normalize each trace (column-wise)
    for i = 1:size(calcium_stim, 2)
        calcium_stim(:,i) = normalize(calcium_stim(:,i));
    end
     % find correlation - Z-score each neuron (column-wise) + covariance
    X = zscore(calcium_stim);    
    cova= cov(X);
    dist= 1 - cova;  % 1 - covariance
    dist(1:size(dist, 1) + 1:end) = 0;  
    % Perform hierarchical clustering using agglomerative method (linkage)
    Z = linkage(squareform(dist), 'average');  % 'average' linkage
    labels_hier_stim = cluster(Z, 'maxclust', 2);  % Assign cluster labels for basal

    % Separate traces in calcium_basal based on labels_hier_stim_basal
    cluster_0 = calcium_stim(:, labels_hier_stim == 1);  % Traces belonging to cluster 0
    cluster_1 = calcium_stim(:, labels_hier_stim == 2);  % Traces belonging to cluster 1

    % Compute the mean across cells for each cluster
    mean_across_cells1 = mean(cluster_0, 2);  % Mean across rows (neurons) for cluster 0
    mean_across_cells2 = mean(cluster_1, 2);  % Mean across rows (neurons) for cluster 1

    A(j)=corr(mean_across_cells1,mean_across_cells2 );
end
%%
groups = [ones(20,1); 2*ones(20,1); 3*ones(length(A)-40,1)];

cmap  = [
    76  114 176  
    76  114 176
    221 131  83   
    221 131  83
    221 131  83
    221 131  83
    85  168 104 
    85  168 104 
    85  168 104 
    85  168 104 
    196  78  82
    196  78  82
    196  78  82
    129 114 179  
    129 114 179 
    129 114 179 
    147 120  96 
    147 120  96 
    147 120  96 
    147 120  96
    76  114 176  
    76  114 176
    221 131  83   
    221 131  83
    221 131  83
    221 131  83
    85  168 104 
    85  168 104 
    85  168 104 
    85  168 104 
    196  78  82
    196  78  82
    196  78  82
    129 114 179  
    129 114 179 
    129 114 179 
    147 120  96 
    147 120  96 
    147 120  96 
    147 120  96
    76  114 176  
    76  114 176
    221 131  83   
    221 131  83
    221 131  83
    221 131  83
    85  168 104 
    85  168 104 
    85  168 104 
    85  168 104 
    196  78  82
    196  78  82
    196  78  82
    129 114 179  
    129 114 179 
    129 114 179 
    147 120  96 
    147 120  96 
    147 120  96 
    147 120  96
] / 255;


f = figure(1); clf
f.Units = "centimeters";
f.Position = [5 5 30 25];
hold on; box on; grid off;
set(gca, 'FontSize', 20, 'fontname', 'DejaVu Sans');


% Get the **unique colors** used in cmap
[uniqueColors, ~, ic] = unique(cmap, 'rows', 'stable');

% Create dummy scatter plots for the legend
hold on;
h = gobjects(size(uniqueColors,1),1);
for i = 1:size(uniqueColors,1)
    h(i) = scatter(NaN, NaN, 200, uniqueColors(i,:), 'filled'); 
end

violins = violinplot(A, groups,  ...   % violin fill (you already make transparent)
    'MarkerSize', 80, ...          % dot size
    'ViolinAlpha', 0.0, ...        % transparent violin
    'EdgeColor', [0,0,0], ...      % black outline
    'ShowMedian', false, ...        % we want median visible
    'ShowBox', true, ...           % box outline
    'ShowWhiskers', true);         % turn whiskers (tails) on

for v = 1:numel(violins)
    % Thicker outline of violin shape
    violins(v).ViolinPlot.LineWidth = 2;

    % Median/box line (patch object in this implementation)
    if ~isempty(violins(v).BoxPlot)
        violins(v).BoxPlot.EdgeColor = [0 0 0]; % black outline
        violins(v).BoxPlot.FaceColor = [1 1 1]; % white fill so violin is visible behind
        violins(v).BoxPlot.LineWidth = 2;
    end

    % Whiskers (tails)
    if ~isempty(violins(v).WhiskerPlot)
        for w = 1:numel(violins(v).WhiskerPlot)
            violins(v).WhiskerPlot(w).LineWidth = 2;
            violins(v).WhiskerPlot(w).Color = [0 0 0]; % black tails
        end
    end
end

% --- Recolor points inside each violin ---
counter = 0;
for v = 1:numel(violins)
    nPoints = numel(violins(v).ScatterPlot.XData);
    violins(v).ScatterPlot.CData = cmap(counter+1:counter+nPoints, :);
    violins(v).ScatterPlot.MarkerFaceColor = 'flat';  % per-point colors
    counter = counter + nPoints;
end
xticks([1 2 3]);        
xticklabels({'5 Hz', '10Hz', '20 Hz'});

xlim([0.5 3.5])
ylabel('Correlation')
ylim([-1 0.5])

saveas(f, 'supplementaryN.svg')
%%
kruskalwallis(A, groups, 'on')
