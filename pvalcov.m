clc; clearvars; close all; % clear workspace and close figures

data = readtable('P-values.csv', 'TextType', 'string'); % load data from csv file

% extract relevant columns
Cov = log10(data.Cov); % apply log base 10 to Cov values
Animal = data.Animal;
Intervention = data.Intervention;

% get unique animals and interventions
numericPart = cellfun(@(x) str2double(x(2:end)), Animal); % extract numeric part of animal IDs
[~, sortedIndices] = sort(numericPart, 'ascend'); % sort animals by numeric part
sortedAnimals = Animal(sortedIndices);
[uniqueAnimals, uniqueIndices] = unique(sortedAnimals, 'stable');
uniqueInterventions = unique(Intervention);

% initialize figure
f = figure(1); hold on; 
set(f, 'Units', 'pixels', 'Position', [100, 100, 1200, 300]); % set figure size and position
set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');

% define colors for each animal
colors = [0 0 1; % blue
          1 0 0; % red
          0 0.502 0; % green
          1 0.647 0; % orange
          0.502 0 0.502; % purple
          0.647 0.1647 0.1647]; % brown

% loop through each intervention
totalSubplots = numel(uniqueInterventions) + 1;
for i = 1:numel(uniqueInterventions)
    interventionType = uniqueInterventions(i);
    subplot(1, totalSubplots, 1 + (i - 1) * 2); hold on; box on;

    % filter data for this intervention
    idx = Intervention == interventionType;
    CovSubset = Cov(idx);
    AnimalSubset = Animal(idx);

    % scatter plot for each animal
    for j = 1:numel(uniqueAnimals)
        animal = uniqueAnimals(j);
        animalIdx = AnimalSubset == animal;
        
        % special cases for specific animals
        x_positions = repmat(j, sum(animalIdx), 1);
        if animal == "G29" && i == 1
            x_positions = [5, 4.8, 5.2];
        elseif animal == "G37" && i == 1
            x_positions = [5.6, 6, 6.4, 6];
        elseif animal == "G8" && i == 1
            x_positions = [2, 1.8, 2, 2.2];
        elseif animal == "G9" && i == 1
            x_positions = [3, 2.75, 3, 3.25];
        end
        
        scatter(x_positions, CovSubset(animalIdx), 100, ...
                'MarkerFaceColor', colors(j, :), 'MarkerEdgeColor', colors(j, :), ...
                'DisplayName', animal);
    end
    
    % add reference line at p = 0.05
    plot([0 7], [log10(0.05), log10(0.05)], 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'LineStyle', '--');
   
    % customize subplot
    subtitle(interventionType, 'FontSize', 18);
    xticks(1:numel(uniqueAnimals));
    xticklabels('');
    ylim([min(Cov) - 5, max(Cov) + 1]);
    xlim([0.5 6.7]);
    set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');
    
    if i == 1
        ylabel('log10(p-value)', 'FontSize', 18);
        ylim([-42, max(Cov) + 1]);
    end
end

% process stimulation data
stimulationData = data(strcmp(data.Intervention, 'Stimulation'), :);
uniqueAnimals = unique(stimulationData.Animal);
animalPValues = cell(numel(uniqueAnimals), 1);

% extract p-values per animal
for i = 1:numel(uniqueAnimals)
    animalPValues{i} = stimulationData.Cov(strcmp(stimulationData.Animal, uniqueAnimals{i}));
end

% generate all combinations of p-values
permComb = allcombs(animalPValues);

% compute Fisher's statistic for each combination
chi_square_stat = -2 * sum(log(permComb), 2);
combined_pvalues = chi2cdf(chi_square_stat, 2 * numel(animalPValues), 'upper');

% plot histogram of combined p-values
subplot(1, 3, 2); hold on; box on;
set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');
histogram(log10(combined_pvalues), 15, 'Orientation', 'horizontal', 'FaceColor', 'b');
yline(log10(0.05), 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'LineStyle', '--');
xticks([]);
xlim([0 250]);

% save figure
% saveas(f, 'f1.svg', 'svg');

% function to generate all possible combinations of p-values from each animal
% input: cell array where each cell contains a list of p-values for one animal
% output: matrix where each row represents one combination
function allCombinations = allcombs(pValueCell)
    numAnimals = numel(pValueCell); % number of animals considered
    indices = cellfun(@(x) 1:numel(x), pValueCell, 'UniformOutput', false);
    [gridIndices{1:numAnimals}] = ndgrid(indices{:});
    gridIndices = cellfun(@(x) x(:), gridIndices, 'UniformOutput', false);
    allCombinations = zeros(numel(gridIndices{1}), numAnimals);
    for i = 1:numAnimals
        allCombinations(:, i) = pValueCell{i}(gridIndices{i});
    end
end