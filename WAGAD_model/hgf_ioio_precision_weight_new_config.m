function c = hgf_ioio_precision_weight_new_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the IOIO precision weight observation model
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
c.model = 'hgf_ioio_precision_weight_new';

% Sufficient statistics of Gaussian parameter priors

% Zeta_1
c.logze1mu = log(1);
c.logze1sa = 1;

% Zeta_2
c.logze2mu = log(2);
c.logze2sa = 6;

% Gather prior settings in vectors
c.priormus = [
    c.logze1mu,...
    c.logze2mu,...
         ];

c.priorsas = [
    c.logze1sa,...
    c.logze2sa,...
         ];

% Model filehandle
c.obs_fun = @hgf_ioio_precision_weight_new;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @hgf_ioio_precision_weight_new_transp;

return;
