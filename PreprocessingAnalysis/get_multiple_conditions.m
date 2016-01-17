function get_multiple_conditions(iSubjectArray, doPlotFigures)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = 3;
end

if nargin < 2
    doPlotFigures = 1;
end

for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj);
    
    doFitModel = true;
    
    
    
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
            est=fitModel(y,input_u);
            save(paths.fnFittedModel{iRsp}, 'est');
        else
            load(paths.fnFittedModel{iRsp},'est','-mat');
        end
        %% Arbitration
        pmod(1,1).name = {'Arbitration'}; % Arbitration
        x_a=sgm(est.traj.mu_a(:,2), 1);
        x_r=sgm(est.traj.mu_r(:,2), 1);
        
        sa2hat_a=est.traj.sa_a(:,2);
        sa2hat_r=est.traj.sa_r(:,2);
        
        px = 1./(x_a.*(1-x_a));
        pc = 1./(x_r.*(1-x_r));
        ze1=est.p_obs.ze1;
        
        pmod(1,1).param = {[ze1.*1./sa2hat_a.*px./...
            (ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r)]};
        % Arbitration
        pmod(1,1).poly={[1]};
        
        %% Wager
        pmod(1,2).name = {'Wager'}; % Arbitration
        wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        
        % Belief vector
        b = wx.*x_a + wc.*x_r;
        
        pib = 1./(b.*(1-b));
        
        pmod(1,2).param = {[pib]}; % Precision (Model-based wager)
        pmod(1,2).poly={[1]};
        
        %% Prediction Errors
        pmod(1,3).name = {'Epsilon2_Adv','Epsilon2_Cue'}; % PEs
        
        Epsilon2.Advice       = est.traj.da_a(:,1).*est.traj.sa_a(:,2);
        Epsilon2.Reward       = abs(est.traj.da_r(:,1).*est.traj.sa_a(:,2));
        
        pmod(1,3).param = {[Epsilon2.Advice],[Epsilon2.Reward]}; % Precision (Model-based wager)
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
                num2str(log(est.p_obs.ze1)), ...
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