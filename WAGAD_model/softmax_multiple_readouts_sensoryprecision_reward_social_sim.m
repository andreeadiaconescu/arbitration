function [y, prob] = softmax_multiple_readouts_sensoryprecision_reward_social_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

x_r = infStates(:,1,1);
x_a = infStates(:,1,3);

mu3_hat_r = infStates(:,3,1);
mu3_hat_a = infStates(:,3,3);
sa2hat_r = infStates(:,2,2);
sa2hat_a = infStates(:,2,4);

ze1 = p(1);
beta = p(2);

decision_noise=exp(-mu3_hat_r)+exp(-mu3_hat_a)+exp(log(beta));


% Precision (i.e., Fisher information) vectors
px = 1./(x_a.*(1-x_a));
pc = 1./(x_r.*(1-x_r));

%% Version 1
wx = ze1.*px./(ze1.*px + pc);
wc = pc./(ze1.*px + pc);

% %% Version 2
% wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
% wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);

% Belief vector
b = wx.*x_a + wc.*x_r;

% Apply the unit-square sigmoid to the inferred states
prob = b.^(decision_noise)./(b.^(decision_noise)+(1-b).^(decision_noise));
n = length(b);
pib = 1./(b.*(1-b));
alpha = tapas_sgm((pib-4),1);
max_wager=13.74;

% Calculate Predicted Wager
rs_wager = (max_wager./max(alpha).*alpha)-4;

y(:,1) = binornd(1, prob);
y(:,2) = rs_wager+sqrt(decision_noise).*(1.5*randn(n, 1));


return;
