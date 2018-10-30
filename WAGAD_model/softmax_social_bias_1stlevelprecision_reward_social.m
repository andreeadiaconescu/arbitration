function logp = softmax_social_bias_1stlevelprecision_reward_social(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the IOIO response model with constant
% weight zeta_1
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Andreea Diaconescu, Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform zetas to their native space
ze  = exp(ptrans(1));
be_ch = exp(ptrans(2));
be_wager  = exp(ptrans(3));

% Initialize returned log-probabilities (choice) as NaNs so that NaN is
% returned for all irregular trials
logp_ch = NaN(length(infStates),1);
logp_wager = NaN(length(infStates),1);
logp = NaN(length(infStates),1);

% Weed irregular trials out from inferred states, cue inputs, and responses
u = r.u(:,1);
u(r.irr) = [];

advice_card_space = r.u(:,3);

mu1hat_a = infStates(:,1,3);
mu1hat_a(r.irr) = [];

mu1hat_r = infStates(:,1,1);
mu1hat_r(r.irr) = [];

% Transform the card colour
transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);

mu3hat_r = infStates(:,3,1);
mu3hat_r(r.irr) = [];

mu3hat_a = infStates(:,3,3);
mu3hat_a(r.irr) = [];

y_ch = r.y(:,1);
y_ch(1,:) = []; % Remove the first trial since it is not cued by the card
y_ch(r.irr) = [];

%% Precision 1st level (i.e., Fisher information) vectors
px = 1./(mu1hat_a.*(1-mu1hat_a));
pc = 1./(mu1hat_r.*(1-mu1hat_r));

% Weight vectors 1st level
wx = ze.*px./(ze.*px + pc); % precision first level
wc = pc./(ze.*px + pc);

%% Belief Vector
b              = wx.*mu1hat_a + wc.*transformed_mu1hat_r;
decision_noise =exp((-mu3hat_r)+(-mu3hat_a)-log(be_ch));

%% Precision of the Bernoulli Vector
pib = 1./(b.*(1-b));

% Calculate confidence
alpha = tapas_sgm((pib-4),1);
max_wager=10;

% Calculate predicted wager
rs_wager            = (2.*alpha -1).*max_wager+log(be_wager);
decision_noise_wager=be_wager;


% Calculate log-probabilities for non-irregular trials
y_wager = r.y(:,2);
y_wager(1,:) = []; % Remove the first trial since it is not cued by the card
y_wager(r.irr) = [];

logp_ch(not(ismember(1:length(logp_ch),r.irr)))         = y_ch.*decision_noise.*log(b./(1-b)) +log((1-b).^decision_noise ./((1-b).^decision_noise +b.^decision_noise));
logp_wager(not(ismember(1:length(logp_wager),r.irr)))   = -1/2.*log(8*atan(1).*decision_noise_wager) -(y_wager-rs_wager).^2./(2.*decision_noise_wager);
logp(not(ismember(1:length(logp),r.irr)))               = logp_ch + logp_wager; 


return;
