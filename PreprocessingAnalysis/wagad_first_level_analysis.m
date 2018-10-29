function wagad_first_level_analysis(iSubjectArray,typeDesign)
%Performs all analysis steps for one subject of the DMPAD study (up until
% first level modelbased statistics)
%   IN:     id          subject identifier string, e.g. '151'
%           options     as set by dmpad_set_analysis_options();

fprintf('\n===\n\t The following pipeline Steps per subject were selected. Please double-check:\n\n');
Analysis_Strategy = [0 1 1 0];
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
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

doPreprocessing         = Analysis_Strategy(1);
doInversion             = Analysis_Strategy(2);
doCreateRegressors      = Analysis_Strategy(3);
doFirstLevelStats       = Analysis_Strategy(4);


% Deletes previous preproc/stats files of analysis specified in options
if doPreprocessing
    main_run_preprocessing;
end
if doInversion
   get_model_inversion(iSubjectArray,idDesign);    
end
if doCreateRegressors
    get_multiple_conditions_1stlevel(iSubjectArray,typeDesign,idDesign);
end

if doFirstLevelStats
    main_run_stats_report_contrasts_single_subject(iSubjectArray,idDesign)
end


