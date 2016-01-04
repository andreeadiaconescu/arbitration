function c = rw_softmax_reward_social_reward_magnitude_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for softmax function to be mapped to the RW
% model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'rw_softmax_social_reward_magnitude';

% Sufficient statistics of Gaussian parameter priors

% Zeta is in log-space
c.logze1mu = log(20);
c.logze1sa = 1;

% Beta
c.logbetamu = log(48);
c.logbetasa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logze1mu,...
    c.logbetamu,...
         ];

c.priorsas = [
    c.logze1sa,...
    c.logbetasa,...
         ];

% Model filehandle
c.obs_fun = @rw_softmax_social_reward_magnitude;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @rw_softmax_social_reward_magnitude_transp;

return;
