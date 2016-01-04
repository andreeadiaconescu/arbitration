function c = softmax_reward_social_magnitude_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the Softmax reward and social learning observation model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ

% Zeta is in logit space, while Beta is in log space.
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'softmax_reward_social';

% Sufficient statistics of Gaussian parameter priors

%%%%% Advice model (Jen Cook July 2015)
% % Zeta is in log-space
% c.logze1mu = -log(0);
% c.logze1sa = 0;
% 
% % Beta
% c.logbetamu = log(48);
% c.logbetasa = 1;

% %%%%% Cue model (Jen Cook July 2015)
% % Zeta is in log-space
% c.logze1mu = log(0);
% c.logze1sa = 0;
% 
% % Beta
% c.logbetamu = log(48);
% c.logbetasa = 1;


% % %%%%% Balanced model (Jen Cook July 2015)
% % Zeta is in log-space
% c.logze1mu = 0;
% c.logze1sa = 1;
% 
% % Beta
% c.logbetamu = log(48);
% c.logbetasa = 1;

% %%%%% For trial checking (Jen Cook Sept 2015)
% Zeta is in log-space
c.logze1mu = log(20);
c.logze1sa = 1;

% Beta
c.logbetamu = log(48);
c.logbetasa = 1;

%%%%% pre-programmed parameters (by Andreea Diaconescu)
% % Zeta is in log-space
% c.logze1mu = log(0.5);
% c.logze1sa = 4^2;
% 
% % Beta
% c.logbetamu = log(48);
% c.logbetasa = 10^2;

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
c.obs_fun = @softmax_reward_social_magnitude;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @softmax_reward_social_transp;

return;
