function r = simResponses(inputs_reward, inputs_advice, prc_model, prc_pvec, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the main function for simulating responses (or only perceptual states) from a combination
% of perceptual and observation models, given parameters and inputs.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE:
%     sim = simResponses(inputs_reward, inputs_advice, prc_model, prc_pvec, obs_model, obs_vec)
% 
% INPUT ARGUMENTS:
%     inputs             Array of inputs (column vector)
%
%                        To ignore the input of a trial, code the input as NaN. In this case,
%                        filtering is suspended for this trial and all representations (i.e.,
%                        inferences on hidden states) will remain constant.
%
%                        Note that an input is often a composite event, for example a cue-stimulus
%                        contingency. If the agent you are modeling is lerning such contingencies,
%                        inputs have to be coded in contingency space (e.g., blue cue -> reward as
%                        well as green cue -> no reward is coded as 1 while blue cue -> no reward as
%                        well as green cue -> reward is coded as 0). The same applies to responses.
%
%                        If needed for a specific application, inputs can be a matrix with further
%                        columns. The coding of ignored trials described above then applies to its
%                        first column.
%
%     prc_model          Your choice of perceptual model. Choices are:
%
%
%                        - 'hgf_binary3l_reward_social'      The binary Hierarchical Gaussian Filter (HGF) model,
%                                                            restricted to 3 levels, no drift and no inputs at
%                                                            irregular intervals, in the absence of perceptual
%                                                            uncertainty. 
%                                                       
%     prc_pvec           Row vector of perceptual model parameter values (see the corresponding model's
%                        configuration file).
%
%     obs_model          Your choice of observation model. Choices are:
%
%                        - 'softmax_reward_social'          Introducing parameter zeta that represents the weight of the advice. 
%                                                           The decision noise (beta) 
%                                                           drives the mapping(sigmoid transformation) of beliefs onto actions.
%                        
%            
%
% 
% OUTPUT:
%     sim.u              Input to agent (i.e., the inputs array from the
%                        arguments): 2 inputs the reward and the advice
%     sim.ign            Index numbers of ignored trials
%     sim.c_sim          Information on the models used in the simulation
%     sim.p_prc          The perceptual parameters as given in pvec_prc
%                        (see the configuration file of your chosen perceptual model for details)
%     sim.p_obs          The observation parameters as given in pvec_obs
%                        (see the configuration file of your chosen observation model for details)
%     sim.traj:          Trajectories of the environmental states tracked by the perceptual model
%                        (see the configuration file of that model for details)
%     sim.y              Simulated responses
%
% BACKGROUND:
%     In order to simulate perceptual states (and responses) in this framework, one has to choose a
%     perceptual model (and an observation model).
%
%     The perceptual model can for example be a Bayesian generative model of the states of an
%     agent's environment (like the Hierarchical Gaussian Filter (HGF)) or a reinforcement learning
%     algorithm (like Rescorla-Wagner (RW)). It describes the states or values that
%     probabilistically determine observed responses.
%
%     The observation model describes how the states or values of the perceptual model map onto
%     responses. Examples are the softmax decision rule or the closely related unit-square sigmoid
%     decision model.
%
%
% EXAMPLE:
%     sim = simResponses(inputs, 'hgf_binary3l_reward_social', [pararray], 'softmax_reward_social',[obsarray]);
%     hgf_plotTraj_reward_social
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, modified Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Check if inputs look like column vectors
if size(inputs_reward,1) <= size(inputs_reward,2)
    disp(' ')
    disp('Warning: ensure that input sequences are COLUMN vectors.')
end

% Initialize data structure to be returned
r = struct;

% Store inputs
r.u(:,1)  = inputs_reward;
r.u(:,2)  = inputs_advice;

% Determine ignored trials
ign = [];
for k = 1:size(r.u,1)
    if isnan(r.u(k,1))
        ign = [ign, k];
    end
end

r.ign = ign;

if isempty(ign)
    ignout = 'none';
else
    ignout = ign;
end
disp(['Ignored trials: ', num2str(ignout)])
    
% Remember perceptual model
r.c_sim.prc_model = prc_model;

% Store perceptual parameters
prc_namep_fun = str2func([prc_model, '_namep']);
r.p_prc   = prc_namep_fun(prc_pvec);
r.p_prc.p = prc_pvec;

% Get function handle to perceptual model
prc_fun = str2func(r.c_sim.prc_model);

% Compute perceptual states
[r.traj, infStates] = prc_fun(r, r.p_prc.p);

if nargin > 4
    
    % Remember observation model
    r.c_sim.obs_model = varargin{1};

    % Store observation parameters
    obs_pvec = varargin{2};
    obs_namep_fun = str2func([r.c_sim.obs_model, '_namep']);
    r.p_obs   = obs_namep_fun(obs_pvec);
    r.p_obs.p = obs_pvec;
    
    % Get function handle to observation model
    obs_fun = str2func([r.c_sim.obs_model, '_sim']);
    
    % Simulate decisions
    [r.y, r.y_prob] = obs_fun(r, infStates, r.p_obs.p);


end

return;
