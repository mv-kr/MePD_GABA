clc; clearvars; close all; 
T = readmatrix('newdata.xlsx','Sheet', 8);
ConFoffon_before = T(1,2:7);
ConFoffon_after = T(1,10:end);

nostim_before = T(2,2:6);
nostim_after = T(2,10:14);

% Group data into a matrix: rows = groups, columns = subjects
data = {
    ConFoffon_before, ConFoffon_after;
    nostim_before,  nostim_after
};

ngroups = size(data,1);
nbars   = size(data,2);

% Compute means and SEMs
means = cellfun(@mean, data);
sems  = cellfun(@(x) std(x)/sqrt(numel(x)), data);

% Create grouped bar plot
f = figure(1); clf
f.Units = "centimeters";
f.Position = [5 5 12.3 11.7];
hold on; box on; grid off;
set(gca, 'FontSize', 20, 'fontname', 'DejaVu Sans');

hb = bar(means, 'grouped');

% Keep bars white inside
hb(1).FaceColor = 'w';
hb(2).FaceColor = 'w';

% Set edge colors for each bar
edge_col1 = [0 0 0; 0 0 0];          % black for 1st, 3rd, 5th
edge_col2 = [0 0 1; 0.5 0.5 0.5]; % blue, grey, orange

for g = 1:ngroups
    hb(1).EdgeColor = 'flat';
    hb(1).CData(g,:) = edge_col1(g,:); % border colors for col1
    hb(2).EdgeColor = 'flat';
    hb(2).CData(g,:) = edge_col2(g,:); % border colors for col2
end

% Make outlines thicker
hb(1).LineWidth = 3;
hb(2).LineWidth = 3;


% Add error bars with matching colors
groupwidth = min(0.8, nbars/(nbars+1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    if i == 1
        for g = 1:ngroups
            errorbar(x(g), means(g,i), sems(g,i), 'Color', edge_col1(g,:), ...
                'linestyle', 'none', 'LineWidth', 2);
        end
    else
        for g = 1:ngroups
            errorbar(x(g), means(g,i), sems(g,i), 'Color', edge_col2(g,:), ...
                'linestyle', 'none', 'LineWidth', 2);
        end
    end
end

jitterAmount = 0.09; % match your previous jitter

for i = 1:ngroups
    % Base x positions for the two bars
    x1_base = i - groupwidth/2 + (2*1-1)*groupwidth/(2*nbars); % red
    x2_base = i - groupwidth/2 + (2*2-1)*groupwidth/(2*nbars); % green

    y1 = data{i,1}; % before (red)
    y2 = data{i,2}; % after (green)

    % Generate the same random jitter for both red and green points in a pair
    jitterVals1 = (rand(size(y1))-0.5) * 2 * jitterAmount;
    jitterVals2 = (rand(size(y2))-0.5) * 2 * jitterAmount;

    % Plot grey connecting lines (with jitter applied)
    for k = 1:numel(y1)
        plot([x1_base + jitterVals1(k), x2_base + jitterVals2(k)], ...
             [y1(k), y2(k)], 'Color', 'k', 'LineWidth', 1);
    end

    % Scatter red points
    scatter(x1_base + jitterVals1, y1, 80, [1 0 0], 'filled');

    % Scatter green points
    scatter(x2_base + jitterVals2, y2, 80, [0 0.6 0], 'filled');
end


ax = gca;
ax.XTick = 1:ngroups;                     % exactly 1 and 2
ax.XTickLabel = {'', ''};
ylabel('LH IPI [min]');
yticks([0 10 20 30]);
yticklabels({'0', '10', '20', '30'});
ylim([0 45])
box off;
saveas(f, 'fig6J.svg')