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

for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj,1,2);
    
    if ismac
        doFitModel = true;
    else
        doFitModel = false;
    end
    
    
    
    addpath(paths.code.model);
    
    input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?
    
    
    y = [];
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
        choice = outputmatrixSession{iRun}(:,4);
        wager = outputmatrixSession{iRun}(:,7);
        y = [y; choice wager];
        outputmatrix = [outputmatrix; outputmatrixSession{iRun}];
    end
    save(paths.fnBehavMatrix,'outputmatrix','-mat');
    
    %% Run Inversion
    for iRsp=1
        %%
        
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
        %% Arbitration
         pmod(1,1).name = {'Arbitration','StableA_UnstableR','StableA_StableR','UnstableA_StableR','UnstableA_UnstableR'}; % Arbitration
        x_a=sgm(est.traj.muhat_a(:,2), 1);
        x_r=sgm(est.traj.muhat_r(:,2), 1);
        
        sa2hat_a=est.traj.sahat_a(:,2);
        sa2hat_r=est.traj.sahat_r(:,2);
        
         % Arbitration
        px = 1./(x_a.*(1-x_a));
        pc = 1./(x_r.*(1-x_r));
        ze1=est.p_obs.ze1;
        Arbitration = [1./sa2hat_a.*px./...
            (px.*1./sa2hat_a + pc.*1./sa2hat_r)];
        
        AdviceCodingUnstable=[zeros(25,1)' zeros(15,1)' ones(30,1)' zeros(25,1)' ones(25,1)' zeros(15,1)' ones(25,1)'];
        RewardCodingUnstable=[zeros(25,1)' ones(15,1)' ones(30,1)' ones(25,1)' zeros(25,1)' zeros(15,1)' zeros(25,1)'];
        AdviceCodingStable = (1-AdviceCodingUnstable')';
        RewardCodingStable = (1-RewardCodingUnstable')';
        % Model-free Arbitration
        StableA_UnstableR = AdviceCodingStable.*RewardCodingUnstable; 
        StableA_StableR = AdviceCodingStable.*RewardCodingStable; 
        UnstableA_StableR =AdviceCodingUnstable.*RewardCodingStable;
        UnstableA_UnstableR = AdviceCodingUnstable.*RewardCodingUnstable; 
       
        pmod(1,1).param = {[Arbitration],[StableA_UnstableR],[StableA_StableR],[UnstableA_StableR],[UnstableA_UnstableR]}; % Precision (Model-based wager)
        pmod(1,1).poly={[1],[1],[1],[1],[1]};
        
        
        %% Wager %add 2 parametric modulator - coding files in terms of advice volatility and coding files in term of 

        pmod(1,2).name = {'Wager','StableA_UnstableR','StableA_StableR','UnstableA_StableR','UnstableA_UnstableR'}; % Arbitration
        wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
       
        
        % Belief vector
        b = wx.*x_a + wc.*x_r;
        
        pib = 1./(b.*(1-b));
        pmod(1,2).param = {[pib],[StableA_UnstableR],[StableA_StableR],[UnstableA_StableR],[UnstableA_UnstableR]}; % Precision (Model-based wager)
        pmod(1,2).poly={[1],[1],[1],[1],[1]};
       
        %% Prediction Errors
        pmod(1,3).name = {'Delta1_Adv','Delta1_Cue'}; % PEs
        
        Delta1.Advice       = est.traj.da_a(:,1);
        Delta1.Reward       = abs(est.traj.da_r(:,1));
        
        pmod(1,3).param = {[Delta1.Advice],[Delta1.Reward]}; % Precision (Model-based wager)
        pmod(1,3).poly={[1], [1]};
        
        %% Plot
        
        if doPlotFigures
            
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
            title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                num2str(est.p_obs.ze1), ...
                ' for subject ', paths.idSubjBehav], ...
                'FontWeight', 'bold');
        end
        
        
        onsets{1} = outputmatrix(:,1);
        onsets{2} = outputmatrix(:,2);
        onsets{3} = outputmatrix(:,3);
        names={'Advice','Wager','Outcome'};
        
        durationsAdvice = [outputmatrix(:,5)-outputmatrix(:,2)];
        durationsWager = 0;
        
        hasInvalidDurations = any(isnan(durationsAdvice));
        
        if hasInvalidDurations
            durations{1} = 0;
        end
        
        durations{2} = durationsWager;
        durations{3} = 0;
        
        
        save(paths.fnMultipleConditions, 'onsets', 'names', 'durations', 'names', 'pmod', '-mat');
    end
end

end