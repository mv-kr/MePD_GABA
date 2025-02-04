clc; clearvars; close all;

% load data
data = readtable('P-values.csv', 'TextType', 'string');

% extract relevant columns
Xcorr = log10(data.Xcorr); % Apply log base 10 transformation
Animal = data.Animal;
Intervention = data.Intervention;

% sort animals by numeric part
numericPart = cellfun(@(x) str2double(x(2:end)), Animal);
[~, sortedIndices] = sort(numericPart, 'ascend');
sortedAnimals = Animal(sortedIndices);
[uniqueAnimals, ~] = unique(sortedAnimals, 'stable');
uniqueInterventions = unique(Intervention);

% initialize figure
f = figure(1); hold on;
set(f, 'Units', 'pixels', 'Position', [100, 100, 1200, 300]);
set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');

% define colors for each animal
colors = [0 0 1; 1 0 0; 0 0.502 0; 1 0.647 0; 0.502 0 0.502; 0.647 0.1647 0.1647];

% loop through each intervention
for i = 1:numel(uniqueInterventions)
    interventionType = uniqueInterventions(i);
    subplot(1, numel(uniqueInterventions)+1, 1+(i-1)*2);
    hold on; box on;
    
    % filter data for current intervention
    idx = Intervention == interventionType;
    XcorrSubset = Xcorr(idx);
    AnimalSubset = Animal(idx);
    
    % plot scatter points
    for j = 1:numel(uniqueAnimals)
        animal = uniqueAnimals(j);
        animalIdx = AnimalSubset == animal;
        
        if animal == "G29" && i == 1
            scatter([5, 4.8, 5.2], XcorrSubset(animalIdx), 100, 'MarkerFaceColor', colors(j, :), 'MarkerEdgeColor', colors(j, :), 'DisplayName', animal);
        elseif animal == "G37" && i == 1
            scatter([5.6, 6, 6.4, 6], XcorrSubset(animalIdx), 100, 'MarkerFaceColor', colors(j, :), 'MarkerEdgeColor', colors(j, :), 'DisplayName', animal);
        else
            scatter(repmat(j, sum(animalIdx), 1), XcorrSubset(animalIdx), 100, 'MarkerFaceColor', colors(j, :), 'MarkerEdgeColor', colors(j, :), 'DisplayName', animal);
        end
    end
    
    % add reference line for significance threshold
    plot([0 7], [log10(0.05), log10(0.05)], 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'LineStyle', '--');
    
    % customize subplot
    subtitle(interventionType, 'FontSize', 18);
    xticks(1:numel(uniqueAnimals));
    xticklabels('');
    ylim([min(Xcorr) - 5, max(Xcorr) + 1]);
    xlim([0.5 6.7]);
    set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');
    
    if i == 1
        ylabel('log_{10}(p-value)', 'FontSize', 18);
        ylim([-42, max(Xcorr) + 1]);
    end
end

% process stimulation data for Fisher's method
stimulationData = data(strcmp(data.Intervention, 'Stimulation'), :);
uniqueAnimals = unique(stimulationData.Animal);
animalPValues = cell(numel(uniqueAnimals), 1);

for i = 1:numel(uniqueAnimals)
    animalPValues{i} = stimulationData.Xcorr(strcmp(stimulationData.Animal, uniqueAnimals{i}));
end

% generate all combinations of p-values
[permComb] = allcombs(animalPValues);
chi_square_stat = -2 * sum(log(permComb), 2);
combined_pvalues = chi2cdf(chi_square_stat, 2 * numel(permComb(1, :)), 'upper');

% plot histogram of combined p-values
subplot(1, 3, 2);
set(gca, 'FontSize', 18, 'FontName', 'DejaVu Sans');
hold on; box on;
histogram(log10(combined_pvalues), 15, 'Orientation', 'horizontal', 'FaceColor', 'b');
yline(log10(0.05), 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'LineStyle', '--');
xticks([]);

% save figure
% saveas(f, 'f1.svg', 'svg');

% function to generate all possible combinations of p-values for Fisher's method
function [allCombinations] = allcombs(pValueCell)
    numAnimals = numel(pValueCell);
    indices = cellfun(@(x) 1:numel(x), pValueCell, 'UniformOutput', false);
    [gridIndices{1:numAnimals}] = ndgrid(indices{:});
    gridIndices = cellfun(@(x) x(:), gridIndices, 'UniformOutput', false);
    allCombinations = zeros(numel(gridIndices{1}), numAnimals);
    for i = 1:numAnimals
        allCombinations(:, i) = pValueCell{i}(gridIndices{i});
    end
end
