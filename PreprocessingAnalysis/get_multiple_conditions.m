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
    idDesign = 12;
    paths = get_paths_wagad(iSubj,1,idDesign);
    
    if ismac
        doFitModel = false;
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
    for iRsp=1% 1:4
        if doFitModel
            est=fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
                paths.fileResponseModels{iRsp});
            % hgf_plotTraj_reward_social(est);
            save(paths.fnFittedModel{iRsp}, 'est');
        else
            load(paths.fnFittedModel{1},'est','-mat'); % Select the winning model only
        end
        %% Create Parametric Modulators / Define Conditions
        if strcmp(typeDesign,'ModelBased')==1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % First: Arbitration (Precision Ratio),
            % Advice Prediction (Mu1hat_A), Reward Prediction (Mu1hat_R)
            % Time-Locked to Prediction Phase
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pmod(1,1).name = {'Arbitration','Weighting','Precision_Advice','Precision_Reward'};
            x_a     =est.traj.muhat_a(:,2);
            x_r     =est.traj.muhat_r(:,2);
            sa2hat_a=est.traj.sahat_a(:,2);
            sa2hat_r=est.traj.sahat_r(:,2);
            px      = 1./sa2hat_a;
            pc      = 1./sa2hat_r;
            ze1     = est.p_obs.ze1;
            wx   = ze1.*px./(ze1.*px + pc);
            wc   = pc./(ze1.*px + pc);
            Social_weighting = wx;
            Arbitration      = wx.*wc;
            pmod(1,1).param = {[Arbitration],[Social_weighting],[px],[pc]}; % Precision (Model-based wager)
            pmod(1,1).poly={[1],[1],[1],[1]};
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Second: Wager (Belief Precision), Belief
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pmod(1,2).name = {'BeliefPrecision','Belief','Alpha','Wager_Amount'}; % Belief Precision
            % Belief vector
            % Version 1
            %             b_2           = wx.*x_a + wc.*x_r;
            %             b             = sgm(b_2,1);
            %             pib           = 1./(b.*(1-b));
            %             alpha         = sgm((pib-4),1);
            %             predict_wager = (2.*alpha -1).*10;
            
            % Version 2
            a     =est.traj.muhat_a(:,1);
            r     =est.traj.muhat_r(:,1);
            temp_a= a.*(1-a);
            pa     = 1./temp_a;
            temp_r= r.*(1-r);
            pr     = 1./temp_r;
            wa   = pa./(pa + pr);
            wr   = pr./(pa + pr);
            b             = wa.*a + wr.*r;
            pib           = 1./(b.*(1-b));
            alpha         = sgm((pib-4),1);
            predict_wager = (2.*alpha -1).*10;
            pmod(1,2).param = {[pib],[b],[alpha],[y(:,2)]}; % Precision (Model-based wager)
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
            pmod(1,3).param = {[Epsilon2.Advice],[Epsilon2.Reward],[Epsilon3.Advice],[Epsilon3.Reward]};
            pmod(1,3).poly={[1], [1],[1], [1]};
            %% Plot
            probabilityReward = [ones(25,1)'.*0.9, ones(15,1)'.*0.60, ones(30,1)'.*0.5, ones(25,1)'.*0.4, ...
                                ones(25,1)'.*0.9,ones(15,1)'.*0.9, ones(25,1)'.*0.1];
                                   
            probabilityAdvice = [ones(25,1)'.*0.9, ones(15,1)'.*0.90, ones(30,1)'.*0.6, ones(25,1)'.*0.1, ...
                                ones(25,1)'.*0.6, ones(15,1)'.*0.1, ones(25,1)'.*0.5];
            PlotFigureA = 1;
            PlotFigureB = 0;
            
            if doPlotFigures
                if PlotFigureA
                    figure;
                    % Subplots
                    subplot(5,1,1);
                    plot(probabilityReward,'b', 'LineWidth', 4);
                    hold on
                    plot(probabilityAdvice,'r', 'LineWidth', 4);
                    ylabel('Probabilities');
                    
                    subplot(5,1,2);
                    plot(pmod(1,1).param{1}, 'm', 'LineWidth', 4);
                    ylabel(pmod(1,1).name{1});
                    
                    subplot(5,1,3);
                    plot(pmod(1,1).param{2} , 'r', 'LineWidth', 4);
                    hold on;
                    plot(wc , 'b', 'LineWidth', 4);
                    ylabel(pmod(1,1).name{2});
                    
                    subplot(5,1,4);
                    plot(pmod(1,3).param{1}, 'c', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{1});
                    
                    subplot(5,1,5);
                    plot(pmod(1,3).param{2}, 'b', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{2});
                    hold on;
                    xlabel('Trial number');
                    subplot(5,1,1);
                    hold on;
                    title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                        num2str(est.p_obs.ze1), ...
                        ' for subject ', paths.idSubjBehav], ...
                        'FontWeight', 'bold');
                elseif PlotFigureB
                    figure;
                    % Subplots
                    subplot(4,1,1);
                    plot(pmod(1,2).param{1}, 'm', 'LineWidth', 4);
                    hold on;
                    plot(ones(170,1).*0.25,'k','LineWidth', 1,'LineStyle','-.');
                    
                    subplot(4,1,2);
                    plot(pmod(1,2).param{2} , 'r', 'LineWidth', 4);
                    hold on;
                    plot(ones(170,1).*0.25,'k','LineWidth', 1,'LineStyle','-.');
                    
                    subplot(4,1,3);
                    plot(pmod(1,2).param{3}, 'c', 'LineWidth', 4);
                    hold on;
                    plot(ones(170,1).*1,'k','LineWidth', 1,'LineStyle','-.');
                    
                    subplot(4,1,4);
                    plot(pmod(1,2).param{4}, 'b', 'LineWidth', 4);
                    hold on;
                    plot(predict_wager , 'r', 'LineWidth', 4);
                    plot(ones(170,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                    xlabel('Trial number');
                    subplot(4,1,1);
                    hold on;
                    title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                        num2str(est.p_obs.ze1), ...
                        ' for subject ', paths.idSubjBehav], ...
                        'FontWeight', 'bold');
                else
                    figure;
                    % Subplots
                    subplot(4,1,1);
                    plot(pmod(1,3).param{1}, 'm', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{1});
                    subplot(4,1,2);
                    plot(pmod(1,3).param{2} , 'r', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{2});
                    subplot(4,1,3);
                    plot(pmod(1,3).param{3}, 'c', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{3});
                    subplot(4,1,4);
                    plot(pmod(1,3).param{4}, 'b', 'LineWidth', 4);
                    ylabel(pmod(1,3).name{1});
                    hold on;
                    xlabel('Trial number');
                    subplot(4,1,1);
                    hold on;
                    title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                        num2str(est.p_obs.ze1), ...
                        ' for subject ', paths.idSubjBehav], ...
                        'FontWeight', 'bold');
                end
            end
            onsets{1} = outputmatrix(:,1);
            onsets{2} = outputmatrix(:,2);
            onsets{3} = outputmatrix(:,3);
            
            % Switch off orthogonalization for each condition separately
            orth{1} = 0;
            orth{2} = 0;
            orth{3} = 0;
            names={'Advice','Wager','Outcome'};
            
            
            durations{1} = 2;            
            durations{2} = 0;
            durations{3} = 0;
            
            save(paths.fnMultipleConditions, 'onsets', 'names', 'durations', 'names', 'pmod', 'orth', '-mat');
            
        elseif strcmp(typeDesign,'ModelFree')==1
            AdviceCodingUnstable=[zeros(25,1)' zeros(15,1)' ones(30,1)' zeros(25,1)' ones(25,1)' zeros(15,1)' ones(25,1)'];
            RewardCodingUnstable=[zeros(25,1)' ones(15,1)' ones(30,1)' ones(25,1)' zeros(25,1)' zeros(15,1)' zeros(25,1)'];
            
            AdviceCodingStable = [ones(25,1)' ones(15,1)' zeros(30,1)' ones(25,1)' zeros(25,1)' ones(15,1)' zeros(25,1)'];
            RewardCodingStable = [ones(25,1)' zeros(15,1)' zeros(30,1)' zeros(25,1)' ones(25,1)' ones(15,1)' ones(25,1)'];
            
            names={'RewardStable','RewardUnstable','AdviceStable','AdviceUnstable'};
            %             onsets{1} = outputmatrix(RewardCodingStable==1,1);
            %             onsets{2} = outputmatrix(RewardCodingUnstable==1,1);
            %             onsets{3} = outputmatrix(AdviceCodingStable==1,1);
            %             onsets{4} = outputmatrix(AdviceCodingUnstable==1,1);
            %             durations{1} = 0;
            %             durations{2} = 0;
            %             durations{3} = 0;
            %             durations{4} = 0;
            %             save(paths.fnModelFreePredictionConditions, 'onsets', 'names', 'durations', '-mat');
            %
            %             clear onsets;
            %             clear durations;
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
end