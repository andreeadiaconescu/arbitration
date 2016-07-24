function get_multiple_conditions_madeline_additive
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
subjects={'TNU_WAGAD_0003','TNU_WAGAD_0004','TNU_WAGAD_0005','TNU_WAGAD_0006','TNU_WAGAD_0007',...
    'TNU_WAGAD_0008','TNU_WAGAD_0009','TNU_WAGAD_0010','TNU_WAGAD_0011','TNU_WAGAD_0012',...
    'TNU_WAGAD_0013','TNU_WAGAD_0015','TNU_WAGAD_0016','TNU_WAGAD_0017','TNU_WAGAD_0018',...
    'TNU_WAGAD_0019','TNU_WAGAD_0020','TNU_WAGAD_0021','TNU_WAGAD_0022','TNU_WAGAD_0023',...
    'TNU_WAGAD_0026','TNU_WAGAD_0027','TNU_WAGAD_0028','TNU_WAGAD_0029','TNU_WAGAD_0030',...
    'TNU_WAGAD_0031','TNU_WAGAD_0035','TNU_WAGAD_0036','TNU_WAGAD_0038','TNU_WAGAD_0039',...
    'TNU_WAGAD_0040','TNU_WAGAD_0041','TNU_WAGAD_0042','TNU_WAGAD_0043','TNU_WAGAD_0044',...
    'TNU_WAGAD_0045','TNU_WAGAD_0046','TNU_WAGAD_0047'};
%if nargin < 1
%    iSubjectArray = setdiff([35:47], [14 25 32 33 34 37]);
%end

%if nargin < 2
%    doPlotFigures = 0;
%end
doPlotFigures=true;

for i=1:numel(subjects) % 15
    sub=subjects{i};
    sub1 = sub(end - 1:end);
    sub2 = str2num(sub1);
    %iSubj = iSubjectArray
    paths = get_paths_wagad(sub2,1,2);
    
    %if ismac
    %    doFitModel = true;
    %else
    %    doFitModel = false;
    %end
    doFitModel=false;
    
    dirBase = ('/Users/mstecy/Dropbox/MadelineMSc/DatafMRI/fMRI_data');
    modelpath='/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/WAGAD_Model/';
    addpath('/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/WAGAD_Model/');
    datapath = dirBase;
    rp_model= {'softmax_additiveprecision_reward_social_config'};
    prc_model= 'hgf_binary3l_reward_social_config';
    
    %addpath(paths.code.model);
    
    %input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?
    input_u = load(fullfile(modelpath, 'final_inputs_advice_reward.txt'));% input structure

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
        
        fileTrigger = fullfile(datapath, sprintf('scanner_trigger_%d.txt', iRun));
        save(fileTrigger,'trigger','-ascii','-tabs');
        
        
        
        outputmatrixSession{iRun} = apply_trigger(fileTrigger, ...
            SOC.Session(2).exp_data);
        choice = outputmatrixSession{iRun}(:,4);
        wager = outputmatrixSession{iRun}(:,7);
        y = [y; choice wager];
        outputmatrix = [outputmatrix; outputmatrixSession{iRun}];
    end
    save(paths.fnBehavMatrix,'outputmatrix','-mat');

    %y = [];
    %outputmatrix = [];
    %for iRun = 1:2
        
        % try whether run 1 and 2 (male adviser) exist
    %    fileBehav = fullfile(paths.behav, ...
    %        sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun));
    %    if ~exist(fileBehav)
    %        % we use run 5+6 (female adviser)
    %        fileBehav = fullfile(paths.behav, ...
    %            sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun+4));
    %    end
    %    load(fileBehav);
        
    %    trigger = SOC.param(2).scanstart;
    %    
    %    fileTrigger = fullfile(paths.behav, sprintf('scanner_trigger_%d.txt', iRun));
    %    save(fileTrigger,'trigger','-ascii','-tabs');
        
        
        
     %   outputmatrixSession{iRun} = apply_trigger(fileTrigger, ...
     %       SOC.Session(2).exp_data);
     %   choice = outputmatrixSession{iRun}(:,4);
     %   wager = outputmatrixSession{iRun}(:,7);
     %   y = [y; choice wager];
     %   outputmatrix = [outputmatrix; outputmatrixSession{iRun}];
    %end
    %save(paths.fnBehavMatrix,'outputmatrix','-mat');
  
    %% Run Inversion
    for iRsp=1
        %%
        
        if doFitModel
            if iRsp==2
                est=fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
                    'hgf_ioio_precision_weight_new_config');
            else
                est=fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
                    'softmax_precision_weighting_reward_social_config');
           end
            save(paths.fnFittedModel{iRsp}, 'est');
        else
            %load(paths.fnFittedModel{iRsp},'est','-mat');
            load(fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
        end
        %% Arbitration %add another parametric modulator 
        %CODE: 0=stable, 1=volatile - add to arbitration - modulate
        
        pmod(1,1).name = {'Arbitration'}; % Arbitration
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
       
        pmod(1,1).param = {[Arbitration]}; % Precision (Model-based wager)
        pmod(1,1).poly={[1]};
        
        
        %% Wager %add 2 parametric modulator - coding files in terms of advice volatility and coding files in term of 

        pmod(1,2).name = {'Wager'}; % Arbitration
        pi_r = pc +1./sa2hat_r;
        pi_a = px +1./sa2hat_a;
        wx = ze1.*pi_a./(ze1.*pi_a + pi_r);
        wc = pi_r./(ze1.*pi_a + pi_r);

        %wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        %wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
       
        % Belief vector
        b = wx.*x_a + wc.*x_r;
        
        pib = 1./(b.*(1-b));
        
        pmod(1,2).param = {[pib]}; % Precision (Model-based wager)
        pmod(1,2).poly={[1]};
       
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
            plot(pmod(1,2).param{1}, 'r', 'LineWidth', 4);
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