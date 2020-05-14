function c = hgf_binary3l_reward_social_config(ptrans)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the Hierarchical Gaussian Filter (HGF) for binary inputs restricted
% to 3 levels, no drift, and no inputs at irregular intervals, in the absence of perceptual
% uncertainty.
%
%
% The HGF is the model introduced in
%
% Mathys C, Daunizeau J, Friston, KJ, and Stephan KE. (2011). A Bayesian foundation
% for individual learning under uncertainty. Frontiers in Human Neuroscience, 5:39.
%
% This file refers to BINARY inputs (Eqs 1-3 in Mathys et al., (2011));
% for continuous inputs, refer to hgf_config.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The HGF configuration consists of the priors of parameters and initial values. All priors are
% Gaussian in the space where the quantity they refer to is estimated. They are specified by their
% sufficient statistics: mean and variance (NOT standard deviation).
%
% Quantities are estimated in their native space if they are unbounded (e.g., omega). They are
% estimated in log-space if they have a natural lower bound at zero (e.g., sigma2).
%
% Kappa and theta are estimated in 'logit-space' because bounding them above (in addition to
% their natural lower bound at zero) is an effective means of preventing the exploration of
% parameter regions where the assumptions underlying the variational inversion (cf. Mathys et
% al., 2011) no longer hold.
%
% 'Logit-space' is a logistic sigmoid transformation of native space with a variable upper bound
% a>0:
%
% logit(x) = ln(x/(a-x)); x = a/(1+exp(-logit(x)))
%
% Parameters can be fixed (i.e., set to a fixed value) by setting the variance of their prior to
% zero. Aside from being useful for model comparison, the need for this arises whenever the scale
% and origin of x3 are arbitrary. This is the case if the observation model does not contain the
% representations mu3 and sigma3 from the third level. A choice of scale and origin is then
% implied by fixing the initial value mu3_0 of mu3 and either kappa or omega.
%
% Kappa and theta can be fixed to an arbitrary value by setting the upper bound to twice that
% value and the mean as well as the variance of the prior to zero (this follows immediately from
% the logit transform above).
%
% Fitted trajectories can be plotted by using the command
%
% >> hgf_binary3l_plotTraj(est)
%
% where est is the stucture returned by fitModel. This structure contains the estimated
% perceptual parameters in est.p_prc and the estimated trajectories of the agent's
% representations (cf. Mathys et al., 2011). Their meanings are:
%
%         est.p_prc.mu2_0      initial value of mu2
%         est.p_prc.sa2_0      initial value of sigma2
%         est.p_prc.mu3_0      initial value of mu3
%         est.p_prc.sa3_0      initial value of sigma3
%         est.p_prc.ka         kappa
%         est.p_prc.om         omega
%         est.p_prc.th         theta
%
%         est.traj.mu1         mu1
%         est.traj.sa1         sigma1
%         est.traj.mu2         mu2
%         est.traj.sa2         sigma2
%         est.traj.mu3         mu3
%         est.traj.sa3         sigma3
%         est.traj.mu1hat      prediction at the 1st level
%         est.traj.sa1hat      precision of prediction at the 1st level
%         est.traj.mu2hat      prediction at the 2nd level
%         est.traj.sa2hat      precision of prediction at the 2nd level
%         est.traj.mu3hat      prediction at the 3rd level
%         est.traj.sa3hat      precision of prediction at the 3rd level
%         est.traj.w2          weighting factor of informational and environmental uncertainty at the 2nd level
%         est.traj.da1         prediction error at the 1st level
%         est.traj.da2         prediction error at the 2nd level

% In this model, we have double of the trajectories and parameters as we
% are tracking two quantities over time: the rewards and the advice.
%
% Tips:
% - If you get implausible trajectories (e.g., huge jumps in mu3), try lowering the upper
%   bound on theta.
% - Alternatives are lowering the upper bound on kappa, if it is not fixed, or
%   adjusting the values of kappa or omega, if any of them is fixed.
% - If the negative free energy F cannot be calculated because the Hessian poses problems,
%   look at est.optim.H and fix the parameters that lead to NaNs.
% - Your guide to all these adjustments is the negative free energy F. Whenever F increases by at
%   least 3 across datasets, the adjustment was a good idea and can be justified by just this: F
%   increased, so you had a better model.
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu modified, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


