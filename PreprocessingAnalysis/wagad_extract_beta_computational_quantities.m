function [wager_beta_computational_quantities] = wagad_extract_beta_computational_quantities(est)

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

Arbitration          = wx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second: Wager (Belief Precision), Belief
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uncertainty_Decision           = (b.*(1-b));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Third: Informational and Environmental Uncertainty Wager
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract trajectories of interest from infStates
sa2hat_r = est.est.traj.sahat_r(:,2);
sa2hat_a = est.est.traj.sahat_a(:,2);
mu2hat_r = est.est.traj.muhat_r(:,2);
mu2hat_a = est.est.traj.muhat_a(:,2);
mu3hat_r = est.est.traj.muhat_r(:,3);
mu3hat_a = est.est.traj.muhat_a(:,3);


inferv_a = tapas_sgm(mu2hat_a, 1).*(1 -tapas_sgm(mu2hat_a, 1)).*sa2hat_a; 
inferv_r = tapas_sgm(mu2hat_r, 1).*(1 -tapas_sgm(mu2hat_r, 1)).*sa2hat_r; 
pv_a = tapas_sgm(mu2hat_a, 1).*(1-tapas_sgm(mu2hat_a, 1)).*exp(mu3hat_a); 
pv_r = tapas_sgm(mu2hat_r, 1).*(1-tapas_sgm(mu2hat_r, 1)).*exp(mu3hat_r); 


wager_beta_computational_quantities = [Uncertainty_Decision Arbitration,...
                                      inferv_a inferv_r pv_a pv_r];

end