function get_compare_wagers(iSubjectArray, doStats)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%



% for WAGAD_0006, no physlogs were recorded

paths = get_paths_wagad(); % dummy subject to get general paths



if nargin < 1
    % manual setting...if you want to exclude any subjects
    iExcludedSubjects = [14 25 32 33 34 37];
    iSubjectArray = get_subject_ids(paths.data)';
    % manual setting...if you want to exclude any subjects
    iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);
end

if nargin < 2
    doStats = 1;
end


addpath(paths.code.model);
nSubjects = numel(iSubjectArray);

% Get task structure
AdviceCodingUnstable=[zeros(25,1)' zeros(15,1)' ones(30,1)' zeros(25,1)' ones(25,1)' zeros(15,1)' ones(25,1)'];
AdviceUnstable      = logical(paths.design.volatileAdvicePhase);

RewardCodingUnstable=[zeros(25,1)' ones(15,1)' ones(30,1)' ones(25,1)' zeros(25,1)' zeros(15,1)' zeros(25,1)'];
RewardUnstable      = logical(paths.design.volatileCardPhase);

AdviceCodingStable = [ones(25,1)' ones(15,1)' zeros(30,1)' ones(25,1)' zeros(25,1)' ones(15,1)' zeros(25,1)'];
AdviceStable      = logical(paths.design.stableAdvicePhase);
RewardCodingStable = [ones(25,1)' zeros(15,1)' zeros(30,1)' zeros(25,1)' ones(25,1)' ones(15,1)' ones(25,1)'];
RewardStable      = logical(paths.design.stableCardPhase);

for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    %%
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    actual_wager = zscore(est.y([2:end],2));
    predicted_wager = est.predicted_wager(1:end-1);
    
    actual_wager_aStable = mean(actual_wager(AdviceStable(2:end)));
    actual_wager_aUnstable = mean(actual_wager(AdviceUnstable(2:end)));
    actual_wager_rStable = mean(actual_wager(RewardStable(2:end)));
    actual_wager_rUnstable = mean(actual_wager(RewardUnstable(2:end)));
    
    predicted_wager_aStable = mean(predicted_wager(AdviceStable(2:end)));
    predicted_wager_aUnstable = mean(predicted_wager(AdviceUnstable(2:end)));
    predicted_wager_rStable = mean(predicted_wager(RewardStable(2:end)));
    predicted_wager_rUnstable = mean(predicted_wager(RewardUnstable(2:end)));
    
    par{s,1} = actual_wager_aStable;
    par{s,2} = actual_wager_aUnstable;
    par{s,3} = actual_wager_rStable;
    par{s,4} = actual_wager_rUnstable;
    
    par{s,5} = predicted_wager_aStable;
    par{s,6} = predicted_wager_aUnstable;
    par{s,7} = predicted_wager_rStable;
    par{s,8} = predicted_wager_rUnstable;
    
end

%% plot them
nPhases = 4;
colourArray    = {'c', 'm', 'b', 'r'};
yLabelArray    = {'Phase: Advice Stable','Phase: Advice Volatile','Phase: Reward Stable','Phase: Reward Volatile'};
xLimitArray    = {[-0.4 0.8], [-0.8 0.45], [-0.4 0.6],[-0.6 0.8]};
yLimitArray    = {[-0.4 0.8], [-0.8 0.45], [-0.4 0.6],[-0.6 0.8]};

variables      = cell2mat(par);

for iWager = 1:nPhases
    subplot(2,2,iWager);
    X = variables(:,iWager);
    Y = variables(:,iWager + nPhases);
    
    regressionMatrix       = [X ones(size(X))];
    B                      = regressionMatrix\Y;
    [R,P]                  = corrcoef(X,Y);
    
    
    pValueArray(iWager)        = P(1,2);
    slopeArray(iWager)         = R(1,2);
    
    scatter(X, Y, [],'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',colourArray{iWager},...
        'LineWidth',2);
    hold all;
    plot(X, B(1)*X+B(2), '-k');
    title(sprintf(yLabelArray{iWager}));
    xlabel(sprintf('z(Actual Wager)'));
    ylabel(sprintf('z(Predicted Wager)'));
    xlim(xLimitArray{iWager});
    ylim(yLimitArray{iWager});
    set(gca,'FontName','Constantia','FontSize',30);
end

%% stats
if doStats
    [R,P,RLO,RUP]=corrcoef(variables(:,1),variables(:,5));
    s = createWagerComparison(variables(:,1),variables(:,5),100,'c');
    s.LineWidth = 0.6;
    s.MarkerFaceColor = [0 0.5 0.5];
    % Create title
    title('Phase: Advice Stable');
    disp(['Correlation AStable ' num2str(R(1,2))]);
    disp(['Significance correlation AStable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(variables(:,2),variables(:,6));
    s = createWagerComparison(variables(:,2),variables(:,6),100,'m');
    title('Phase: Advice Unstable');
    disp(['Correlation AUnstable ' num2str(R(1,2))]);
    disp(['Significance correlation AUnstable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(variables(:,3),variables(:,7));
    s = createWagerComparison(variables(:,3),variables(:,7),100,'b');
    s.LineWidth = 0.6;
    s.MarkerFaceColor = [0 0.5 0.5];
    title('Phase: Card Stable');
    disp(['Correlation RStable ' num2str(R(1,2))]);
    disp(['Significance correlation RStable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(variables(:,4),variables(:,8));
    s = createWagerComparison(variables(:,4),variables(:,8),100,'r');
    title('Phase: Card Unstable');
    disp(['Correlation RUnstable ' num2str(R(1,2))]);
    disp(['Significance correlation RUnstable ' num2str(P(1,2))]);
    save([paths.stats.secondLevel.covariates, '/wagers_actual_versus_predicted.mat'],'variables', '-mat');
end
end
