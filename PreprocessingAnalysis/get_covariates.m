function get_covariates(iSubjectArray, doStats)
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

for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    %%
    parameters = {'ka_r','ka_a','th_r','th_a','ze','beta'};
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    ka_r=est.p_prc.ka_r;
    ka_a=est.p_prc.ka_a;
    th_r=est.p_prc.th_r;
    th_a=est.p_prc.th_a;
    
    ka_a=est.p_prc.ka_a;
    th_r=est.p_prc.th_r;
    th_a=est.p_prc.th_a;
    ze=est.p_obs.ze;
    beta=est.p_obs.be_ch;
    par{s,1} = ka_r; % kappa reward
    par{s,2} = ka_a; % kappa advice
    par{s,3} = th_r; % theta reward
    par{s,4} = th_a; % theta advice
    par{s,5} = log(ze);   % zeta
    par{s,6} = beta; % decision noise
end
if doStats
    temp = cell2mat(par);
    
    % Zeta
    figure; hist((temp(:,[5]))); hold on; stem(0);
    % Create xlabel
    xlabel('log(\zeta)');
    
    % Create ylabel
    ylabel('Count');
    
    [h,p,ci,stats]=ttest((temp(:,5)),0);
    statsZeta=p;
    disp(['Significance paired t-test zeta ' num2str(statsZeta)]);
    
    % Differences in Kappa
    [h,p,ci,stats]=ttest(temp(:,1),temp(:,2));
    statsKappa=p;
    disp(['Significance paired t-test kappa ' num2str(statsKappa)]);
    
    % Differences in Theta
    [h,p,ci,stats]=ttest(temp(:,3),temp(:,4));
    statsTheta=p;
    disp(['Significance paired t-test theta ' num2str(statsTheta)]);
    
    diffParameters=[temp(:,2)-temp(:,1) temp(:,4)-temp(:,3)];
    
    MAPparameters = [iSubjectArray' temp];
    parMean=num2str(mean(diffParameters));
    disp(['Parameter Mean Difference (Kappa & Theta): ', parMean])
    parSTD=num2str(mean(temp));
    disp(['Parameter Mean: ', parSTD])
end
save([paths.stats.secondLevel.covariates, '/covariates_model.mat'],'MAPparameters', '-mat');
end

