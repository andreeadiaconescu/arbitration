function wagad_main

%% Performs all analysis steps at the single-subject and group level
% Important: you need to have access to the raw data; the path should be specified
% analysis options are defined in get_paths_wagad;

%% Subjects entering the analysis
iSubjectArray     = setdiff([3:47], [14 25 31 32 33 34 37]);
iSubjectArrayfMRI = setdiff([3:47], [6 14 25 31 32 33 34 37]);

% Subject WAGAD_0006 had no phys logs recorded

%% Model-Based Analysis
typeDesign                   = 'ModelBased';
firstLevelAnalysisStrategy   = [0 1 1 1 1 1];
secondLevelAnalysisStrategy  = [1 1 1 1 1 1 1];

% First-level analysis
fprintf('\n===\n\t Running the first level analysis:\n\n');
wagad_first_level_analysis(firstLevelAnalysisStrategy,iSubjectArray,iSubjectArrayfMRI,typeDesign);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
wagad_second_level_analysis(secondLevelAnalysisStrategy,iSubjectArrayfMRI,typeDesign);

fprintf('\n===\n\t Done model-based analysis!\n\n');


%% Model-Free Analysis (Note: some steps may be skipped as they are not needed for the factorial analysis)
typeDesign                   = 'ModelFree';
firstLevelAnalysisStrategy   = [0 0 0 0 0 0];
secondLevelAnalysisStrategy  = [0 0 0 0 0 1 0];

% First-level analysis
fprintf('\n===\n\t Running the first level analysis:\n\n');
wagad_first_level_analysis(firstLevelAnalysisStrategy,iSubjectArray,iSubjectArrayfMRI,typeDesign);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
wagad_second_level_analysis(secondLevelAnalysisStrategy,iSubjectArrayfMRI,typeDesign);

fprintf('\n===\n\t Done model-free analysis!\n\n');


%% ROI Extraction and plotting
fprintf('\n===\n\t Running ROI peri-stimulus time series plotting per subject (mean over trials) and group (mean over subjects):\n\n');
wagad_plot_group_roi_timeseries(iSubjectArrayfMRI);

fprintf('\n===\n\t Done ROI extraction and plotting of group effects!\n\n');

end