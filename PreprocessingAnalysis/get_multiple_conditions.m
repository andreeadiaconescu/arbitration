function get_multiple_conditions(iSubjectArray, doPlotFigures)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
end

if nargin < 2
    doPlotFigures = 1;
end

typeDesign = 'ModelFree';

for iSubj = iSubjectArray
    %% Load Model and inputs
    paths = get_paths_wagad(iSubj,1,2);
    
    if ismac
        doFitModel = true;
    else
        doFitModel = false;
    end
    
    
    addpath(paths.code.model);
    
    input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?
    
    
    y = [];
    
    %% Load Onsets
    % construct output matrix from behavioral log files:
    % outputmatrix=[onsets1 onsets2 onsets3 choice onsets_resp RS' inmatrix(:,17)];
    
    outputmatrix = [];
    for iRun = 1:2
        
        % try whether run 1 and 2 (male adviser) exist
        fileBehav = fullfile(paths.behav, ...
            sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun));
        if ~exist(fileBehav)
            % we use run 5+6 (female adviser)
            fileBehav = fullfile(paths.behav, ...
                sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun+4));
        end
        load(fileBehav);
        
        trigger = SOC.param(2).scanstart;
        
        fileTrigger = fullfile(paths.behav, sprintf('scanner_trigger_%d.txt', iRun));
        save(fileTrigger,'trigger','-ascii','-tabs');
        
        % later runs are offset by duration of previous runs for
        % concatentation
        offsetRunSeconds = 0 + ...
            sum(paths.scanInfo.TR(1:iRun-1).*paths.scanInfo.nVols(1:iRun-1));
        
        outputmatrixSession{iRun} = apply_trigger(fileTrigger, ...
            SOC.Session(2).exp_data, offsetRunSeconds);
        choice  = outputmatrixSession{iRun}(:,4);
        wager   = outputmatrixSession{iRun}(:,7);
        y       = [y; choice wager];
        outputmatrix = [outputmatrix; outputmatrixSession{iRun}];
    end
    save(paths.fnBehavMatrix,'outputmatrix','-mat');
    
    %% Run Inversion
    for iRsp=1
        if doFitModel
            if iRsp==2
                est=fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
                    'hgf_ioio_precision_weight_new_config');
            else
                est=fitModel(y,input_u);
            end
            save(paths.fnFittedModel{iRsp}, 'est');
        else
            load(paths.fnFittedModel{iRsp},'est','-mat');
        end
        %% Create Parametric Modulators / Define Conditions
        if strcmp(typeDesign,'ModelBased')==1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % First: Arbitration (Precision Ratio),
            % Advice Prediction (Mu1hat_A), Reward Prediction (Mu1hat_R)
            % Time-Locked to Prediction Phase
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pmod(1,1).name = {'Arbitration','Prediction_Advice','Prediction_Reward'};
            x_a=sgm(est.traj.muhat_a(:,2), 1);
            x_r=sgm(est.traj.muhat_r(:,2), 1);
            sa2hat_a=est.traj.sahat_a(:,2);
            sa2hat_r=est.traj.sahat_r(:,2);
            px = 1./(x_a.*(1-x_a));
            pc = 1./(x_r.*(1-x_r));
            ze1=est.p_obs.ze1;
            pi_r = pc +1./sa2hat_r;
            pi_a = px +1./sa2hat_a;
            wx   = ze1.*pi_a./(ze1.*pi_a + pi_r);
            wc   = pi_r./(ze1.*pi_a + pi_r);
            Arbitration = wx;
            pmod(1,1).param = {[Arbitration],[x_a],[x_r]}; % Precision (Model-based wager)
            pmod(1,1).poly={[1],[1],[1]};
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Second: Wager (Belief Precision), Belief
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pmod(1,2).name = {'Wager','IntegratedBelief'}; % Belief Precision
            % Belief vector
            b = wx.*x_a + wc.*x_r;
            pib = 1./(b.*(1-b));
            pmod(1,2).param = {[pib],[b]}; % Precision (Model-based wager)
            pmod(1,2).poly={[1],[1]};
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Third: Social and Reward PEs
            % Social and Reward Volatility PEs
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pmod(1,3).name = {'Delta1_Adv','Delta1_Cue','Delta2_Adv','Delta2_Cue'}; % PEs
            Delta1.Advice       = est.traj.da_a(:,1);
            Delta1.Reward       = abs(est.traj.da_r(:,1));
            Delta2.Advice       = est.traj.da_a(:,2);
            Delta2.Reward       = est.traj.da_r(:,2);
            pmod(1,3).param = {[Delta1.Advice],[Delta1.Reward],[Delta2.Advice],[Delta2.Reward]};
            pmod(1,3).poly={[1], [1],[1], [1]};
            %% Plot
            if doPlotFigures
                hgf_plotTraj_reward_social(est);
                figure;
                % Subplots
                subplot(4,1,1);
                plot(pmod(1,1).param{1}, 'm', 'LineWidth', 4);
                hold on;
                plot(ones(170,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(4,1,2);
                plot(pmod(1,2).param{1} , 'r', 'LineWidth', 4);
                hold on;
                plot(ones(170,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(4,1,3);
                plot(pmod(1,3).param{1}, 'c', 'LineWidth', 4);
                hold on;
                plot(ones(170,1).*2.5,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(4,1,4);
                plot(pmod(1,3).param{2}, 'b', 'LineWidth', 4);
                hold on;
                plot(ones(170,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                xlabel('Trial number');
                subplot(4,1,1);
                hold on;
                title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                    num2str(est.p_obs.ze1), ...
                    ' for subject ', paths.idSubjBehav], ...
                    'FontWeight', 'bold');
            end
            onsets{1} = outputmatrix(:,1);
            onsets{2} = outputmatrix(:,2);
            onsets{3} = outputmatrix(:,3);
            names={'Advice','Wager','Outcome'};
            
            durationsAdvice = [outputmatrix(:,5)-outputmatrix(:,1)];
            durationsWager = 0;
            
            hasInvalidDurations = any(isnan(durationsAdvice));
            
            if hasInvalidDurations
                durations{1} = 2;
            else
                durations{1} = durationsAdvice;
            end
            durations{2} = durationsWager;
            durations{3} = 0;
            save(paths.fnMultipleConditions, 'onsets', 'names', 'durations', 'names', 'pmod', '-mat');
            
        elseif strcmp(typeDesign,'ModelFree')==1
            AdviceCodingUnstable=[zeros(25,1)' zeros(15,1)' ones(30,1)' zeros(25,1)' ones(25,1)' zeros(15,1)' ones(25,1)'];
            RewardCodingUnstable=[zeros(25,1)' ones(15,1)' ones(30,1)' ones(25,1)' zeros(25,1)' zeros(15,1)' zeros(25,1)'];
            AdviceCodingStable = (1-AdviceCodingUnstable')';
            RewardCodingStable = (1-RewardCodingUnstable')';
            namesPrediction={'RewardStable','RewardUnstable','AdviceStable','AdviceUnstable'};
            onsetsPrediction{1} = outputmatrix(RewardCodingStable==1,1);
            onsetsPrediction{2} = outputmatrix(RewardCodingUnstable==1,1);
            onsetsPrediction{3} = outputmatrix(AdviceCodingStable==1,1);
            onsetsPrediction{4} = outputmatrix(AdviceCodingUnstable==1,1);
            durationsPrediction{1} = 2;
            durationsPrediction{2} = 2;
            durationsPrediction{3} = 2;
            durationsPrediction{4} = 2;
            save(paths.fnModelFreePredictionConditions, 'onsetsPrediction', 'namesPrediction', 'durationsPrediction', '-mat');
            
            namesWager={'RewardStable','RewardUnstable','AdviceStable','AdviceUnstable'};
            onsetsWager{1} = outputmatrix(RewardCodingStable==1,2);
            onsetsWager{2} = outputmatrix(RewardCodingUnstable==1,2);
            onsetsWager{3} = outputmatrix(AdviceCodingStable==1,2);
            onsetsWager{4} = outputmatrix(AdviceCodingUnstable==1,2);
            durationsWager{1} = 0;
            durationsWager{2} = 0;
            durationsWager{3} = 0;
            durationsWager{4} = 0;
            save(paths.fnModelFreeWagerConditions, 'onsetsWager', 'namesWager', 'durationsWager', '-mat');
        end
    end
end