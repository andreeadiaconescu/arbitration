function wagad_second_level_analysis(iSubjectArray,typeDesign)
%Performs all analysis steps for one subject of the DMPAD study (up until
% first level modelbased statistics)

fprintf('\n===\n\t The following pipeline Steps per subject were selected. Please double-check:\n\n');
Analysis_Strategy = [1 1 1 1 0];
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 31 32 33 34 37]);
end

if nargin < 2
    typeDesign = 'ModelBased';
end

switch typeDesign
    case 'ModelBased'
        idDesign = 2;
    case 'ModelFree'
        idDesign = 1;
end

doModelComparison       = Analysis_Strategy(1);
doSecondLevelBehav      = Analysis_Strategy(2);
doCompareWagers         = Analysis_Strategy(3);
doCalculateBetas        = Analysis_Strategy(4);
doSecondLevelStats      = Analysis_Strategy(5);

% Set axes properties
set(0,'defaultAxesFontName','Constantia');
set(0,'defaultAxesFontSize',20);

% Deletes previous preproc/stats files of analysis specified in options

if doModelComparison
    get_model_comparison(iSubjectArray);
end

if doSecondLevelBehav
    get_covariates(iSubjectArray);
end

if doCompareWagers
    get_compare_wagers(iSubjectArray);
end

if doCalculateBetas
    get_calculate_betas(iSubjectArray);
end

if doSecondLevelStats
    main_2ndlevel_job(idDesign,iSubjectArray);
end

