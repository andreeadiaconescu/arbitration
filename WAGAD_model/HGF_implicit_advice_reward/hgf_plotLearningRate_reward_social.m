function hgf_plotLearningRate_reward_social(r)
% Plots trajectories or learning rates after model inversion
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2013 Andreea Diaconescu TNU, UZH & ETHZ
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
subplot(2,1,1);

if plotsd3 == true
    upper3prior_r = r.p_prc.sa3r_0 +sqrt(r.p_prc.sa3r_0);
    lower3prior_r = r.p_prc.sa3r_0 -sqrt(r.p_prc.sa3r_0);
    upper3_r = [upper3prior_r; r.traj.r.traj.sahat_r(:,3).*1/2*r.p_prc.ka_r.*r.traj.w_r+sqrt(r.traj.sa_r(:,3))];
    lower3_r = [lower3prior_r; r.traj.r.traj.sahat_r(:,3).*1/2*r.p_prc.ka_r.*r.traj.w_r-sqrt(r.traj.sa_r(:,3))];
    
    upper3prior_a = r.p_prc.sa3a_0 +sqrt(r.p_prc.sa3a_0);
    lower3prior_a = r.p_prc.sa3a_0 -sqrt(r.p_prc.sa3a_0);
    upper3_a = [upper3prior_a; r.traj.r.traj.sahat_a(:,3).*1/2*r.p_prc.ka_a.*r.traj.w_a+sqrt(r.traj.sa_a(:,3))];
    lower3_a = [lower3prior_a; r.traj.r.traj.sahat_a(:,3).*1/2*r.p_prc.ka_a.*r.traj.w_a-sqrt(r.traj.sa_a(:,3))];
    
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
plot(0:t, [r.p_prc.sa3r_0; r.traj.sahat_r(:,3).*1/2*r.p_prc.ka_r.*r.traj.w_r], 'b', 'LineWidth', 2);
hold all;
plot(0, r.p_prc.sa3r_0, 'ob', 'LineWidth', 2); % prior

% advice
plot(0:t, [r.p_prc.sa3a_0; r.traj.sahat_a(:,3).*1/2*r.p_prc.ka_a.*r.traj.w_a], 'c', 'LineWidth', 2);
plot(0, r.p_prc.sa3a_0, 'ob', 'LineWidth', 2); % prior
xlim([0 t]);
title('Volatility cue-related learning rate (blue) and advice-related learning rate (cyan)', 'FontWeight', 'bold');
xlabel('Trial number');
ylabel('lr_3');

%%
subplot(2,1,2);
sa1hat_r=r.traj.muhat_r(:,1).*(1-r.traj.muhat_r(:,1));
sa1hat_a=r.traj.muhat_a(:,1).*(1-r.traj.muhat_a(:,1));

plot(0:t, [sgm(r.p_prc.sa2r_0, 1); r.traj.sahat_r(:,2).*sa1hat_r], 'r', 'LineWidth', 2);
hold all;
plot(0, sgm(r.p_prc.sa2r_0, 1), 'or', 'LineWidth', 2); % prior
plot(1:t, r.u(:,1), '*', 'Color', 'k'); % reward

plot(0:t, [sgm(r.p_prc.sa2a_0, 1); r.traj.sahat_a(:,2).*sa1hat_a], 'm', 'LineWidth', 2);
plot(0, sgm(r.p_prc.sa2a_0, 1), 'or', 'LineWidth', 2); % prior
plot(1:t, r.u(:,2), 'o', 'Color', [0 0.6 0]); % advice

if ~isempty(find(strcmp(fieldnames(r),'y'))) && ~isempty(r.y)
    y = r.y(:,1) -0.5; y = 1.16 *y; y = y +0.5; % stretch
    if ~isempty(find(strcmp(fieldnames(r),'irr')))
        y(r.irr) = NaN; % weed out irregular responses
        plot(r.irr,  1.08.*ones([1 length(r.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
        plot(r.irr, -0.08.*ones([1 length(r.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
    end
    plot(1:t, y, '.', 'Color', [1 0.7 0]); % responses
    title({'Response y (orange), input cue (black), input advice (green)';...
        '';['Value cue-related learning rate (red) for \omega cue=', ...
           num2str(r.p_prc.om_r), ', and advice-related learning rate (magenta)  \omega advice=', num2str(r.p_prc.om_a), ...
           ' with advice weight \zeta =' num2str(r.p_obs.ze1)]}, ...
      'FontWeight', 'bold');
  
    ylabel('y, u, lr_1');
    axis([0 t -0.15 1.15]);
else
    title(['Input cue (black) and advice (green) and Value cue-related learning rate (red) and advice-related learning rate (magenta) for \omega cue=', ...
           num2str(r.p_prc.om_r), ', \omega advice=', num2str(r.p_prc.om_a)], ...
      'FontWeight', 'bold');
    ylabel('u, lr_1');
    axis([0 t -0.1 1.1]);
end
plot(1:t, 0.5, 'k');
xlabel('Trial number');
hold off;
