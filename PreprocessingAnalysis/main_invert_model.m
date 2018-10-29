function main_invert_model(iSubjectArray,idDesign)

for iSubj = iSubjectArray
    %% Load Model and inputs
    paths = get_paths_wagad(iSubj,1,idDesign);
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
    for iRsp= 1:numel(paths.fileResponseModels)
        est=tapas_fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
            [paths.fnFittedModel{iRsp}]);
        % Extract trajectories of interest from infStates
        mu1hat_a = est.traj.muhat_a(:,1);
        mu1hat_r = est.traj.muhat_r(:,1);
        mu2hat_a = est.traj.muhat_a(:,2);
        mu2hat_r = est.traj.muhat_r(:,2);
        sa2hat_r = est.traj.sahat_r(:,2);
        sa2hat_a = est.traj.sahat_a(:,2);
        mu3hat_r = est.traj.muhat_r(:,3);
        mu3hat_a = est.traj.muhat_a(:,3);
        ze       = est.p_obs.ze;
        advice_card_space = input_u(:,3);
        % Transform the card colour
        transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);
        
        %% Belief Vector
        % Precision 1st level (i.e., Fisher information) vectors
        px = 1./(mu1hat_a.*(1-mu1hat_a));
        pc = 1./(mu1hat_r.*(1-mu1hat_r));
        
        % Weight vectors 1st level
        wx = ze.*px./(ze.*px + pc); % precision first level
        wc = pc./(ze.*px + pc);
        
        % Belief and Choice Noise
        b              = wx.*mu1hat_a + wc.*transformed_mu1hat_r;
        
        % Surprise
        % ~~~~~~~~
        surp = -log2(b);
        
        % Arbitration
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        arbitration = wx;
        
        % Inferential variance (aka informational or estimation uncertainty, ambiguity)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        inferv_a = tapas_sgm(mu2hat_a, 1).*(1 -tapas_sgm(mu2hat_a, 1)).*sa2hat_a; % transform down to 1st level
        inferv_r = tapas_sgm(mu2hat_r, 1).*(1 -tapas_sgm(mu2hat_r, 1)).*sa2hat_r; % transform down to 1st level
        
        % Phasic volatility (aka environmental or unexpected uncertainty)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        pv_a = tapas_sgm(mu2hat_a, 1).*(1-tapas_sgm(mu2hat_a, 1)).*exp(mu3hat_a); % transform down to 1st level
        pv_r = tapas_sgm(mu2hat_r, 1).*(1-tapas_sgm(mu2hat_r, 1)).*exp(mu3hat_r); % transform down to 1st level
        
        logrt = est.p_obs.be0 + est.p_obs.be1.*surp + est.p_obs.be2.*arbitration + ...
            est.p_obs.be3.*inferv_a + est.p_obs.be4.*inferv_r + est.p_obs.be5.*pv_a + ...
            est.p_obs.be6.*pv_r;
        predicted_wager = tapas_sgm(logrt,1).*10-ones(size(logrt)); % wager from 1 to 10
        est.predict_wager = predicted_wager;
        
        save(paths.fnFittedModel{iRsp}, 'est');
    end
end