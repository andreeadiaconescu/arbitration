clear all;
subjects={'DMPAD_MS_Pilot1'};


doFitModel = true;

dirBase = ('/Users/drea/Dropbox/MadelineMSc/PilotData/');
modelpath='/Users/drea/Dropbox/MadelineMSc/IOIO_Wager_Computational_Model/';
datapath = dirBase;

addpath('/Users/drea/Dropbox/MadelineMSc/IOIO_Wager_Computational_Model/');

run ={'5','6'}; %% Change here depending on the run



rp_model= {'softmax_multiple_readouts_reward_social'};
prc_model= 'hgf_binary3l_reward_social';


input_u = load(fullfile(modelpath, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?

for i=1:numel(subjects)
    sub=subjects{i};
  
    load(fullfile(datapath, [sub '/behav/' , sub, 'perblock_IOIO_run', run{1}, '.mat']));
    
    trigger_1=SOC.param(2).scanstart;
    save(fullfile(datapath, ['scanner_trigger.txt']),'trigger_1','-ascii','-tabs');  
    outputmatrix_1=apply_trigger([datapath '/scanner_trigger.txt'], SOC.Session(2).exp_data);
    choice=outputmatrix_1(:,4);
    y_1=[choice outputmatrix_1(:,7)];
    
    load(fullfile(datapath, [sub '/behav/' , sub, 'perblock_IOIO_run', run{2}, '.mat']));
    trigger_2=SOC.param(2).scanstart;
    save(fullfile(datapath, ['scanner_trigger.txt']),'trigger_2','-ascii','-tabs');  
    outputmatrix_2=apply_trigger([datapath '/scanner_trigger.txt'], SOC.Session(2).exp_data);
    choice=outputmatrix_2(:,4);
    y_2=[choice outputmatrix_2(:,7)];
    outputmatrix = [outputmatrix_1; outputmatrix_2];
    y=[y_1;y_2];
    save(fullfile(datapath, sub, [sub 'onsets_regressor.mat']),'outputmatrix','-mat');
    
    %% Run Inversion
        for iRsp=1:numel(rp_model)
            %%
            
            if doFitModel
                est=fitModel(y,input_u);
            else
                load(fullfile(datapath, [sub '/DMPAD_Behaviour/' sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
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
                ' for subject ', sub], ...
                'FontWeight', 'bold');
            onsets{1}=[outputmatrix_1(:,1);outputmatrix_2(:,1)];
            onsets{2}=[outputmatrix_1(:,2);outputmatrix_2(:,2)];
            onsets{3}=[outputmatrix_1(:,3);outputmatrix_2(:,3)];
            names={'Advice','Wager','Outcome'};
            durations={[(outputmatrix_1(:,5)-outputmatrix_1(:,2));(outputmatrix_2(:,5)-outputmatrix_2(:,2))],[8],[0]};
           
            
            save(fullfile(datapath, [sub '/behav/', sub, '_multiple_conditions.mat']),'onsets', 'names', 'durations', 'names', 'pmod', '-mat');
        end
    end
    



return;
