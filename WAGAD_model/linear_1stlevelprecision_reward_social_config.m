function c = linear_1stlevelprecision_reward_social_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the linear response model of choices and wagers in the arbitration
% task developed by Diaconescu, Stecy, Stephan and Tobler, 2015-2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2014 Christoph Mathys, UCL, adapted by Andreea Diaconescu
% for WAGAD
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


% Config structure
c = struct;

% Model name
c.model = 'linear_1stlevelprecision_reward_social';

% Sufficient statistics of Gaussian parameter priors
%
% Beta_0
c.be0mu = log(500); 
c.be0sa = 4;

% Beta_1
c.be1mu = 0;
c.be1sa = 4;

% Beta_2
c.be2mu = 0; 
c.be2sa = 4;

% Beta_3
c.be3mu = 0; 
c.be3sa = 4;

% Beta_4
c.be4mu = 0; 
c.be4sa = 4;

% Beta_5
c.be5mu = 0; 
c.be5sa = 4;

% Beta_6
c.be6mu = 0; 
c.be6sa = 4;

% Zeta is in log-space
c.logzemu = log(1);
c.logzesa = 5^2;

% Beta in log-space
c.logbe_chmu = log(48);
c.logbe_chsa = 1;

% Decision noise wager in log-space
c.logbe_wagermu = log(5);
c.logbe_wagersa = 10^3;

% Gather prior settings in vectors
c.priormus = [
    c.be0mu,...
    c.be1mu,...
    c.be2mu,...
    c.be3mu,...
    c.be4mu,...
    c.be5mu,...
    c.be6mu,...
    c.logzemu,...
    c.logbe_chmu,...
    c.logbe_wagermu,...
         ];

c.priorsas = [
    c.be0sa,...
    c.be1sa,...
    c.be2sa,...
    c.be3sa,...
    c.be4sa,...
    c.be5sa,...
    c.be6sa,...
    c.logzesa,...
    c.logbe_chsa,...
    c.logbe_wagersa,...
         ];

% Model filehandle
c.obs_fun = @linear_1stlevelprecision_reward_social;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @linear_1stlevelprecision_reward_social_transp;

return;
