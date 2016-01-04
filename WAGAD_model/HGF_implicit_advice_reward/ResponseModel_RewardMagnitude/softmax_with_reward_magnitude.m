function logp = softmax_with_reward_magnitude(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the IOIO response model with constant
% weight zeta_1 taking into account reward magnitude
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform zeta to its native space
ze1 = exp(ptrans(1));
beta = exp(ptrans(2));

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
logp = NaN(length(infStates(:,1,1)),1);

% Check input format
if size(r.u,3) ~= 1 && size(r.u,2) ~= 4
    error('tapas:hgf:SoftMaxBinary:InputsIncompatible', 'Inputs incompatible with tapas_softmax_binary observation model. See tapas_softmax_binary_config.m.')
end

% Weed irregular trials out from inferred states, cue inputs, and responses
x_r = infStates(:,1,1);
x_r(r.irr) = [];

x_a = infStates(:,1,3);
x_a(r.irr) = [];

mu3_hat_r = infStates(:,3,1);
mu3_hat_r(r.irr) = [];

mu3_hat_a = infStates(:,3,3);
mu3_hat_a(r.irr) = [];

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
wx = ze1.*px./(ze1.*px + pc); % precision first level
wc = pc./(ze1.*px + pc);
%% Version 2
% wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
% wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);

%% Version 3
beta=exp(-mu3_hat_r)+exp(-mu3_hat_a);

%%
% Belief vector
b = wx.*x_a + wc.*x_r;

if size(r.u,2) == 4
    r0 = r.u(:,3);
    r0(r.irr) = [];
    r1 = r.u(:,4);
    r1(r.irr) = [];
end

% If input matrix has only two columns (one is the reward, the other the advice), assume the weight (reward value)
% of both options is equal to 1
if size(r.u,2) == 2
    % Calculate log-probabilities for non-irregular trials
    logp(not(ismember(1:length(logp),r.irr))) = -log(1+exp(-beta.*(2.*b-1).*(2.*y-1)));
end
% If input matrix has four columns, the third contains the weights of
% outcome 0 (i.e. reward magnitude of green card) and the forth contains
% the weights of outcome 1 (i.e., reward magnitude of blue card)
if size(r.u,2) == 4
    % Calculate log-probabilities for non-irregular trials
    logp(not(ismember(1:length(logp),r.irr))) = -log(1+exp(-beta.*(r1.*b-r0.*(1-x)).*(2.*y-1)));
end

return;