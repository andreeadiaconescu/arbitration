function wagad_second_level_analysis(secondLevelAnalysisStrategy,iSubjectArray,iSubjectArrayfMRI,...
    typeDesign)
% Performs all group analysis steps for the WAGAD study

if nargin < 1
    secondLevelAnalysisStrategy =  [0 1 0 1 0 1 0 0 0];
end

if nargin < 2
    iSubjectArray =  setdiff([3:47], [14 25 31 32 33 34 37]); % 6 only excluded from neuroimaging analysis because of lack of physlog
end

if nargin < 3
    iSubjectArrayfMRI =  setdiff([3:47], [6 14 25 31 32 33 34 37]);
end

if nargin < 4
    typeDesign = 'ModelBased';
end

fprintf('\n===\n\t The following pipeline Steps per subject were selected. Please double-check:\n\n');
Analysis_Strategy = secondLevelAnalysisStrategy;
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

doModelComparison                 = Analysis_Strategy(1);
doSecondLevelBehav                = Analysis_Strategy(2);
doCompareWagers                   = Analysis_Strategy(3);
doCalculateBetas                  = Analysis_Strategy(4);
doCalculateMAPS                   = Analysis_Strategy(5);
doSecondLevelStats                = Analysis_Strategy(6);
doCreateFiguresSupplementary      = Analysis_Strategy(7);
doExtractRoiTimeSeries            = Analysis_Strategy(8);
doRevision                        = Analysis_Strategy(9);

switch typeDesign
    case 'ModelBased'
        idDesign = 2;
    case 'ModelFree'
        idDesign = 1;
    case 'ModelBasedwithDifference'
        idDesign = 3;
end


% Set axes properties
set(0,'defaultAxesFontName','Constantia');
set(0,'defaultAxesFontSize',20);

% Deletes previous preproc/stats files of analysis specified in options

if doModelComparison
    get_model_comparison(iSubjectArray);
end

if doSecondLevelBehav
    get_covariates(iSubjectArrayfMRI);
end

if doCompareWagers
    get_compare_wagers(iSubjectArray);
end

if doCalculateBetas
    get_calculate_betas(iSubjectArrayfMRI);
end

if doCalculateMAPS
    wagad_extract_parameters_create_table(iSubjectArray);
end



if doSecondLevelStats
    includeRegressor = true;
    switch typeDesign
        case {'ModelBased','ModelBasedwithDifference'}
            regressorsGLM = {'arbitration','social_weighting','card_weighting','precision_advice','precision_card',...
                'belief_precision', 'surprise','wager_magnitude','advice_epsilon2','reward_epsilon2','advice_epsilon3',...
                'reward_epsilon3'};
            
            if includeRegressor == true
                responseModelParameters = {'be_surp','zeta'};
                for iRegressor = 1:numel(regressorsGLM)
                    for iParameter = 1:numel(responseModelParameters)
                        main_2ndlevel_job(idDesign,iSubjectArrayfMRI,regressorsGLM{iRegressor},responseModelParameters{iParameter})
                    end
                end
            else
                for iRegressor = 1:numel(regressorsGLM)
                    main_2ndlevel_simple(idDesign,iSubjectArrayfMRI,regressorsGLM{iRegressor})
                end
            end
            
        case 'ModelFree'
            regressorsGLM = {'interaction_advice','interaction_reward','volatility>stability'};
            for iRegressor = 1:numel(regressorsGLM)
                main_2ndlevel_simple(idDesign,iSubjectArrayfMRI,regressorsGLM{iRegressor});
            end
    end
end

if doCreateFiguresSupplementary
    wagad_extract_plot_MAPs(iSubjectArray,'accuracy');
    wagad_extract_plot_MAPs(iSubjectArray,'advice');
    wagad_extract_plot_MAPs(iSubjectArray,'wager');
    wagad_plot_computational_quantities(iSubjectArray);
    wagad_plot_wager_computational_quantities(iSubjectArray);
    wagad_analyze_probe(iSubjectArray);
end

if doRevision
    wagad_extract_plot_MAPs(iSubjectArray,'probe');
    get_check_correlations_regressors(iSubjectArray);
    [variables_all] = wagad_simulate_from_empiricalData(iSubjectArray);
    wagad_check_debriefing(iSubjectArray);
end

if doExtractRoiTimeSeries
    fprintf('\n===\n\t Running subject-wise ROI extraction for significant group clusters:\n\n');
    wagad_extract_roi_timeseries_by_arbitration(iSubjectArrayfMRI);
end

end
