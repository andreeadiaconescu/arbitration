function get_multiple_conditions_1stlevel(iSubjectArray, typeDesign,idDesign,...
    doPlotFigures)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
    
    % 6,7 = noisy; 9
end

if nargin < 2
    typeDesign = 'ModelBased';
end

if nargin < 3
    idDesign = 1;
end

if nargin < 4
    doPlotFigures = 0;
end

errorSubjects = {};
errorIds = {};
for iSubj = iSubjectArray
    %% Load Model and inputs
    iD = iSubj;
    % try % continuation with new subjects, if error
    paths = get_paths_wagad(iSubj,1,idDesign);
    addpath(paths.code.model);
    input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?
    
    %% Run Inversion
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    [predicted_wager] = calculate_predicted_wager(est,paths);
    hgf_plotTraj_reward_social(est,predicted_wager);
    first_trial      = [1 1];
    actual_responses = [first_trial; est.y];
    %% Create Parametric Modulators / Define Conditions
    if strcmp(typeDesign,'ModelBased')==1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % First: Arbitration (Precision Ratio),
        % Advice Prediction (Mu1hat_A), Reward Prediction (Mu1hat_R)
        % Time-Locked to Prediction Phase
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pmod(1,1).name = {'Arbitration','Social Weighting',...
            'Card Weighting','Precision_Advice','Precision_Card'};
        advice_card_space = input_u(:,3);
        ze1               = 1; % individual differences in zeta add further variability here; zeta used as a covariate
        % 1st level precision
        px       = 1./est.traj.sahat_a(:,1);
        pc       = 1./est.traj.sahat_r(:,1);
        wx       = ze1.*px./(ze1.*px + pc);
        wc       = pc./(ze1.*px + pc);
        mu1hat_r = est.traj.muhat_r(:,1);
        mu1hat_a = est.traj.muhat_a(:,1);
        transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);
        b        = wx.*mu1hat_a + wc.*transformed_mu1hat_r;
        
        Social_weighting = [0.5; wx.*mu1hat_a];
        Card_weighting   = [0.5; wc.*mu1hat_r];
        Arbitration      = [0.5; wc];
        
        pmod(1,1).param = {[Arbitration],[Social_weighting],[Card_weighting],[4;px],[4; pc]}; % Precision (Model-based wager)
        pmod(1,1).poly={[1],[1],[1],[1],[1]};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Second: Wager (Belief Precision), Belief
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pmod(1,2).name = {'BeliefPrecision','Belief','Surprise','Wager_Amount'}; % Belief Precision
        pib           = 1./(b.*(1-b));
        alpha         = -log2(b);
        pmod(1,2).param = {[4; pib],[0.5; b],[0.5; alpha],[actual_responses(:,2)]}; % Precision (Model-based wager)
        pmod(1,2).poly={[1],[1],[1],[1]};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Third: Social and Reward PEs
        % Social and Reward Volatility PEs
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pmod(1,3).name = {'Epsilon2 Adv','Epsilon2 Cue','Epsilon3_Adv','Epsilon3_Cue'}; % PEs
        Epsilon2.Advice       = est.traj.sa_a(:,2).*est.traj.da_a(:,1);
        Epsilon2.Reward       = abs(est.traj.sa_r(:,2).*est.traj.da_r(:,1));
        Epsilon3.Advice       = est.traj.sa_a(:,3).*est.traj.da_a(:,2);
        Epsilon3.Reward       = est.traj.sa_r(:,3).*est.traj.da_r(:,2);
        pmod(1,3).param = {[0; Epsilon2.Advice],[0; Epsilon2.Reward],[0; Epsilon3.Advice],[0; Epsilon3.Reward]};
        pmod(1,3).poly={[1], [1],[1], [1]};
        %% Plot
        PlotFigureA = 0;
        PlotFigureB = 0;
        main_plot_regressors(pmod,est,paths,doPlotFigures,PlotFigureA,PlotFigureB);
        load(paths.fnBehavMatrix,'outputmatrix','-mat');
        onsets{1} = outputmatrix(:,1);
        onsets{2} = outputmatrix(:,2);
        onsets{3} = outputmatrix(:,3);
        
        % Switch off orthogonalization for each condition separately
        orth{1} = 0;
        orth{2} = 0;
        orth{3} = 0;
        names={'Advice','Wager','Outcome'};
        
        
        durations{1} = 0;
        durations{2} = 0;
        durations{3} = 0;
        
        save(paths.fnMultipleConditions, 'onsets', 'names', 'durations', 'names', 'pmod', 'orth', '-mat');
        
    elseif strcmp(typeDesign,'ModelFree')==1
        AdviceCodingUnstable= logical(paths.design.volatileAdvicePhase);
        RewardCodingUnstable= logical(paths.design.volatileCardPhase);
        
        AdviceCodingStable = logical(paths.design.stableAdvicePhase);
        RewardCodingStable = logical(paths.design.stableCardPhase);
        
        names={'RewardStable','RewardUnstable','AdviceStable','AdviceUnstable'};
        onsets{1} = outputmatrix(RewardCodingStable==1,2);
        onsets{2} = outputmatrix(RewardCodingUnstable==1,2);
        onsets{3} = outputmatrix(AdviceCodingStable==1,2);
        onsets{4} = outputmatrix(AdviceCodingUnstable==1,2);
        durations{1} = 0;
        durations{2} = 0;
        durations{3} = 0;
        durations{4} = 0;
        save(paths.fnModelFreeWagerConditions, 'onsets', 'names', 'durations', '-mat');
    end
end
%     catch err
%         errorSubjects{end+1,1}.id = iD;
%         errorSubjects{end}.error = err;
%         errorIds{end+1} = iD;
%     end