function plot_parametric_modulators(iSubjectArray,doPlotFigures)
if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
end

if nargin < 2
    doPlotFigures = 1;
end


typeDesign = 'ModelBased';
errorSubjects = {};
errorIds = {};
for iSubj = iSubjectArray
    %% Load Model and inputs
    iD = iSubj;
    % try % continuation with new subjects, if error
    idDesign = 13;
    paths = get_paths_wagad(iSubj,1,idDesign);
    load(paths.fnMultipleConditions); % Select the winning model only
    figure;
    
    % Subplots
    subplot(12,1,1);
    plot(pmod(1,1).param{1}, 'm', 'LineWidth', 4);
    ylabel(pmod(1,1).name{1});
    
    subplot(12,1,2);
    plot(pmod(1,1).param{2} , 'r', 'LineWidth', 4);
    ylabel(pmod(1,1).name{2});
    
    subplot(12,1,3);
    plot(pmod(1,1).param{3}, 'c', 'LineWidth', 4);
    ylabel(pmod(1,1).name{3});
    
    subplot(12,1,4);
    plot(pmod(1,1).param{4}, 'b', 'LineWidth', 4);
    ylabel(pmod(1,1).name{4});
    
    subplot(12,1,5);
    plot(pmod(1,1).param{5}, 'b', 'LineWidth', 4);
    ylabel(pmod(1,1).name{5});
    
    subplot(12,1,6);
    plot(pmod(1,2).param{1}, 'm', 'LineWidth', 4);
    ylabel(pmod(1,2).name{1});
    
    subplot(12,1,7);
    plot(pmod(1,2).param{2}, 'm', 'LineWidth', 4);
    ylabel(pmod(1,2).name{2});
    
    subplot(12,1,8);
    plot(pmod(1,2).param{3}, 'm', 'LineWidth', 4);
    ylabel(pmod(1,2).name{3});
    
    subplot(12,1,9);
    plot(pmod(1,3).param{1} , 'r', 'LineWidth', 4);
    ylabel(pmod(1,3).name{1});
    
    subplot(12,1,10);
    plot(pmod(1,3).param{2}, 'c', 'LineWidth', 4);
    ylabel(pmod(1,3).name{2});
    
    subplot(12,1,11);
    plot(pmod(1,3).param{3}, 'k', 'LineWidth', 4);
    ylabel(pmod(1,3).name{3});
    
    subplot(12,1,12);
    plot(pmod(1,3).param{4}, 'b', 'LineWidth', 4);
    ylabel(pmod(1,3).name{4});
    hold on;
    xlabel('Trial number');
    subplot(12,1,1);
end