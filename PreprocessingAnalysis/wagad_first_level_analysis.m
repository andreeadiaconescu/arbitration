function wagad_first_level_analysis(iSubjectArray,typeDesign)
%Performs all analysis steps for one subject of the DMPAD study (up until
% first level modelbased statistics)
%   IN:     id          subject identifier string, e.g. '151'
%           options     as set by dmpad_set_analysis_options();

fprintf('\n===\n\t The following pipeline Steps per subject were selected. Please double-check:\n\n');
Analysis_Strategy = [0 1 1 1 1 1]; 
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

doPreprocessing             = Analysis_Strategy(1);
doExtractBehaviouralData    = Analysis_Strategy(2);
doInversion                 = Analysis_Strategy(3);
doCreateRegressors          = Analysis_Strategy(4);
doFirstLevelStats           = Analysis_Strategy(5);
doFirstLevelContrasts       = Analysis_Strategy(6);

% Deletes previous preproc/stats files of analysis specified in options
if doPreprocessing
    main_run_preprocessing;
end

if doExtractBehaviouralData
    get_behaviour_data(iSubjectArray);
end

if doInversion
   get_model_inversion(iSubjectArray,idDesign);    
end

if doCreateRegressors
    get_multiple_conditions_1stlevel(iSubjectArray,typeDesign,idDesign);
end

iSubjectArrayfMRI = setdiff([3:47], [6 14 25 31 32 33 34 37]);

if doFirstLevelStats
    main_run_stats_glm_single_subject(iSubjectArrayfMRI,idDesign)
end

if doFirstLevelContrasts
    main_run_stats_report_contrasts_single_subject(iSubjectArrayfMRI,idDesign)
end


