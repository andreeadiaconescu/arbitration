function run_inversion_models_MS

if nargin <1
    s=1;
end


doFitModel = true;

%% Modify: Your Paths
dirBase = ('/Users/mstecy/Dropbox/MadelineMSc/DatafMRI/fMRI_data');
modelpath='/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/WAGAD_Model/';
addpath('/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/WAGAD_Model/');

%% Modify: Add your Subjects
subjects={'TNU_WAGAD_0020','TNU_WAGAD_0021','TNU_WAGAD_0022','TNU_WAGAD_0023',...
    'TNU_WAGAD_0026','TNU_WAGAD_0027','TNU_WAGAD_0028','TNU_WAGAD_0029','TNU_WAGAD_0030',...
    'TNU_WAGAD_0031','TNU_WAGAD_0035','TNU_WAGAD_0036','TNU_WAGAD_0038','TNU_WAGAD_0039',...
    'TNU_WAGAD_0040','TNU_WAGAD_0041','TNU_WAGAD_0042','TNU_WAGAD_0043','TNU_WAGAD_0044',...
    'TNU_WAGAD_0045','TNU_WAGAD_0046','TNU_WAGAD_0047'};
subjects={'TNU_WAGAD_0003','TNU_WAGAD_0004','TNU_WAGAD_0005','TNU_WAGAD_0006','TNU_WAGAD_0007',...
    'TNU_WAGAD_0008','TNU_WAGAD_0009','TNU_WAGAD_0010','TNU_WAGAD_0011','TNU_WAGAD_0012',...
    'TNU_WAGAD_0013','TNU_WAGAD_0015','TNU_WAGAD_0016','TNU_WAGAD_0017','TNU_WAGAD_0018',...
    'TNU_WAGAD_0019','TNU_WAGAD_0020','TNU_WAGAD_0021','TNU_WAGAD_0022','TNU_WAGAD_0023',...
    'TNU_WAGAD_0026','TNU_WAGAD_0027','TNU_WAGAD_0028','TNU_WAGAD_0029','TNU_WAGAD_0030',...
    'TNU_WAGAD_0031','TNU_WAGAD_0035','TNU_WAGAD_0036','TNU_WAGAD_0038','TNU_WAGAD_0039',...
    'TNU_WAGAD_0040','TNU_WAGAD_0041','TNU_WAGAD_0042','TNU_WAGAD_0043','TNU_WAGAD_0044',...
    'TNU_WAGAD_0045','TNU_WAGAD_0046','TNU_WAGAD_0047'};


% Find scans
datapath = dirBase;
maskScans = 'TNU_WAGAD_*';
scans = dir(fullfile(dirBase,maskScans));
scans = {scans.name};


rp_model= {'softmax_additiveprecision_reward_social_config'};
%rp_model= {'softmax_precision_weighting_reward_social_config', ....
 %          'softmax_multiple_readouts_beliefprecision_reward_social_config', ...
  %         'softmax_multiple_readouts_sensoryprecision_reward_social_config'};
prc_model= 'hgf_binary3l_reward_social_config';
%% Modify: Your Own Prefix
%task='DMPAD_Wager_Sess';
run='1';
input_u = load(fullfile(modelpath, 'final_inputs_advice_reward.txt'));% input structure


