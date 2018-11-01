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
iRsp = 2;
paths = get_paths_wagad();
rp_model = paths.nameResponseModels{iRsp};
prc_model= {'hgf_binary3l_reward_social'};

[zeta_parArray] = subjectSpecificZeta;

P=numel(zeta_parArray);
p_prc=zeros(P,14);
p_obs=zeros(numel(zeta_parArray),2);

for m=1
    for i=1
        fh = [];
        sh = [];
        lgh_r = NaN(1,P);
        lgstr_r = cell(1,P);
        lgh_a = NaN(1,P);
        lgstr_a = cell(1,P);
        for par=1:P
            input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));
            inputs_reward=input_u(:,2);
            inputs_advice=input_u(:,1);
            advice_card  =input_u(:,3);
            ze=zeta_parArray(par);
            p_prc=[0 1 1 1 0.58458 -4 0.59936 ...
                   0 1 1 1 0.61243 -4 0.66502 ...
                   0.1000 0.1000 1 1];
            
            lgstr_a{par} = sprintf('\\zeta = %3.1f', ze);
            
            p_obs = [6.6606 -0.5679 0.5793 -0.3872 -0.1581 -1.7403 0.0164 ze 3.3213 7.6193];
            sim   = simResponses(inputs_reward, inputs_advice, advice_card,prc_model{i}, p_prc, rp_model,p_obs);
            colors_r=jet(P);
            colors_a=cool(P);
            currCol_r = colors_r(par,:);
            currCol_a = colors_a(par,:);
            [fh, sh, lgh_r(par), lgh_a(par)] = hgf_plot_rainbowsim(par, fh, sh);
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
        
        
        px = 1./(x_a.*(1-x_a));
        pc = 1./(x_r.*(1-x_r));
        
        mu1hat_r0 = sgm(sim.p_prc.mu2r_0, 1);
        mu1hat_a0 = sgm(sim.p_prc.mu2a_0, 1);
        
        px_0      = 1./(mu1hat_a0.*(1-mu1hat_a0));
        pc_0      = 1./(mu1hat_r0.*(1-mu1hat_r0));
        
        % Version 1
        priorx=sim.p_obs.ze.*px_0./(sim.p_obs.ze.*px_0 + pc_0);
        priorc=pc_0./(sim.p_obs.ze.*px_0 + pc_0);
        
        wx = ze.*px./(ze.*px + pc); % precision first level
        wc = pc./(ze.*px + pc);
        
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
