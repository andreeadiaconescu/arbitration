function [variables_all] = wagad_extract_parameters_create_table(iSubjectArray)

% for WAGAD_0006, no physlogs were recorded

paths = get_paths_wagad(); % dummy subject to get general paths



if nargin < 1
    % manual setting...if you want to exclude any subjects
    iExcludedSubjects = [14 25 32 33 34 37];
    iSubjectArray = get_subject_ids(paths.data)';
    % manual setting...if you want to exclude any subjects
    iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);
end


addpath(paths.code.model);
nSubjects = numel(iSubjectArray);


% pairs of perceptual and response model
Main_Parameters            = {'ka_r','ka_a','th_r','th_a',...
    'ze','beta'};
ResponseModel_Parameters   = {'be_surp','be_arbitration',...
    'beta_inferv_a','beta_inferv_r',...
    'beta_pv_a','beta_pv_r'};

subjectIds = iSubjectArray';
nParameters = [Main_Parameters';ResponseModel_Parameters'];
variables_wager = cell(nSubjects, numel(nParameters)); % 16 is the number of nonmodel-based variables

figure;

for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    tmp = load(paths.winningModel,'est','-mat'); % Select the winning model only;
    variables_wager{iSubject,1} = tmp.est.p_prc.ka_r;
    variables_wager{iSubject,2} = tmp.est.p_prc.ka_a;
    variables_wager{iSubject,3} = tmp.est.p_prc.th_r;
    variables_wager{iSubject,4} = tmp.est.p_prc.th_a;
    variables_wager{iSubject,5} = log(tmp.est.p_obs.ze);
    variables_wager{iSubject,6} = tmp.est.p_obs.be_ch;
    variables_wager{iSubject,7} = tmp.est.p_obs.be1;
    variables_wager{iSubject,8} = tmp.est.p_obs.be2;
    variables_wager{iSubject,9} = tmp.est.p_obs.be3;
    variables_wager{iSubject,10}= tmp.est.p_obs.be4;
    variables_wager{iSubject,11}= tmp.est.p_obs.be5;
    variables_wager{iSubject,12}= tmp.est.p_obs.be6;
    
    wagad_plot = tmp.est;
    colorsReward=jet(nSubjects);
    currColReward = colorsReward(iSubject,:);
    colorsAdvice=winter(nSubjects);
    currColAdvice = colorsReward(iSubject,:);
    colorsWager=copper(nSubjects);
    currColWager = colorsWager(iSubject,:);
    
    hgf_plot_rainbowsim(iSubject);
end

for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    tmp = load(paths.fnBehavMatrix);
    behaviour_wager{iSubject,1} = tmp.behaviour_variables.overall_perf_acc;
    behaviour_wager{iSubject,2} = tmp.behaviour_variables.overall_wager;
    behaviour_wager{iSubject,3} = tmp.behaviour_variables.cScore;
    behaviour_wager{iSubject,4} = tmp.behaviour_variables.take_adv_overall;
    
    behaviour_wager{iSubject,5} = tmp.behaviour_variables.AccuracyStableCard;
    behaviour_wager{iSubject,6} = tmp.behaviour_variables.AccuracyVolatileCard;
    behaviour_wager{iSubject,7} = tmp.behaviour_variables.AccuracyStableAdvice;
    behaviour_wager{iSubject,8} = tmp.behaviour_variables.AccuracyVolatileAdvice;
    
    behaviour_wager{iSubject,9} = tmp.behaviour_variables.AdviceStableCard;
    behaviour_wager{iSubject,10} = tmp.behaviour_variables.AdviceVolatileCard;
    behaviour_wager{iSubject,11} = tmp.behaviour_variables.AdviceStableAdvice;
    behaviour_wager{iSubject,12} = tmp.behaviour_variables.AdviceVolatileAdvice;
    
    behaviour_wager{iSubject,13} = tmp.behaviour_variables.WagerStableCard;
    behaviour_wager{iSubject,14} = tmp.behaviour_variables.WagerVolatileCard;
    behaviour_wager{iSubject,15} = tmp.behaviour_variables.WagerStableAdvice;
    behaviour_wager{iSubject,16} = tmp.behaviour_variables.WagerVolatileAdvice;
end

variables_all = [cell2mat(variables_wager) cell2mat(behaviour_wager)];
save(fullfile(paths.stats.secondLevel.covariates, 'MAP_estimates_winning_model_nonModelVariables.mat'), ...
    'variables_wager', '-mat');
ofile=fullfile(paths.stats.secondLevel.covariates,'MAP_estimates_winning_model_nonModelVariables.xlsx');

[R,P]=corrcoef(mean([behaviour_wager(:,[13:16])],2),behaviour_wager(:,3));
disp(['Correlation between amount wagered and total score? Pvalue: ' num2str(P(1,2))]);
stats.correlation_wager_score = R(1,2);
stats.correlationp_wager_score = P(1,2);
disp(stats);

columnNames = [{'iSubjectArray'}, Main_Parameters, ResponseModel_Parameters, ...
    {'performanceAccuracy','wager_end','cumulativeScore','takeAdvice',...
    'AccuracyStableCard','AccuracyVolatileCard','AccuracyStableAdvice','AccuracyVolatileAdvice',...
    'AdviceStableCard','AdviceVolatileCard','AdviceStableAdvice','AdviceVolatileAdvice',...
    'WagerStableCard','WagerVolatileCard','WagerStableAdvice','WagerVolatileAdvice'}];