for i=1:numel(subjects) % 15
    sub=subjects{i};
    sub1 = sub(end - 1:end);
    sub2 = str2num(sub1);
    paths = get_paths_wagad(sub2,1,2);

    % sub=scans{s};
    
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

    %load(fullfile(datapath, [sub '/behav/' , 'WAGAD_0003perblock_IOIO_run',run, '.mat']));
    %outputmatrix=SOC.Session(2).exp_data;
    %adviceBlue=mod(outputmatrix(:,4),2);
    %resp = outputmatrix(:,8);
    %respBlue=mod(resp,2); % blue = 1, green = 2
    %choice_congr  = (adviceBlue == respBlue);
    %choice=double(choice_congr);
    %takeAdv=sum(choice)./160.*100;
    %y=[choice outputmatrix(:,17)];
    
    %% Run Inversion
    %for iRsp=1:numel(rp_model)
    for iRsp=1
        %%
        
        if doFitModel
            disp(sub)
            if iRsp==2
                %est=fitModel(y,input_u,prc_model,rp_model{iRsp},'quasinewton_allit_optim_config');
                
                est=fitModel(y,input_u,'hgf_binary3l_reward_social_config','softmax_additiveprecision_reward_social_config','quasinewton_optim_config');

                save(fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                
            else
                %est=fitModel(y,input_u,prc_model,rp_model{iRsp});
                est=fitModel(y,input_u,'hgf_binary3l_reward_social_config','softmax_additiveprecision_reward_social_config','quasinewton_optim_config');
                save(fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                hgf_plotTraj_reward_social(est);
            end
        else
            fullFileName=fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']);
            if exist(fullFileName, 'file')
                disp(sub)
                disp(iRsp)
                load(fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                x_r=est.traj.muhat_r(:,1);
                sa_r = x_r.*(1-x_r);
                design_delta.Delta1_r       = abs(est.traj.da_r(:,1));
                design_delta.Delta2_r       = est.traj.da_r(:,2);
                design_delta.LearningRate_r = sa_r.*est.traj.sa_r(:,2);
                design_delta.Sigma3_r       = est.traj.sa_r(:,3);
                design_delta.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                x_a=est.traj.muhat_a(:,1);
                sa_a = x_a.*(1-x_a);
                design_delta.Delta1_a       = abs(est.traj.da_a(:,1));
                design_delta.Delta2_a       = est.traj.da_a(:,2);
                design_delta.LearningRate_a = sa_a.*est.traj.sa_a(:,2);
                design_delta.Sigma3_a       = est.traj.sa_a(:,3);
                design_delta.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                hgf_plotTraj_reward_social(est);
            else
                disp(sub)
                est=fitModel(y,input_u,prc_model,rp_model{iRsp});
                hgf_plotTraj_reward_social(est)
                save(fullfile(datapath, [sub '/behav/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
            end
            
            if iRsp ==2
                x_r=est.traj.muhat_r(:,1);
                sa_r = x_r.*(1-x_r);
                design_delta.Delta1_r       = abs(est.traj.da_r(:,1));
                design_delta.Delta2_r       = est.traj.da_r(:,2);
                design_delta.LearningRate_r = sa_r.*est.traj.sa_r(:,2);
                design_delta.Sigma3_r       = est.traj.sa_r(:,3);
                design_delta.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                
                %% Plot
                figure;
                % Subplots
                subplot(5,1,1);
                plot(design_delta.Delta1_r, 'm', 'LineWidth', 4);
                hold on;
                plot(ones(200,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(5,1,2);
                plot(design_delta.Delta2_r , 'r', 'LineWidth', 4);
                hold on;
                plot(ones(200,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(5,1,3);
                plot(design_delta.LearningRate_r, 'c', 'LineWidth', 4);
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(5,1,4);
                plot(design_delta.Sigma3_r, 'b', 'LineWidth', 4);
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                
                subplot(5,1,5);
                plot(design_delta.Wager, 'g', 'LineWidth', 4);
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                xlabel('Trial number');
                hold on;
                
                subplot(5,1,1);
                title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                    num2str(est.p_obs.ze1), ...
                    ' for subject ', sub], ...
                    'FontWeight', 'bold');
                
                %%
                x_a=est.traj.muhat_a(:,1);
                sa_a = x_a.*(1-x_a);
                design_delta.Delta1_a       = abs(est.traj.da_a(:,1));
                design_delta.Delta2_a       = est.traj.da_a(:,2);
                design_delta.LearningRate_a = sa_a.*est.traj.sa_a(:,2);
                design_delta.Sigma3_a       = est.traj.sa_a(:,3);
                design_delta.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                %% Plot
                % Subplots
                subplot(5,1,1);
                plot(design_delta.Delta1_a, 'm', 'LineWidth', 2,'LineStyle','-.');
                hold on;
                plot(ones(200,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                ylabel('\delta_1');
                
                subplot(5,1,2);
                plot(design_delta.Delta2_a , 'r', 'LineWidth', 2,'LineStyle','-.');
                hold on;
                plot(ones(200,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                ylabel('\delta_2');
                
                subplot(5,1,3);
                plot(design_delta.LearningRate_a, 'c', 'LineWidth', 2,'LineStyle','-.');
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                ylabel('\sigma_2');
                
                subplot(5,1,4);
                plot(design_delta.Sigma3_a, 'b', 'LineWidth', 2,'LineStyle','-.');
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                ylabel('\sigma_3');
                
                subplot(5,1,5);
                plot(design_delta.Wager, 'g', 'LineWidth', 2,'LineStyle','-.');
                hold on;
                plot(ones(200,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                ylabel('Amount Wagered');
                xlabel('Trial number');
                hold off;
                save(fullfile(datapath, [sub '/behav/' sub '_power_design_delta.mat']),'design_delta','-mat');
            else
                hgf_plotTraj_reward_social(est)
            end
            
            
        end
    end
end

return;