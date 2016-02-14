function get_multiple_conditions_madeline(iSubjectArray, doPlotFigures)
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
        
        
        
        outputmatrixSession{iRun} = apply_trigger(fileTrigger, ...
            SOC.Session(2).exp_data);
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
        %% Arbitration %add another parametric modulator 
        %CODE: 0=stable, 1=volatile - add to arbitration - modulate
        %response to presentation of the advice 
        %pmod(2,1).name = {'Advice_phases'}
        %pmod(3,1).name = {'Reward_phases'
        
        pmod(1,1).name = {'Arbitration'}; % Arbitration
        x_a=sgm(est.traj.mu_a(:,2), 1);
        x_r=sgm(est.traj.mu_r(:,2), 1);
        
        sa2hat_a=est.traj.sa_a(:,2);
        sa2hat_r=est.traj.sa_r(:,2);
        
        pmod(2,1).name={'StableA_UnstableR'}; %25-40; 71-95
        pmod(3,1).name={'StableA_StableR'};%1-25; 121-135
        pmod(4,1).name={'UnstableA_StableR'};%96-120; 136-160
        pmod(5,1).name={'UnstableA_UnstableR'};%41-70
         % Arbitration
        px = 1./(x_a.*(1-x_a));
        pc = 1./(x_r.*(1-x_r));
        ze1=est.p_obs.ze1;
        pmod(1,1).param = {[ze1.*1./sa2hat_a.*px./...
            (ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r)]};
        pmod(2,1).param = load(fullfile(paths.code.model, 'StableA_UnstableR.txt')); 
        pmod(3,1).param = load(fullfile(paths.code.model, 'StableA_StableR.txt')); 
        pmod(4,1).param = load(fullfile(paths.code.model, 'UnstableA_StableR.txt'));
        pmod(5,1).param = load(fullfile(paths.code.model, 'UnstableA_UnstableR.txt')); 
       
        pmod(1,1).poly={[1]};
        pmod(2,1).poly={[1]};
        pmod(3,1).poly={[1]};
        pmod(4,1).poly={[1]};
        pmod(5,1).poly={[1]};
        
        %% Wager %add 2 parametric modulator - coding files in terms of advice volatility and coding files in term of 

        pmod(1,2).name = {'Wager'}; % Arbitration
        wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        
        pmod(2,2).name={'StableA_UnstableR'}; %26-40; 71-95
        pmod(3,2).name={'StableA_StableR'};%1-25; 121-135
        pmod(4,2).name={'UnstableA_StableR'};%96-120; 136-160
        pmod(5,2).name={'UnstableA_UnstableR'};%41-70
        
        % Belief vector
        b = wx.*x_a + wc.*x_r;
        
        pib = 1./(b.*(1-b));
        
        pmod(1,2).param = {[pib]}; % Precision (Model-based wager)
        pmod(1,2).poly={[1]};
        
        pmod(2,2).param = load(fullfile(paths.code.model, 'StableA_UnstableR.txt')); 
        pmod(3,2).param = load(fullfile(paths.code.model, 'StableA_StableR.txt')); 
        pmod(4,2).param = load(fullfile(paths.code.model, 'UnstableA_StableR.txt')); 
        pmod(5,2).param = load(fullfile(paths.code.model, 'UnstableA_UnstableR.txt')); 
       
        
        pmod(2,2).poly={[1]};
        pmod(3,2).poly={[1]};
        pmod(4,2).poly={[1]};
        pmod(5,2).poly={[1]};
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