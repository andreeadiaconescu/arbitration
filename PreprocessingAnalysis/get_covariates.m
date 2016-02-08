function get_covariates(iSubjectArray, doStats)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
iExcludedSubjects = [6 14 25 32 33 34 37];

% for WAGAD_0006, no physlogs were recorded 

paths = get_paths_wagad(); % dummy subject to get general paths

% manual setting...if you want to exclude any subjects
iSubjectArray = get_subject_ids(paths.data)';

if nargin < 1
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
    for iRsp=1
        %%
        parameters = {'ka_r','ka_a','th_r','th_a','ze','beta'};
        load(paths.fnFittedModel{iRsp},'est','-mat');
        ka_r=est.p_prc.ka_r;
        ka_a=est.p_prc.ka_a;
        th_r=est.p_prc.th_r;
        th_a=est.p_prc.th_a;
        ze=est.p_obs.ze1;
        beta=est.p_obs.beta;
        for j = 1:numel(parameters)
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
    [h,p,ci,stats]=ttest(temp(:,1),temp(:,2));
    statsKappa=p;
    disp(['Significance paired t-test kappa ' num2str(statsKappa)]);
    [h,p,ci,stats]=ttest(temp(:,3),temp(:,4));
    statsTheta=p;
    disp(['Significance paired t-test theta ' num2str(statsTheta)]);
    [h,p,ci,stats]=ttest(temp(:,5),1.5353);
    statsZeta=p;
    disp(['Significance paired t-test theta ' num2str(statsZeta)]);
    diffParameters=[temp(:,2)-temp(:,1) temp(:,4)-temp(:,3) temp(:,5) temp(:,6)];
    parMean=num2str(mean(diffParameters));
    disp(['Parameter Mean: ', parMean])
end
save([paths.stats.secondLevel.covariates, '/covariates.mat'],'temp', '-mat');
end

