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
    for iRsp=2
        %%
        parameters = {'ka_r','ka_a','th_r','th_a','ze','beta'};
        load(paths.fnFittedModel{iRsp},'est','-mat');
        ka_r=est.p_prc.ka_r;
        ka_a=est.p_prc.ka_a;
        th_r=est.p_prc.th_r;
        th_a=est.p_prc.th_a;
        
        ka_a=est.p_prc.ka_a;
        th_r=est.p_prc.th_r;
        th_a=est.p_prc.th_a;
        ze=est.p_obs.ze;
        beta=est.p_obs.be_ch;
        for j = 1:14
            par{nSubjects,j} = [];
        end
        par{s,1} = ka_r; % kappa reward
        par{s,2} = ka_a; % kappa advice
        par{s,3} = th_r; % theta reward
        par{s,4} = th_a; % theta advice
        par{s,5} = log(ze);   % zeta
        par{s,6} = beta; % decision noise
    end
end
if doStats
    temp = cell2mat(par);
    
    % Zeta
    figure; hist((temp(:,[5]))); hold on; stem(0);
    [h,p,ci,stats]=ttest((temp(:,5)),1);
    statsZeta=p;
    disp(['Significance paired t-test zeta ' num2str(statsZeta)]);
    
    % Differences in Kappa
    [h,p,ci,stats]=ttest(temp(:,1),temp(:,2));
    statsKappa=p;
    disp(['Significance paired t-test kappa ' num2str(statsKappa)]);
    figure; scatter(temp(:,1),temp(:,2));
    [R,P,RLO,RUP]=corrcoef(temp(:,1),temp(:,2));
    disp(['Significance correlation kappa' num2str(P(1,2))]);
    
    % Differences in Theta
    [h,p,ci,stats]=ttest(temp(:,3),temp(:,4));
    statsTheta=p;
    disp(['Significance paired t-test theta ' num2str(statsTheta)]);
    [R,P,RLO,RUP]=corrcoef(temp(:,3),temp(:,4));
    figure; scatter(temp(:,3),temp(:,4));
    disp(['Significance correlation theta' num2str(P(1,2))]);
    
    diffParameters=[temp(:,2)-temp(:,1) temp(:,4)-temp(:,3) temp(:,5) temp(:,6)];
    
    MAPparameters = [iSubjectArray' temp];
    parMean=num2str(mean(diffParameters));
    disp(['Parameter Mean Difference: ', parMean])
    parSTD=num2str(mean(temp));
    disp(['Parameter Mean: ', parSTD])
end
save([paths.stats.secondLevel.covariates, '/covariates_model2.mat'],'MAPparameters', '-mat');
end

