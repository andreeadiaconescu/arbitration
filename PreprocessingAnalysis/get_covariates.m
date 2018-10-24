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
    for iRsp=1
        %%
        parameters = {'ka_r','ka_a','th_r','th_a','ze','beta'};
        load(paths.fnFittedModel{iRsp},'est','-mat');
        ka_r=est.p_prc.ka_r;
        ka_a=est.p_prc.ka_a;
        th_r=est.p_prc.th_r;
        th_a=est.p_prc.th_a;
        mu20_r=est.p_prc.p(1);
        sa20_r=est.p_prc.p(2);
        mu30_r=est.p_prc.p(3);
        sa30_r=est.p_prc.p(4);
        ka_a=est.p_prc.ka_a;
        th_r=est.p_prc.th_r;
        th_a=est.p_prc.th_a;
        mu20_a=est.p_prc.mu2a_0;
        sa20_a=est.p_prc.sa2a_0;
        mu30_a=est.p_prc.mu3a_0;
        sa30_a=est.p_prc.sa3a_0;
        ze=est.p_obs.ze;
        beta=est.p_obs.be_ch;
        for j = 1:14
            par{nSubjects,j} = [];
        end
        par{s,1} = ka_r; % kappa reward
        par{s,2} = ka_a; % kappa advice
        par{s,3} = th_r; % theta reward
        par{s,4} = th_a; % theta advice
        par{s,5} = ze;   % zeta
        par{s,6} = beta; % decision noise
    end
end
if doStats
    temp = cell2mat(par);
    figure; hist(log(temp(:,[5]))); hold on; stem(0);
    [h,p,ci,stats]=ttest(temp(:,1),temp(:,2));
    statsKappa=p;
    disp(['Significance paired t-test kappa ' num2str(statsKappa)]);
    [h,p,ci,stats]=ttest(temp(:,3),temp(:,4));
    statsTheta=p;
    disp(['Significance paired t-test theta ' num2str(statsTheta)]);
    [h,p,ci,stats]=ttest(log(temp(:,5)),0);
    statsZeta=p;
    disp(['Significance paired t-test zeta ' num2str(statsZeta)]);
    diffParameters=[temp(:,2)-temp(:,1) temp(:,4)-temp(:,3) temp(:,5) temp(:,6)];
    diffTheta = temp(:,4)-temp(:,3);
    [R,P,RLO,RUP]=corrcoef(temp(:,3),temp(:,4));
    figure; scatter(temp(:,3),temp(:,4));
    disp(['Significance correlation theta' num2str(P(1,2))]);
    [R,P,RLO,RUP]=corrcoef(temp(:,1),temp(:,2));
    figure; scatter(temp(:,1),temp(:,2));
    disp(['Significance correlation kappa' num2str(P(1,2))]);
    parMean=num2str(mean(diffParameters));
    disp(['Parameter Mean: ', parMean])
    parSTD=num2str(std(diffParameters));
    disp(['Parameter STD: ', parSTD])
end
save([paths.stats.secondLevel.covariates, '/covariates_model2.mat'],'temp', '-mat');
end

