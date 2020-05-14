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


for iSubject = 1:nSubjects
    iSubj = iSubjectArray(iSubject);
    paths = get_paths_wagad(iSubj);
    tmp = load(paths.winningModel,'est','-mat'); % Select the winning model only;
    
    mu1hatAdviceSelected        = [tmp.est.traj.muhat_a(2,1) tmp.est.traj.muhat_a(14,1),...
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


% Get probe structure
random              = [1 0, ...
                       0 0 0];
helpfulAdvicestableCard             = [0 1, ...
                       0 0 0];
helpfulAdviceunstableCard           = [0 1, ...
                       1 0 0];
                   
misleadingAdviceunstableCard          = [0 0, ...
                       0 1 0];
                   
misleadingAdvicestableCard          = [0 0, ...
                       0 0 1];

figure;
for s=1:size(y,1)   
    selectedChoice           = x(s,:);
    selectedModelReadout     = y(s,:);
    actualProbeRandom     = mean(selectedChoice(:,logical(random)));
    actualProbeHelpfulStable    = mean(selectedChoice(:,logical(helpfulAdvicestableCard)));
    actualProbeHelpfulUnstable    = mean(selectedChoice(:,logical(helpfulAdviceunstableCard)));
    actualProbeMisleadingUnstable = mean(selectedChoice(:,logical(misleadingAdviceunstableCard)));
    actualProbeMisleadingStable = mean(selectedChoice(:,logical(misleadingAdvicestableCard)));
    
    predictedProbeRandom     = mean(selectedModelReadout(:,logical(random)));
    predictedProbeHelpfulStable    = mean(selectedModelReadout(:,logical(helpfulAdvicestableCard)));
    predictedProbeHelpfulUnstable    = mean(selectedModelReadout(:,logical(helpfulAdviceunstableCard)));
    predictedProbeMisleadingUnstable = mean(selectedModelReadout(:,logical(misleadingAdviceunstableCard)));
    predictedProbeMisleadingStable = mean(selectedModelReadout(:,logical(misleadingAdvicestableCard)))
    
    par{s,1} = actualProbeRandom;
    par{s,2} = actualProbeHelpfulStable;
    par{s,3} = actualProbeHelpfulUnstable;
    par{s,4} = actualProbeMisleadingUnstable;
    par{s,5} = actualProbeMisleadingStable;
    
    par{s,6} = predictedProbeRandom;
    par{s,7} = predictedProbeHelpfulStable;
    par{s,8} = predictedProbeHelpfulUnstable;
    par{s,9} = predictedProbeMisleadingUnstable;
    par{s,10} = predictedProbeMisleadingStable;
end


%% plot them
nPhases = 5;
colourArray    = {'g','r','m','b','c'};
yLabelArray    = {'Initial Rating','Stable Advice/Stable Card','Stable Advice/Unstable Card', ...
                  'Unstable Advice/Unstable Card', 'Unstable Advice/Stable Card'};
xLimitArray    = {[0 1], [0 1],[0 1], [0 1], [0 1]};
yLimitArray    = {[-Inf Inf], [-Inf Inf],[-Inf Inf], [-Inf Inf],[-Inf Inf]};

variables      = cell2mat(par);


for iProbe = [2 3 4 5 1]
    subplot(3,2,iProbe);
    X = variables(:,iProbe);
    Y = variables(:,iProbe + nPhases);
    
    regressionMatrix       = [X ones(size(X))];
    B                      = regressionMatrix\Y;
    [R,P]                  = corrcoef(X,Y);
    
    pValueArray(iProbe)        = P(1,2);
    slopeArray(iProbe)         = R(1,2);
    
    scatter(X, Y, [],'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',colourArray{iProbe},...
        'LineWidth',2);
    hold all;
    plot(X, B(1)*X+B(2), '-k');
    axis square;
    title(sprintf(yLabelArray{iProbe}));
    xlim(xLimitArray{iProbe});
    ylim(yLimitArray{iProbe});
    xlabel(sprintf('Actual'));
    ylabel(sprintf('Predicted'));
    set(gca,'FontName','Constantia','FontSize',20);
end



end