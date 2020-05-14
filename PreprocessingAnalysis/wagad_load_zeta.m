function wagad_load_zeta(iSubjectArray,mode)

% for WAGAD_0006, no physlogs were recorded

paths = get_paths_wagad(1); % dummy subject to get general paths



if nargin < 1
    iSubjectArray =  setdiff([3:47], [14 25 31 32 33 34 37]);
end

if nargin < 2
    mode =  'experimental';
end

addpath(paths.code.model);
winningResponseModel    = 'linear_1stlevelprecision_reward_social_config';
winningPerceptualModel  = 'hgf_binary3l_reward_social_config';
nSubjects = numel(iSubjectArray);
lgh_a = cell(1,nSubjects);
lgstr = cell(1,nSubjects);
fh = [];
sh = [];

switch mode
    case 'simulated'
        for iSubject = 1:nSubjects
            iZetaArray = linspace(-10,10,40);
            iSubj = iSubjectArray(iSubject);
            paths = get_paths_wagad(iSubj);
            tmp = load(paths.winningModel,'est','-mat'); % Select the winning model only;
            sim = simModel(tmp.est.u,...
                winningPerceptualModel(1:end-7),...
                tmp.est.p_prc.p,winningResponseModel(1:end-7),...
                [tmp.est.p_obs.p(1:7) exp(iZetaArray(iSubject)) tmp.est.p_obs.p(9:end)]);
            zeta{iSubject}             = exp(sim.p_obs.ze);
            mu3_reward_wagad{iSubject} = [sim.p_prc.mu3r_0; sim.traj.mu_r(:,3)];
            mu1_reward_wagad{iSubject} = [sim.p_prc.mu2r_0; sim.traj.mu_r(:,2)];
            mu3_advice_wagad{iSubject} = [sim.p_prc.mu3a_0; sim.traj.mu_a(:,3)];
            mu1_advice_wagad{iSubject} = [sim.p_prc.mu2a_0; sim.traj.mu_a(:,2)];
            [simulatedPredicted_wager] = calculate_predicted_wager(sim,paths);
            wager_wagad{iSubject} = [1;simulatedPredicted_wager];
        end 
    case 'experimental'
        for iSubject = 1:nSubjects
            iSubj = iSubjectArray(iSubject);
            paths = get_paths_wagad(iSubj);
            tmp = load(paths.winningModel,'est','-mat'); % Select the winning model only;
            zeta{iSubject}              = exp(tmp.est.p_obs.ze);
            mu3_reward_wagad{iSubject} = [tmp.est.p_prc.mu3r_0; tmp.est.traj.mu_r(:,3)];
            mu1_reward_wagad{iSubject} = [tmp.est.p_prc.mu2r_0; tmp.est.traj.mu_r(:,2)];
            mu3_advice_wagad{iSubject} = [tmp.est.p_prc.mu3a_0; tmp.est.traj.mu_a(:,3)];
            mu1_advice_wagad{iSubject} = [tmp.est.p_prc.mu2a_0; tmp.est.traj.mu_a(:,2)];
            wager_wagad{iSubject}      = [1;tmp.est.predicted_wager];
        end
end

[B,I] = sort(cell2mat(zeta));
sorted_mu3_reward_wagad          = mu3_reward_wagad(I);
sorted_mu1_reward_wagad          = mu1_reward_wagad(I);
sorted_mu3_advice_wagad          = mu3_advice_wagad(I);
sorted_mu1_advice_wagad          = mu1_advice_wagad(I);
sorted_wager_wagad               = wager_wagad(I);
sorted_zeta                      = cell2mat(zeta(I))';

yhat3d1                        = reshape(sorted_mu3_reward_wagad,nSubjects,1);
yhat3d2                        = reshape(sorted_mu1_reward_wagad,nSubjects,1);
yhat3d3                        = reshape(sorted_mu3_advice_wagad,nSubjects,1);
yhat3d4                        = reshape(sorted_mu1_advice_wagad,nSubjects,1);
yhat3d5                        = reshape(sorted_wager_wagad,nSubjects,1);

trajectories = [yhat3d3,yhat3d4 yhat3d1,...
    yhat3d2 yhat3d5];
ColorScheme  = [copper(nSubjects) winter(nSubjects) jet(nSubjects) ...
    spring(nSubjects) jet(nSubjects)];
for iSubject = 1:nSubjects
    iTraj   = trajectories(iSubject,:);
    iZeta   = sorted_zeta(iSubject,1);
    iScheme = ColorScheme(iSubject,:);
    [fh, sh, lgh_a{iSubject}] = wagad_plot_trajectories(iSubject,iTraj,iScheme,fh,sh);
    lgstr{iSubject} = sprintf('\\zeta = %3.2f', iZeta);
end
legend(lgstr);
end
