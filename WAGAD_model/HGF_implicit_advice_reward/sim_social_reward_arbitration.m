function sim_social_reward_arbitration
% Plots learning trajectories given a perceptual and response model
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2013 Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pathroot=fileparts(mfilename('fullpath')); %%% CHANGE;
savepath = [pathroot '/sim_results/'];
rp_model= {'softmax_reward_social'};
prc_model= {'hgf_binary3l_reward_social'};

data = {'leo_inputs_cue_advice'}; % input structure

omega_parArray=[-3.5:-0.5:-6.5];

zeta_parArray=exp([0:0.5:3]);


P=numel(zeta_parArray);
%O=numel(zeta_parArray);

p_prc=zeros(P,14);
p_obs=zeros(numel(zeta_parArray),2);

for m=1:numel(rp_model)
    for i=1:numel(prc_model)
        fh = [];
        sh = [];
        lgh_r = NaN(1,P);
        lgstr_r = cell(1,P);
        lgh_a = NaN(1,P);
        lgstr_a = cell(1,P);
        for par=1:P
            
            subj=data{1};
            input_u = load(fullfile(pathroot, [subj '.txt']));
            inputs_reward=input_u(:,1);
            inputs_advice=input_u(:,2);
            om=omega_parArray(par);
            ze=zeta_parArray(par);
            p_prc=[0 1 1 1 1 om 0.5 0 1 1 1 1 om 0.5];
            lgstr_a{par} = sprintf('\\zeta = %3.1f', ze);
            
            p_obs=[ze log(48)];
            sim = simResponses(inputs_reward, inputs_advice, prc_model{i}, p_prc, rp_model{m},p_obs);
            colors_r=jet(P);
            colors_a=cool(P);
            currCol_r = colors_r(par,:);
            currCol_a = colors_a(par,:);
            [fh, sh, lgh_r(par), lgh_a(par)] = hgf_plot_rainbowsim(par, fh, sh);
            save(fullfile(savepath, sprintf('%s', subj, 'sim_par_', num2str(par), '_', rp_model{m},prc_model{i})), 'sim');
            
        end
        legend(lgh_a, lgstr_a);
    end
end

%%
    function [fh, sh, lgh_r,lgh_a] = hgf_plot_rainbowsim(par, fh, sh)
        currCol_r = colors_r(par,:);
        currCol_a = colors_a(par,:);
        if isempty(fh)
            % Set up display
            scrsz = get(0,'screenSize');
            outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
            
            fh = figure(...
                'OuterPosition', outerpos,...
                'Name','HGF binary fit results');
            % set(gcf,'DefaultAxesColorOrder',colors);
            sh(1) = subplot(2,1,1);
            sh(2) = subplot(2,1,2);
        else
            figure(fh);
        end
        % Number of trials
        t = size(sim.u,1);
        
        % Trajectories
        
        x_a=sgm(sim.traj.mu_a(:,2), 1);
        x_r=sgm(sim.traj.mu_r(:,2), 1);
        
        sa2hat_a=sim.traj.sa_a(:,2);
        sa2hat_r=sim.traj.sa_r(:,2);
        
        px = 1./(x_a.*(1-x_a));
        pc = 1./(x_r.*(1-x_r));

        % Version 1
        % wx = ze1.*px./(ze1.*px + pc); % precision first level
        % wc = pc./(ze1.*px + pc);
        
        % Version 2
        priorx=sim.p_obs.ze.*1./sim.p_prc.sa2a_0.*1./sgm(sim.p_prc.mu2a_0, 1)./...
            (sim.p_obs.ze.*1./sgm(sim.p_prc.mu2a_0, 1).* 1./sim.p_prc.sa2a_0 + 1./sgm(sim.p_prc.mu2r_0, 1).*1./sim.p_prc.sa2r_0);
        priorc=1./sgm(sim.p_prc.mu2r_0, 1).*1./sim.p_prc.sa2r_0./...
            (sim.p_obs.ze.*1./sgm(sim.p_prc.mu2a_0, 1).*1./sim.p_prc.sa2a_0 + 1./sgm(sim.p_prc.mu2r_0, 1).*1./sim.p_prc.sa2r_0);
        
        wx = sim.p_obs.ze.*1./sa2hat_a.*px./...
            (sim.p_obs.ze.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        wc = 1./sa2hat_r.*pc./...
            (sim.p_obs.ze.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
        
        % Version 3
%         priorx=sim.p_obs.ze.*exp(sim.p_prc.sa3a_0)./...
%             (sim.p_obs.ze.* exp(sim.p_prc.sa3a_0) + exp(sim.p_prc.sa3r_0));
%         priorc=exp(sim.p_prc.sa3r_0)./...
%             (sim.p_obs.ze.* exp(sim.p_prc.sa3a_0) + exp(sim.p_prc.sa3r_0));
%         
%         wx = sim.p_obs.ze.*exp(sim.traj.muhat_a(:,3))./...
%             (sim.p_obs.ze.*exp(sim.traj.muhat_a(:,3)) + exp(sim.traj.muhat_r(:,3)));
%         wc = exp(sim.traj.muhat_r(:,3))./...
%             (sim.p_obs.ze.*exp(sim.traj.muhat_a(:,3)) + exp(sim.traj.muhat_r(:,3)));
        
        
        % Subplots
        axes(sh(1))      
        lgh_r = plot(0:t, [priorc; wc], 'Color', currCol_r, 'LineWidth', 2);
        hold on;
        plot(0, priorc, 'o','Color', currCol_r,  'LineWidth', 2); % prior
        xlim([0 t]);
        title('Reward Weighting', 'FontWeight', 'bold');
        xlabel('Trial number');
        ylabel('Precision ratio (reward)');
        
        axes(sh(2));      
        lgh_a = plot(0:t, [priorx; wx], 'Color', currCol_a, 'LineWidth', 2);
        hold all;
        plot(0, priorx, 'o', 'Color', currCol_a,  'LineWidth', 2); % prior advice
        xlim([0 t]);
        title('Advice Weighting', 'FontWeight', 'bold');
        xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
        ylabel('Precision ratio (advice)');
   
        plot(1:t, 0.5, 'k');

    end

end
