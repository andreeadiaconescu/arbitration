function logp = rw_softmax_reward_social_reward_magnitude(r, infStates, ptrans)
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, Andreea Diaconescu, TNU, UZH & ETHZ
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

x_a = infStates(:,1,2);
x_a(r.irr) = [];


y = r.y(:,1);
y(r.irr) = [];

% Precision (i.e., Fisher information) vectors
px = 1./(x_a.*(1-x_a));
pc = 1./(x_r.*(1-x_r));

% Weight vectors
%% Version 1
wx = ze1.*px./(ze1.*px + pc); % precision first level
wc = pc./(ze1.*px + pc);

% Belief vector
b = wx.*x_a + wc.*x_r;

if size(r.u,2) == 4
    r0 = r.u(:,3); % reward associated with card coded as 0
    r0(r.irr) = [];
    r1 = r.u(:,4); % reward associated with card coded as 1
    r1(r.irr) = [];
end

% Calculate log-probabilities for non-irregular trials
logp(not(ismember(1:length(logp),r.irr))) = y.*beta.*log(b./(1-b)) +log((1-b).^beta ./((1-b).^beta +b.^beta));
if size(r.u,2) == 4
    % Calculate log-probabilities for non-irregular trials
    logp(not(ismember(1:length(logp),r.irr))) = -log(1+exp(-beta.*(r1.*b-r0.*(1-x)).*(2.*y-1)));
end
return;
