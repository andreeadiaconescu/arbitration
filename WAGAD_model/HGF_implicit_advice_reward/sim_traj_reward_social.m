function sim_traj_reward_social
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

omega_parArray=[-6.5:0.5:-3.5];
zeta_parArray=exp([0:0.5:3]);

P=numel(omega_parArray);
O=numel(zeta_parArray);

p_prc=zeros(P,14);
p_obs=zeros(O,2);

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
                p_prc=[0 1 1 1 1 om 0.5 0 1 1 1 1 om 0.5];
                lgstr_r{par} = sprintf('\\omega = %3.1f', om);
                ze=zeta_parArray(par);
                p_obs=[ze log(48)];
                sim = simResponses(inputs_reward, inputs_advice, prc_model{i}, p_prc, rp_model{m},p_obs);
                colors_r=jet(P);
                colors_a=cool(P);
                currCol_r = colors_r(par,:);
                currCol_a = colors_a(par,:);
                [fh, sh, lgh_r(par), lgh_a(par)] = hgf_plot_rainbowsim(par, fh, sh);
                save(fullfile(savepath, sprintf('%s', subj, 'sim_par_', num2str(par), '_', rp_model{m},prc_model{i})), 'sim');
            
        end
        legend(lgh_r, lgstr_r);
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
            % sh(3) = subplot(3,1,3);
        else
            figure(fh);
        end
        % Number of trials
        t = size(sim.u,1);
        
        % Optional plotting of standard deviations (true or false)
        plotsd2 = false;
        plotsd3 = false;
        
        % Subplots
        axes(sh(1))
        if plotsd3 == true
            upper3prior_r = sim.p_prc.mu3r_0 +sqrt(sim.p_prc.sa3r_0);
            lower3prior_r = sim.p_prc.mu3r_0 -sqrt(sim.p_prc.sa3r_0);
            upper3_r = [upper3prior_r; sim.traj.mu_r(:,3)+sqrt(sim.traj.sa_r(:,3))];
            lower3_r = [lower3prior_r; sim.traj.mu_r(:,3)-sqrt(sim.traj.sa_r(:,3))];
            
            plot(0, upper3prior_r, 'o', 'Color', currCol_r, 'LineWidth', 1);
            hold all;
            plot(0, lower3prior_r, 'o', 'Color', currCol_r,  'LineWidth', 1);
            fill([0:t, fliplr(0:t)], [(upper3_r)', fliplr((lower3_r)')], ...
                'FaceColor', currCol_r, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
            
            upper3prior_a = sim.p_prc.mu3a_0 +sqrt(sim.p_prc.sa3a_0);
            lower3prior_a = sim.p_prc.mu3a_0 -sqrt(sim.p_prc.sa3a_0);
            upper3_a = [upper3prior_a; sim.traj.mu_a(:,3)+sqrt(sim.traj.sa_a(:,3))];
            lower3_a = [lower3prior_a; sim.traj.mu_a(:,3)-sqrt(sim.traj.sa_a(:,3))];
            
            plot(0, upper3prior_a, 'o', 'Color', currCol_a, 'LineWidth', 1);
            plot(0, lower3prior_a, 'o', 'Color', currCol_a,  'LineWidth', 1);
            fill([0:t, fliplr(0:t)], [(upper3_a)', fliplr((lower3_a)')], ...
                'FaceColor', currCol_a, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
        end
        plot(0:t, [sim.p_prc.mu3r_0; sim.traj.mu_r(:,3)], 'Color', currCol_r, 'LineWidth', 2);
        hold on;
        plot(0:t, [sim.p_prc.mu3a_0; sim.traj.mu_a(:,3)], 'Color', currCol_a, 'LineWidth', 2);
        plot(0, sim.p_prc.mu3r_0, 'o','Color', currCol_r,  'LineWidth', 2); % prior
        plot(0, sim.p_prc.mu3a_0, 'o','Color', currCol_a,  'LineWidth', 2); % prior
        xlim([0 t]);
        title('Cue-related (rainbow) and advice-related (bone) posterior expectation \mu_3 of log-volatility of tendency x_3', 'FontWeight', 'bold');
        xlabel('Trial number');
        ylabel('\mu_3');
        
