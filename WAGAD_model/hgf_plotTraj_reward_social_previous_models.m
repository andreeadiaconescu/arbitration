function hgf_plotTraj_reward_social_previous_models(r)
% Plots trajectories estimated by fitModel for the hgf_binary3l_reward_social perceptual model
% Usage:  est = fitModel(responses, inputs); hgf_plotTraj_reward_social(est);
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


% Set up display
scrsz = get(0,'screenSize');
outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
figure(...
    'OuterPosition', outerpos,...
    'Name','HGF binary fit results');

% Number of trials
t = size(r.u,1);

% Optional plotting of standard deviations (true or false)
plotsd2 = false;
plotsd3 = false;

% Subplots
%%
subplot(3,1,1);

if plotsd3 == true
    upper3prior_r = r.p_prc.mu3r_0 +sqrt(r.p_prc.sa3r_0);
    lower3prior_r = r.p_prc.mu3r_0 -sqrt(r.p_prc.sa3r_0);
    upper3_r = [upper3prior_r; r.traj.mu_r(:,3)+sqrt(r.traj.sa_r(:,3))];
    lower3_r = [lower3prior_r; r.traj.mu_r(:,3)-sqrt(r.traj.sa_r(:,3))];
    
    upper3prior_a = r.p_prc.mu3a_0 +sqrt(r.p_prc.sa3a_0);
    lower3prior_a = r.p_prc.mu3a_0 -sqrt(r.p_prc.sa3a_0);
    upper3_a = [upper3prior_a; r.traj.mu_a(:,3)+sqrt(r.traj.sa_a(:,3))];
    lower3_a = [lower3prior_a; r.traj.mu_a(:,3)-sqrt(r.traj.sa_a(:,3))];
    
    plot(0, upper3prior_r, 'ob', 'LineWidth', 1);
    hold all;
    plot(0, lower3prior_r, 'ob', 'LineWidth', 1);
    fill([0:t, fliplr(0:t)], [(upper3_r)', fliplr((lower3_r)')], ...
        'b', 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
    
    plot(0, upper3prior_a, 'ob', 'LineWidth', 1);
    plot(0, lower3prior_a, 'ob', 'LineWidth', 1);
    fill([0:t, fliplr(0:t)], [(upper3_a)', fliplr((lower3_a)')], ...
        'c', 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
end

% reward
plot(0:t, [r.p_prc.mu3r_0; r.traj.mu_r(:,3)], 'b', 'LineWidth', 2);
hold all;
plot(0, r.p_prc.mu3r_0, 'ob', 'LineWidth', 2); % prior

% advice
plot(0:t, [r.p_prc.mu3a_0; r.traj.mu_a(:,3)], 'c', 'LineWidth', 2);
plot(0, r.p_prc.mu3a_0, 'ob', 'LineWidth', 2); % prior
xlim([0 t]);
title('Posterior expectation \mu_3 of log-volatility of tendency x_3 for cue (blue) and advice (cyan)', 'FontWeight', 'bold');
xlabel('Trial number');
ylabel('\mu_3');

%%
subplot(3,1,2);

plot(0:t, [sgm(r.p_prc.mu2r_0, 1); sgm(r.traj.mu_r(:,2), 1)], 'r', 'LineWidth', 2);
hold all;
plot(0, sgm(r.p_prc.mu2r_0, 1), 'or', 'LineWidth', 2); % prior
plot(1:t, r.u(:,1), '*', 'Color', 'k'); % reward


plot(0:t, [sgm(r.p_prc.mu2a_0, 1); sgm(r.traj.mu_a(:,2), 1)], 'm', 'LineWidth', 2);
plot(0, sgm(r.p_prc.mu2a_0, 1), 'or', 'LineWidth', 2); % prior
plot(1:t, r.u(:,2), 'o', 'Color', [0 0.6 0]); % advice

if ~isempty(find(strcmp(fieldnames(r),'y'))) && ~isempty(r.y)
    y = r.y([2:160],1) -0.5; y = 1.16 *y; y = y +0.5; % stretch
    if ~isempty(find(strcmp(fieldnames(r),'irr')))
        y(r.irr) = NaN; % weed out irregular responses
        plot(r.irr,  1.08.*ones([1 length(r.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
        plot(r.irr, -0.08.*ones([1 length(r.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
    end
    plot(1:t, y, '.', 'Color', [1 0.7 0]); % responses
    
    title({'Response y (orange), input cue (black) and input advice (green)'; ...
        ''; ['Posterior expectation of cue s(\mu_2) (red) for \omega cue=', ...
        num2str(r.p_prc.om_r), ' and of advice s(\mu_2) (magenta)  \omega advice=', num2str(r.p_prc.om_a), ...
        ' with advice weight \zeta =' num2str(r.p_obs.ze1)]; ['With additional parameters \kappa cue=', ...
        num2str(r.p_prc.ka_r), ', \kappa advice=', num2str(r.p_prc.ka_a), ' and \vartheta cue=', ...
        num2str(r.p_prc.th_r), ', \vartheta advice=', num2str(r.p_prc.th_a)]}, ...
        'FontWeight', 'bold');
    ylabel('y, u, s(\mu_2)');
    axis([0 t -0.15 1.15]);
else
    title(['Input cue (black), advice (green) and posterior expectation of input s(\mu_2) (red) for \zeta=', ...
        num2str(r.p_prc.om_r), ', \omega advice=', num2str(r.p_prc.om_a),'for \kappa cue=', ...
        num2str(r.p_prc.ka_r), ', \kappa advice=', num2str(r.p_prc.ka_a), ' and \vartheta cue=', ...
        num2str(r.p_prc.th_r), ', \vartheta advice=', num2str(r.p_prc.th_a) ], ...
        'FontWeight', 'bold');
    ylabel('u, s(\mu_2)');
    axis([0 t -0.1 1.1]);
end
plot(1:t, 0.5, 'k');
xlabel('Trial number');

%%
subplot(3,1,3);
advice_card_space = r.u(:,3);
x_a                  = r.traj.muhat_a(:,2);
x_r                  = r.traj.muhat_r(:,2);
transformed_x_r      = x_r.^advice_card_space.*(-1.*x_r).^(1-advice_card_space);
sa2hat_a = r.traj.sahat_a(:,2);
sa2hat_r = r.traj.sahat_r(:,2);
px       = 1./sa2hat_a;
pc       = 1./sa2hat_r;
ze1      = r.p_obs.ze1;
wx       = ze1.*px./(ze1.*px + pc);
wc       = pc./(ze1.*px + pc);
mu2b          = wx.*x_a + wc.*transformed_x_r;
b             = tapas_sgm(mu2b,1);
pib           = 1./(b.*(1-b));
alpha         = sgm((pib-4),1);
predict_wager = (2.*alpha -1).*10;
plot(predict_wager, 'k'); % wagers
hold on;
plot(r.y(:,2), 'g'); % wagers
xlabel('Trial number');
hold off;
