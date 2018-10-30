function c = softmax_social_bias_precision_reward_social_config
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
c.model = 'softmax_social_bias_precision_reward_social';

% Sufficient statistics of Gaussian parameter priors


% Zeta is in log-space
c.logzemu = log(2.7183);
c.logzesa = 5^2;

% be_ch in log-space
c.logbe_chmu = log(48);
c.logbe_chsa = 1;

% Decision noise wager in log-space
c.logbe_wagermu = log(5);
c.logbe_wagersa = 10^3;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.logbe_chmu,...
    c.logbe_wagermu,...
    ];

c.priorsas = [
    c.logzesa,...
    c.logbe_chsa,...
    c.logbe_wagersa,...
    ];


% Model filehandle
c.obs_fun = @softmax_social_bias_precision_reward_social;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @softmax_social_bias_precision_reward_social_transp;

return;
