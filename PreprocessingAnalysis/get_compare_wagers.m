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
AdviceUnstable      = ones(size(AdviceCodingUnstable,2),1) == AdviceCodingUnstable';

RewardCodingUnstable=[zeros(25,1)' ones(15,1)' ones(30,1)' ones(25,1)' zeros(25,1)' zeros(15,1)' zeros(25,1)'];
RewardUnstable      = ones(size(RewardCodingUnstable,2),1) == RewardCodingUnstable';

AdviceCodingStable = [ones(25,1)' ones(15,1)' zeros(30,1)' ones(25,1)' zeros(25,1)' ones(15,1)' zeros(25,1)'];
AdviceStable      = ones(size(AdviceCodingStable,2),1) == AdviceCodingStable';
RewardCodingStable = [ones(25,1)' zeros(15,1)' zeros(30,1)' zeros(25,1)' ones(25,1)' ones(15,1)' ones(25,1)'];
RewardStable      = ones(size(RewardCodingStable,2),1) == RewardCodingStable';

for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    %%
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    actual_wager = zscore(est.y([2:end],2));
    predicted_wager = est.predicted_wager;
    
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

if doStats
    temp = cell2mat(par);
    
    [R,P,RLO,RUP]=corrcoef(temp(:,1),temp(:,5));
    figure;
    s = createWagerComparison(temp(:,1),temp(:,5),100,'c');
    s.LineWidth = 0.6;
    s.MarkerFaceColor = [0 0.5 0.5];
    % Create title
    title('Phase: Advice Stable');
    disp(['Significance correlation AStable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(temp(:,2),temp(:,6));
    figure;
    s = createWagerComparison(temp(:,2),temp(:,6),100,'m');
    title('Phase: Advice Unstable');
    disp(['Significance correlation AUnstable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(temp(:,3),temp(:,7));
    figure;
    s = createWagerComparison(temp(:,3),temp(:,7),100,'b');
    s.LineWidth = 0.6;
    s.MarkerFaceColor = [0 0.5 0.5];
    title('Phase: Card Stable');
    disp(['Significance correlation RStable ' num2str(P(1,2))]);
    %
    [R,P,RLO,RUP]=corrcoef(temp(:,4),temp(:,8));
    figure;
    s = createWagerComparison(temp(:,4),temp(:,8),100,'r');
    title('Phase: Card Unstable');
    disp(['Significance correlation RUnstable ' num2str(P(1,2))]);
    
end
save([paths.stats.secondLevel.covariates, '/wagers_actual_versus_predicted.mat'],'temp', '-mat');
end
