function wagad_analyze_probe(iSubjectArray)
% regress_probe
% ===============
% expects a matrix of subject's specifig ratings of the adviser's
% intentions
% the size of the RatingMatrix: (nSubjects,nProbeQuestions) %%For SIX probe responses
% the size of the Mu1hatMatrix: (nSubjects,nProbeQuestions)

% Sigle-subject level GLM where Y represents the behavioural probe answers are x
% and X are the Mu1hat_Advice Values from the time the Probe was shown 
% Andreea Diaconescu July 2012/2019

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

subjectIds = iSubjectArray';
variables_wager = cell(nSubjects, 1); % 16 is the number of nonmodel-based variables
behaviour_wager = cell(nSubjects, 1); % 16 is the number of nonmodel-based variables

figure;

for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    tmp = load(paths.winningModel,'est','-mat'); % Select the winning model only;
    
    mu1hatAdviceSelected        = [tmp.est.traj.muhat_a(1,1) tmp.est.traj.muhat_a(14,1),...
                                   tmp.est.traj.muhat_a(49,1) tmp.est.traj.muhat_a(73,1),...
                                   tmp.est.traj.muhat_a(110,1)];
    variables_wager{iSubject,1} = mu1hatAdviceSelected;
end

for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    tmp = load(paths.fnBehavMatrix);
    behaviour_wager{iSubject,1} = tmp.behaviour_variables.probe;
end

y = cell2mat(variables_wager);
x = cell2mat(behaviour_wager);

for s=1:size(y,1), mybeta(s,:) = regress(y(s,:)', [x(s,:)', ones(size(y,2),1)]); end;
for s=1:size(y,1), beta2(s,:) = regress(y(s,:)', [x(s,:)']); end;
[H, P, CI, STATS] = ttest(mybeta(:,1));

resultsProbe.pValue = P;
resultsProbe.tstat  = STATS.tstat;
resultsProbe.df     = STATS.df;

disp(resultsProbe);

figure;for s=1:size(y,1), subplot(7,7,s); plot(x(s,:)', y(s,:)','*'); 
    hold all; plot(0:0.01:1, mybeta(s,2)+mybeta(s,1)*[0:0.01:1]');
    axis([-0.05 1.05 -0.05 1.05]);
    xlabel('$$\hat{\mu}_1$$', 'Interpreter', 'Latex');
    ylabel('category'); 
    title(sprintf('WAGAD %d',iSubjectArray(s)));
end


end