%         axes(sh(2));
%         if plotsd2 == true
%             upper2prior_r = sim.p_prc.mu2r_0 +sqrt(sim.p_prc.sa2r_0);
%             lower2prior_r = sim.p_prc.mu2a_0 -sqrt(sim.p_prc.sa2r_0);
%             upper2_r = [upper2prior_r; sim.traj.mu_r(:,2)+sqrt(sim.traj.sa_r(:,2))];
%             lower2_r = [lower2prior_r; sim.traj.mu_r(:,2)-sqrt(sim.traj.sa_r(:,2))];
%             
%             plot(0, upper2prior_r, 'o', 'Color', currCol_r,  'LineWidth', 1);
%             hold all;
%             plot(0, lower2prior_r, 'o', 'Color', currCol_r,  'LineWidth', 1);
%             fill([0:t, fliplr(0:t)], [(upper2_r)', fliplr((lower2_r)')], ...
%                 'FaceColor', currCol_r, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
%             
%             upper2prior_a = sim.p_prc.mu2a_0 +sqrt(sim.p_prc.sa2a_0);
%             lower2prior_a = sim.p_prc.mu2a_0 -sqrt(sim.p_prc.saa2_0);
%             upper2_a = [upper2prior_a; sim.traj.mu_a(:,2)+sqrt(sim.traj.sa_a(:,2))];
%             lower2_a = [lower2prior_a; sim.traj.mu_a(:,2)-sqrt(sim.traj.sa_a(:,2))];
%             
%             plot(0, upper2prior_a, 'o', 'Color', currCol_a,  'LineWidth', 1);
%             plot(0, lower2prior_a, 'o', 'Color', currCol_a,  'LineWidth', 1);
%             fill([0:t, fliplr(0:t)], [(upper2_a)', fliplr((lower2_a)')], ...
%                 'FaceColor', currCol_a, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
%         end
%         plot(0:t, [sim.p_prc.mu2r_0; sim.traj.mu_r(:,2)], 'Color', currCol_r, 'LineWidth', 2);
%         hold all;
%         plot(0:t, [sim.p_prc.mu2a_0; sim.traj.mu_a(:,2)], 'Color', currCol_a, 'LineWidth', 2);
%         plot(0, sim.p_prc.mu2r_0, 'o', 'Color', currCol_r,  'LineWidth', 2); % prior reward
%         plot(0, sim.p_prc.mu2a_0, 'o', 'Color', currCol_a,  'LineWidth', 2); % prior advice
%         xlim([0 t]);
%         title('Cue-related (rainbow) and advice-related (bone) posterior expectation \mu_2 of tendency x_2', 'FontWeight', 'bold');
%         xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
%         ylabel('\mu_2');
%         % hold off;
        
        axes(sh(2));
        lgh_r = plot(0:t, [sgm(sim.p_prc.mu2r_0, 1); sgm(sim.traj.mu_r(:,2), 1)],'Color', currCol_r, 'LineWidth', 2);
        hold all;
        lgh_a = plot(0:t, [sgm(sim.p_prc.mu2a_0, 1); sgm(sim.traj.mu_a(:,2), 1)],'Color', currCol_a, 'LineWidth', 2);
        plot(0, sgm(sim.p_prc.mu2r_0, 1), 'o', 'Color', currCol_r,  'LineWidth', 2); % prior reward
        plot(0, sgm(sim.p_prc.mu2a_0, 1), 'o', 'Color', currCol_a,  'LineWidth', 2); % prior advice
        plot(1:t, sim.u(:,1), 'o', 'Color', 'k'); % inputs reward
        plot(1:t, sim.u(:,2), 'o', 'Color', [0 0.6 0]); % inputs advice
        
        if ~isempty(find(strcmp(fieldnames(sim),'y'))) && ~isempty(sim.y)
            y = stretch(sim.y(:,1), 1+0.16 + (par-1)*0.05);
            plot(1:t, y, '.', 'Color', currCol_r); % responses
            %             if iSubject ==1;
            %                 sim_y_is_y = stretch(input_y, 1.32);
            %                 plot(1:t, sim_y_is_y, '*', 'Color', 'r'); % responses that were congruent
            %             end
            
            title(['Input u (green), responses (rainbow) and cue-related (rainbow) and advice-related (bone) posterior expectation of input s(\mu_2) for \omega cue=', num2str(sim.p_prc.om_r), ...
                ', \omega advice=', num2str(sim.p_prc.om_a),...
                ', \zeta=', num2str(sim.p_obs.ze)],'FontWeight', 'bold');
            
            ylabel('y, u, s(\mu_2)');
            axis([0 t -0.35 1.35]);
        else
            title(['Input u (green) and posterior expectation of input s(\mu_2) (red) for \omega cue=', ...
                num2str(sim.p_prc.om_r), ', \omega advice=', num2str(sim.p_prc.om_a), ', \zeta=', num2str(sim.p_obs.ze)], ...
                'FontWeight', 'bold');
            ylabel('u, s(\mu_2)');
            axis([0 t -0.1 1.1]);
        end
        plot(1:t, 0.5, 'k');
        xlabel('Trial number');
        % hold off;
    end

end

function y = stretch(y, fac)
y = y - 0.5;
y = y*fac;
y = y + 0.5;
end