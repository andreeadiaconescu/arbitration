function c = softmax_social_bias_precision_reward_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the Softmax reward and social learning observation model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ

%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'softmax_social_bias_precision_reward';

% Sufficient statistics of Gaussian parameter priors


% Zeta is in log-space
c.logze1mu = -realmax;
c.logze1sa = 0;

% Beta in log-space
c.logbetamu = log(48);
c.logbetasa = 1;

% Decision noise wager in log-space
c.logze3mu = log(5);
c.logze3sa = 10^3;

% Gather prior settings in vectors
c.priormus = [
    c.logze1mu,...
    c.logbetamu,...
    c.logze3mu,...
    ];

c.priorsas = [
    c.logze1sa,...
    c.logbetasa,...
    c.logze3sa,...
    ];


% Model filehandle
c.obs_fun = @softmax_social_bias_precision_reward_social;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @softmax_social_bias_precision_reward_social_transp;

return;
