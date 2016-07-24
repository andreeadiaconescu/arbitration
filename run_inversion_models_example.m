function run_inversion_models_example(s)

if nargin <1
    s=1;
end


doFitModel = true;

%% Modify: Your Paths
dirBase = ('/Users/drea/Documents/Social_Learning_Behaviour/data/');
modelpath='/Users/drea/Documents/MATLAB/IOIO_Wager_Computational_Model/';
addpath('/Users/drea/Documents/MATLAB/IOIO_Wager_Computational_Model/');

%% Modify: Add your Subjects
subjects={'DMPAD_0326','DMPAD_0346','DMPAD_0364',...
    'DMPAD_0367','DMPAD_0366','DMPAD_0337',...
    'DMPAD_0360','DMPAD_0351','DMPAD_0368',...
    'DMPAD_0357','DMPAD_0365','DMPAD_0314',...
    'DMPAD_0373','DMPAD_0374','DMPAD_0332',...
    'DMPAD_0375','DMPAD_0330','DMPAD_0344',...
    'DMPAD_0355','DMPAD_0350','DMPAD_0352',...
    'DMPAD_0345','DMPAD_0310','DMPAD_0339',...
    'DMPAD_0309','DMPAD_0340','DMPAD_0343',...
    'DMPAD_0303','DMPAD_0316','DMPAD_0362',...
    'DMPAD_0338','DMPAD_0348','DMPAD_0334',...
    'DMPAD_0335','DMPAD_0301','DMPAD_0369',...
    'DMPAD_0371','DMPAD_0380','DMPAD_0381',...
    'DMPAD_0382','DMPAD_0392','DMPAD_0359',...
    'DMPAD_0379','DMPAD_0389','DMPAD_0395',...
    'DMPAD_0349','DMPAD_0385','DMPAD_0396',...
    'DMPAD_0387','DMPAD_0388','DMPAD_0409',...
    'DMPAD_0411','DMPAD_0398','DMPAD_0405',...
    'DMPAD_0408','DMPAD_0413','DMPAD_0412',...
    'DMPAD_0418','DMPAD_0399','DMPAD_0421',....
    'DMPAD_0397','DMPAD_0417','DMPAD_0390',...
    'DMPAD_0407','DMPAD_0427','DMPAD_0404',....
    'DMPAD_0416','DMPAD_0449','DMPAD_0442',...
    'DMPAD_0445','DMPAD_0446','DMPAD_0448',...
    'DMPAD_0444','DMPAD_0422','DMPAD_0428',...
    'DMPAD_0401','DMPAD_0433','DMPAD_0423',...
    'DMPAD_0432','DMPAD_0429','DMPAD_0441',...
    'DMPAD_0425','DMPAD_0426','DMPAD_0439',...
    'DMPAD_0440','DMPAD_0437','DMPAD_0430',...
    'DMPAD_0431','DMPAD_0438','DMPAD_0424',...
    'DMPAD_0435','DMPAD_0434','DMPAD_0436',...
    'DMPAD_0402'};

% Find scans
datapath = dirBase;
maskScans = 'DMPAD_*';
scans = dir(fullfile(dirBase,maskScans));
scans = {scans.name};


rp_model= {'softmax_multiple_readouts_reward_social','softmax_precision_weighting_reward_social', ....
           'softmax_multiple_readouts_beliefprecision_reward_social', 'softmax_multiple_readouts_sensoryprecision_reward_social'};
prc_model= 'hgf_binary3l_reward_social';
%% Modify: Your Own Prefix
task='DMPAD_Wager_Sess';
run='7';
input_u = load(fullfile(modelpath, 'final_inputs_advice_reward.txt'));% input structure


for i=1:numel(subjects) % 15
    sub=subjects{i};
    % sub=scans{s};
    
    
    load(fullfile(datapath, [sub '/DMPAD_Behaviour/' , task, sess,'perblock_IOIO_run',run, '.mat']));
    outputmatrix=SOC.Session(2).exp_data;
    adviceBlue=mod(outputmatrix(:,4),2);
    resp = outputmatrix(:,8);
    respBlue=mod(resp,2); % blue = 1, green = 2
    choice_congr  = (adviceBlue == respBlue);
    choice=double(choice_congr);
    takeAdv=sum(choice)./160.*100;
    y=[choice outputmatrix(:,17)];
    
    %% Run Inversion
    for iRsp=1:numel(rp_model)
        %%
        
        if doFitModel
            disp(sub)
            if iRsp==2
                est=fitModel(y,input_u,[prc_model,'_config'],[rp_model{iRsp},'_config'],'quasinewton_allit_optim_config');
                save(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
            else
                est=fitModel(y,input_u,[prc_model,'_config'],[rp_model{iRsp},'_config']);
                save(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                hgf_plotTraj_reward_social(est);
            end
        else
            fullFileName=fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']);
            if exist(fullFileName, 'file')
                disp(sub)
                disp(iRsp)
                load(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
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
                est=fitModel(y,input_u,[prc_model,'_config'],[rp_model{iRsp},'_config']);
                hgf_plotTraj_reward_social(est)
                save(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
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
                save(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_power_design_delta.mat']),'design_delta','-mat');
            else
                hgf_plotTraj_reward_social(est)
            end
            
            
        end
    end
end

return;