t = array2table([num2cell(subjectIds) num2cell(variables_all)], ...
    'VariableNames', columnNames);
writetable(t, ofile);


function hgf_plot_rainbowsim(iSubject)
currColReward = colorsReward(iSubject,:);
currColAdvice = colorsAdvice(iSubject,:);
currColWager  = colorsWager(iSubject,:);

nTrials = size(wagad_plot.u,1);

% Subplots
%%
subplot(3,1,1);

% reward
plot(0:nTrials, [wagad_plot.p_prc.mu3r_0; wagad_plot.traj.mu_r(:,3)], 'Color', currColReward, 'LineWidth', 2);
hold all;
plot(0, wagad_plot.p_prc.mu3r_0, 'ob', 'Color', currColReward, 'LineWidth', 2); % prior

% advice
plot(0:nTrials, [wagad_plot.p_prc.mu3a_0; wagad_plot.traj.mu_a(:,3)], 'Color', currColAdvice , 'LineWidth', 2);
plot(0, wagad_plot.p_prc.mu3a_0, 'ob', 'Color', currColAdvice, 'LineWidth', 2); % prior
xlim([0 nTrials]);
title('Posterior expectation \mu_3 of log-volatility of tendency x_3 for cue (blue) and advice (cyan)', 'FontWeight', 'bold');
xlabel('Trial number');
ylabel('\mu_3');

%%
subplot(3,1,2);

plot(0:nTrials, [sgm(wagad_plot.p_prc.mu2r_0, 1); sgm(wagad_plot.traj.mu_r(:,2), 1)], 'Color', currColReward, 'LineWidth', 2);
hold all;
plot(0, sgm(wagad_plot.p_prc.mu2r_0, 1), 'or', 'Color', currColReward, 'LineWidth', 2); % prior
plot(1:nTrials, wagad_plot.u(:,1), '*', 'Color', 'k'); % reward


plot(0:nTrials, [sgm(wagad_plot.p_prc.mu2a_0, 1); sgm(wagad_plot.traj.mu_a(:,2), 1)], 'Color', currColAdvice, 'LineWidth', 2);
plot(0, sgm(wagad_plot.p_prc.mu2a_0, 1), 'or', 'Color', currColAdvice, 'LineWidth', 2); % prior
plot(1:nTrials, wagad_plot.u(:,2), 'o', 'Color', [0 0.6 0]); % advice

if ~isempty(find(strcmp(fieldnames(wagad_plot),'y'))) && ~isempty(wagad_plot.y)
    y = wagad_plot.y(:,1) -0.5; y = 1.16 *y; y = y +0.5; % stretch
    if ~isempty(find(strcmp(fieldnames(wagad_plot),'irr')))
        y(wagad_plot.irr) = NaN; % weed out irregular responses
        plot(wagad_plot.irr,  1.08.*ones([1 length(wagad_plot.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
        plot(wagad_plot.irr, -0.08.*ones([1 length(wagad_plot.irr)]), 'x', 'Color', [1 0.7 0], 'Markersize', 11, 'LineWidth', 2); % irregular responses
    end
    plot(1:nTrials, y, '.', 'Color', currColReward); % responses
    
    title({'Response y (orange), input cue (black) and input advice (green)'; ...
        ''; ['Posterior expectation of cue s(\mu_2) (red) for \omega cue=', ...
        num2str(wagad_plot.p_prc.om_r), ' and of advice s(\mu_2) (magenta)  \omega advice=', num2str(wagad_plot.p_prc.om_a), ...
        ' with advice weight \zeta =' num2str(wagad_plot.p_obs.ze)]; ['With additional parameters \kappa cue=', ...
        num2str(wagad_plot.p_prc.ka_r), ', \kappa advice=', num2str(wagad_plot.p_prc.ka_a), ' and \vartheta cue=', ...
        num2str(wagad_plot.p_prc.th_r), ', \vartheta advice=', num2str(wagad_plot.p_prc.th_a)]}, ...
        'FontWeight', 'bold');
    ylabel('y, u, s(\mu_2)');
    axis([0 nTrials -0.15 1.15]);
else
    title(['Input cue (black), advice (green) and posterior expectation of input s(\mu_2) (red) for \zeta=', ...
        num2str(wagad_plot.p_prc.om_r), ', \omega advice=', num2str(wagad_plot.p_prc.om_a),'for \kappa cue=', ...
        num2str(wagad_plot.p_prc.ka_r), ', \kappa advice=', num2str(wagad_plot.p_prc.ka_a), ' and \vartheta cue=', ...
        num2str(wagad_plot.p_prc.th_r), ', \vartheta advice=', num2str(wagad_plot.p_prc.th_a) ], ...
        'FontWeight', 'bold');
    ylabel('u, s(\mu_2)');
    axis([0 nTrials -0.1 1.1]);
end
plot(1:nTrials, 0.5, 'k');
xlabel('Trial number');

%%
subplot(3,1,3);
plot([wagad_plot.predicted_wager], 'Color', currColWager, 'LineWidth', 2); % predicted wagers
hold all;
xlabel('Trial number');
end
end


