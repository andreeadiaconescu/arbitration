function [predicted_wager] = calculate_predicted_wager(est,paths)
%% Inferred states
mu1hat_a = est.traj.muhat_a(:,1);
mu1hat_r = est.traj.muhat_r(:,1);
mu2hat_a = est.traj.muhat_a(:,2);
mu2hat_r = est.traj.muhat_r(:,2);
sa2hat_r = est.traj.sahat_r(:,2);
sa2hat_a = est.traj.sahat_a(:,2);
mu3hat_r = est.traj.muhat_r(:,3);
mu3hat_a = est.traj.muhat_a(:,3);
ze       = est.p_obs.ze;
advice_card_space = est.u(:,3);
% Transform the card colour
transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);

%% Belief Vector
% Precision 1st level (i.e., Fisher information) vectors
px = 1./(mu1hat_a.*(1-mu1hat_a));
pc = 1./(mu1hat_r.*(1-mu1hat_r));

% Weight vectors 1st level
wx = ze.*px./(ze.*px + pc); % precision first level
wc = pc./(ze.*px + pc);

% Belief
b              = wx.*mu1hat_a + wc.*transformed_mu1hat_r;

original_models = paths.origModels;

if original_models == true
    
    % Precision of the Bernoulli Vector
    pib = 1./(b.*(1-b));
    
    % Calculate confidence
    alpha = tapas_sgm((pib-4),1);
    max_wager=10;
    
    % Calculate predicted wager
    predicted_wager            = zscore((2.*alpha -1).*max_wager+log(est.p_obs.be_wager));
    
else
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
    predicted_wager    = zscore(logrt); % wager from 1 to 10
end
end
