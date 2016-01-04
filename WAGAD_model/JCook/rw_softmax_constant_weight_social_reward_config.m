function c = rw_softmax_constant_weight_social_reward_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the IOIO constant weight observation model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2015 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'rw_softmax_constant_weight_social_reward';

% Sufficient statistics of Gaussian parameter priors

% Zeta_1
c.logitze1mu = 0;
c.logitze1sa = 10^2;

% Zeta_2
c.logze2mu = log(48);
c.logze2sa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logitze1mu,...
    c.logze2mu,...
         ];

c.priorsas = [
    c.logitze1sa,...
    c.logze2sa,...
         ];

% Model filehandle
c.obs_fun = @rw_softmax_constant_weight_social_reward;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @rw_softmax_constant_weight_social_reward_transp;

return;
