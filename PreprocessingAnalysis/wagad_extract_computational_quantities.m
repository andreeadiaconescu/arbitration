function [wager_computational_quantities] = wagad_extract_computational_quantities(est)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First: Arbitration (Precision Ratio),
% Advice Prediction (Mu1hat_A), Reward Prediction (Mu1hat_R)
% Time-Locked to Prediction Phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st level precision
px       = 1./est.est.traj.sahat_a(:,1);
pc       = 1./est.est.traj.sahat_r(:,1);
wx       = px./(px + pc);
wc       = pc./(px + pc);
mu1hat_r = est.est.traj.muhat_r(:,1);
mu1hat_a = est.est.traj.muhat_a(:,1);

advice_card_space    = est.est.u(:,3);
transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);
b                    = wx.*mu1hat_a + wc.*transformed_mu1hat_r;

Social_weighting     = wx.*mu1hat_a;
Card_weighting       = wc.*mu1hat_r;
Arbitration          = wx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second: Wager (Belief Precision), Belief
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pib           = 1./(b.*(1-b));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Third: Social and Reward PEs
% Social and Reward Volatility PEs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Epsilon2_Advice       = est.est.traj.sa_a(:,2).*est.est.traj.da_a(:,1);
Epsilon2_Reward       = abs(est.est.traj.sa_r(:,2).*est.est.traj.da_r(:,1));
Epsilon3_Advice       = est.est.traj.sa_a(:,3).*est.est.traj.da_a(:,2);
Epsilon3_Reward       = est.est.traj.sa_r(:,3).*est.est.traj.da_r(:,2);

Predicted_wager       = zscore(est.est.predicted_wager(1:end));
Actual_wager          = zscore(est.est.y(1:end,2));

wager_computational_quantities = [Arbitration pib Social_weighting Card_weighting, ...
                                  Epsilon2_Advice Epsilon2_Reward Epsilon3_Advice Epsilon3_Reward Predicted_wager Actual_wager];

end