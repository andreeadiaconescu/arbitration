function [variablesPerceptualModels] = wagad_simulate_from_empiricalData(iSubjectArray)
%IN
% analysis options
% OUT
% parameters of the winning model and all recovered parameters from
% simulating responses from the parameters of the winning model

if nargin < 1
    iSubjectArray = setdiff([3:47], [10 13 23 14 25 32 33 34 37]);
end

paths = get_paths_wagad(iSubjectArray(1));

% parameters and subjects
Parameters                 =  {'kappa_r','kappa_a','theta_r','theta_a'};
ResponseModelParameters    =  {'zeta','beta','sigma_1','xi','sigma_2a','sigma_2c','mu_3a','mu_3c'};
simParameters                 =  {'sim_kappa_r','sim_kappa_a','sim_theta_r','sim_theta_a'};
simResponseModelParameters    =  {'sim_zeta','sim_beta','sim_sigma_1','sim_xi','sim_sigma_2a','sim_sigma_2c','sim_mu_3a','sim_mu_3c'};

nParameters = numel([Parameters ResponseModelParameters]');
nSubjects = numel(iSubjectArray);
variables_wagad = cell(nSubjects, numel(nParameters));
simulated_wagad = cell(nSubjects, numel(nParameters));

% % Load seed for reproducible results
% rng('shuffle');
% state = rng;
File = fullfile(paths.code.project, 'RNGState.mat');
% save(File, 'state');
Data  = load(File);
state = Data.state;
rng(state);

winningResponseModel    = 'linear_1stlevelprecision_reward_social_config';
winningPerceptualModel  = 'hgf_binary3l_reward_social_config';
% pairs of perceptual and response model
[iCombPercResp] = wagad_get_model_space;

nModels = size(iCombPercResp,1);

for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    %%
    fileModel = fullfile(paths.winningModel);

    if ~exist(fileModel)
        get_model_inversion(iSubj)
    end
    est_wagad = load(paths.winningModel,'est','-mat'); % Select the winning model only
    sim = simModel(est_wagad.est.u,...
        winningPerceptualModel(1:end-7),...
        est_wagad.est.p_prc.p,winningResponseModel(1:end-7),est_wagad.est.p_obs.p);
    y_responses = sim.y;
    input_u     = sim.u;
    sim_wagad=fitModel(y_responses,input_u,paths.filePerceptualModels{iCombPercResp(1,1)},...
        paths.fileResponseModels{iCombPercResp(1,2)});
    variables_wagad{iSubject,1} = est_wagad.est.p_prc.ka_r;
    variables_wagad{iSubject,2} = est_wagad.est.p_prc.ka_a;
    variables_wagad{iSubject,3} = est_wagad.est.p_prc.th_r;
    variables_wagad{iSubject,4} = est_wagad.est.p_prc.th_a;
    variables_wagad{iSubject,5} = log(est_wagad.est.p_obs.ze);
    variables_wagad{iSubject,6} = est_wagad.est.p_obs.be_ch;
    variables_wagad{iSubject,7} = est_wagad.est.p_obs.be1;
    variables_wagad{iSubject,8} = est_wagad.est.p_obs.be2;
    variables_wagad{iSubject,9} = est_wagad.est.p_obs.be3;
    variables_wagad{iSubject,10} = est_wagad.est.p_obs.be4;
    variables_wagad{iSubject,11} = est_wagad.est.p_obs.be5;
    variables_wagad{iSubject,12} = est_wagad.est.p_obs.be6;

    simulated_wagad{iSubject,1} = sim_wagad.p_prc.ka_r;
    simulated_wagad{iSubject,2} = sim_wagad.p_prc.ka_a;
    simulated_wagad{iSubject,3} = sim_wagad.p_prc.th_r;
    simulated_wagad{iSubject,4} = sim_wagad.p_prc.th_a;
    simulated_wagad{iSubject,5} = log(sim_wagad.p_obs.ze);
    simulated_wagad{iSubject,6} = sim_wagad.p_obs.be_ch;
    simulated_wagad{iSubject,7} = sim_wagad.p_obs.be1;
    simulated_wagad{iSubject,8} = sim_wagad.p_obs.be2;
    simulated_wagad{iSubject,9} = sim_wagad.p_obs.be3;
    simulated_wagad{iSubject,10} = sim_wagad.p_obs.be4;
    simulated_wagad{iSubject,11} = sim_wagad.p_obs.be5;
    simulated_wagad{iSubject,12} = sim_wagad.p_obs.be6;
    
end

variables_all             = [cell2mat(variables_wagad) cell2mat(simulated_wagad)];
variablesPerceptualModels = [cell2mat(variables_wagad(:,[1:4])) cell2mat(simulated_wagad(:,[1:4]))];
variablesResponseModels = [cell2mat(variables_wagad(:,[5:end])) cell2mat(simulated_wagad(:,[5:end]))];
%% Save it
ofile=fullfile(paths.code.project,'wagad_empirical_simulations.xlsx');
subjects = iSubjectArray';
columnNames = [{'subjectIds'}, Parameters, ResponseModelParameters,simParameters, simResponseModelParameters];
t = array2table([num2cell(subjects) num2cell(variables_all)], ...
    'VariableNames', columnNames);
writetable(t, ofile);

%% Plot it
wagad_simulate_from_empiricalData_PerpPlot(variablesPerceptualModels);
wagad_simulate_from_empiricalData_RespPlot(variablesResponseModels);
end



