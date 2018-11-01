function logp = linear_1stlevelarbitration_reward_social(r, infStates, ptrans)
% Calculates the log-probability of choices and wagers in the arbitration
% task developed by Diaconescu, Stecy, Stephan and Tobler, 2015-2017
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2014 Christoph Mathys, UCL; adapted by Andreea Diaconescu
% for WAGAD paper
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform parameters to their native space
be0       = ptrans(1);
be1       = ptrans(2);
be2       = ptrans(3);
% be3       = ptrans(4);
% be4       = ptrans(5);
% be5       = ptrans(6);
% be6       = ptrans(7);
ze        = exp(ptrans(4)); % social bias
be_ch     = exp(ptrans(5)); % decision noise for choice
be_wager  = exp(ptrans(6));% noise wager

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
logp_ch = NaN(length(infStates),1);
logp_wager = NaN(length(infStates),1);
logp = NaN(length(infStates),1);

% Weed irregular trials out from responses and inputs
y = r.y(:,1);
y(r.irr) = [];

u = r.u(:,1);
u(r.irr) = [];

advice_card_space = r.u(:,3);

% Extract trajectories of interest from infStates
mu1hat_a = infStates(:,1,3);
mu1hat_a(r.irr) = [];
mu1hat_r = infStates(:,1,1);
mu1hat_r(r.irr) = [];
mu2hat_a = infStates(:,2,3);
mu2hat_a(r.irr) = [];
mu2hat_r = infStates(:,2,1);
mu2hat_r(r.irr) = [];
sa2hat_r = infStates(:,2,2);
sa2hat_r(r.irr) = [];
sa2hat_a = infStates(:,2,4);
sa2hat_a(r.irr) = [];
mu3hat_r = infStates(:,3,1);
mu3hat_r(r.irr) = [];
mu3hat_a = infStates(:,3,3);
mu3hat_a(r.irr) = [];

% Transform the card colour
transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);

% Decisions
y_ch = r.y(:,1);
y_ch(1,:) = []; % Remove the first trial since it is not cued by the card
y_ch(r.irr) = [];

% Calculate log-probabilities for non-irregular trials
y_wager = r.y(:,2);
y_wager(1,:) = []; % Remove the first trial since it is not cued by the card
y_wager(r.irr) = [];

%% Belief Vector
% Precision 1st level (i.e., Fisher information) vectors
px = 1./(mu1hat_a.*(1-mu1hat_a));
pc = 1./(mu1hat_r.*(1-mu1hat_r));

% Weight vectors 1st level
wx = ze.*px./(ze.*px + pc); % precision first level
wc = pc./(ze.*px + pc);

% Belief and Choice Noise
b              = wx.*mu1hat_a + wc.*transformed_mu1hat_r;
decision_noise = exp((-mu3hat_r)+(-mu3hat_a)-log(be_ch));

% Precision of the Bernoulli Vector
pib = 1./(b.*(1-b));

% Arbitration
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arbitration = wx;

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt = be0 + be1.*pib + be2.*arbitration;
wager = logrt;

% Calculate log-probabilities for non-irregular trials
% Note: 8*atan(1) == 2*pi (this is used to guard against
% errors resulting from having used pi as a variable).
logp_ch(not(ismember(1:length(logp_ch),r.irr)))         = y_ch.*decision_noise.*log(b./(1-b)) +log((1-b).^decision_noise ./((1-b).^decision_noise +b.^decision_noise));
logp_wager(~ismember(1:length(logp),r.irr))             = -1/2.*log(8*atan(1).*be_wager) -(y_wager-wager).^2./(2.*be_wager);
logp(not(ismember(1:length(logp),r.irr)))               = logp_ch + logp_wager; 

return;