% Config structure
c = struct;

% Model name
c.model = 'hgf_binary3l_reward_social';

% Upper bound for kappa and theta (lower bound is always zero)
c.kaub_r = 1;
c.thub_r = 1;
c.kaub_a = 1;
c.thub_a = 1;

% Sufficient statistics of Gaussian parameter priors

% Initial mu2
% Usually best kept fixed to 0 (neutral regarding inputs).
c.mu2r_0mu = 0;
c.mu2r_0sa = 0;
c.mu2a_0mu = 0;
c.mu2a_0sa = 0;

% Initial sigma2
c.logsa2r_0mu = log(1);
c.logsa2r_0sa = 0;
c.logsa2a_0mu = log(1);
c.logsa2a_0sa = 0;

% Initial mu3
% Usually best kept fixed to 1 (determines origin on x3-scale).
c.mu3r_0mu = 1;
c.mu3r_0sa = 0;
c.mu3a_0mu = 1;
c.mu3a_0sa = 0;

% Initial sigma3
c.logsa3r_0mu = log(1);
c.logsa3r_0sa = 0;
c.logsa3a_0mu = log(1);
c.logsa3a_0sa = 0;

% Kappa
% This should be fixed (preferably to 1) if the observation model
% does not use mu3 (kappa then determines the scaling of x3).
c.logitkamu_r = 0;
c.logitkasa_r = 0;
c.logitkamu_a = 0;
c.logitkasa_a = 0;

% Omega
c.ommu_r = -4;
c.omsa_r = 0;
c.ommu_a = -4;
c.omsa_a = 0;

% Theta, this is also fixed to 0.5
c.logitthmu_r = 0.25;
c.logitthsa_r = 0; % 
c.logitthmu_a = 0.25;
c.logitthsa_a = 0;

% Phis
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% Fix this to zero (-Inf in logit space) to set to zero.
c.logitphimu_r = tapas_logit(0.1,1);
c.logitphisa_r = 0;
c.logitphimu_a = tapas_logit(0.1,1);
c.logitphisa_a = 0;

% ms
% Format: row vector of length n_levels.
% This should be fixed for all levels where the omega of
% the next lowest level is not fixed because that offers
% an alternative parametrization of the same model.
c.mmu_r = c.mu3r_0mu;
c.msa_r = 0;
c.mmu_a = c.mu3a_0mu;
c.msa_a = 0;


% Gather prior settings in vectors
c.priormus = [
    c.mu2r_0mu,...
    c.logsa2r_0mu,...
    c.mu3r_0mu,...
    c.logsa3r_0mu,...
    c.logitkamu_r,...
    c.ommu_r,...
    c.logitthmu_r,...
    c.mu2a_0mu,...
    c.logsa2a_0mu,...
    c.mu3a_0mu,...
    c.logsa3a_0mu,...
    c.logitkamu_a,...
    c.ommu_a,...
    c.logitthmu_a,...
    c.logitphimu_r,...
    c.logitphimu_a,...
    c.mmu_r,...
    c.mmu_a];

c.priorsas = [
    c.mu2r_0sa,...
    c.logsa2r_0sa,...
    c.mu3r_0sa,...
    c.logsa3r_0sa,...
    c.logitkasa_r,...
    c.omsa_r,...
    c.logitthsa_r,...
    c.mu2a_0sa,...
    c.logsa2a_0sa,...
    c.mu3a_0sa,...
    c.logsa3a_0sa,...
    c.logitkasa_a,...
    c.omsa_a,...
    c.logitthsa_a,...
    c.logitphisa_r,...
    c.logitphisa_a,...
    c.msa_r,...
    c.msa_a];

% Model function handle
c.prc_fun = @hgf_binary3l_reward_social;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @hgf_binary3l_reward_social_transp;

return;
