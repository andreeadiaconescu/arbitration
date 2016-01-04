function logp = softmax_reward_social(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the IOIO response model with constant
% weight zeta_1
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform zetas to their native space
ze1 = exp(ptrans(1));
beta = exp(ptrans(2));

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
logp = NaN(length(infStates),1);

% Weed irregular trials out from inferred states, cue inputs, and responses
x_r = infStates(:,1,1);
x_r(r.irr) = [];

x_a = infStates(:,1,3);
x_a(r.irr) = [];

sa2hat_r = infStates(:,2,2);
sa2hat_r(r.irr) = [];

sa2hat_a = infStates(:,2,4);
sa2hat_a(r.irr) = [];

y = r.y(:,1);
y(r.irr) = [];

% Precision (i.e., Fisher information) vectors
px = 1./(x_a.*(1-x_a));
pc = 1./(x_r.*(1-x_r));

% Weight vectors
%% Version 1
% wx = ze1.*px./(ze1.*px + pc); % precision first level
% wc = pc./(ze1.*px + pc);
%% Version 2
wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);


%%
%% Version 3
beta=exp(-mu3_hat_r)+exp(-mu3_hat_a)+exp(log(beta));

% Belief vector
b = wx.*x_a + wc.*x_r;

% Calculate log-probabilities for non-irregular trials
logp(not(ismember(1:length(logp),r.irr))) = y.*beta.*log(b./(1-b)) +log((1-b).^beta ./((1-b).^beta +b.^beta));

return;
