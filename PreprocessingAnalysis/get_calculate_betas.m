function get_calculate_betas(iSubjectArray)

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
    parameters = {'be_surp','be_arbitration','beta_inferv_a','beta_inferv_r','beta_pv_a','beta_pv_r'};
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    be_surp=est.p_obs.be1;
    be_arbitration=est.p_obs.be2;
    beta_inferv_a=est.p_obs.be3;
    beta_inferv_r=est.p_obs.be4;
    beta_pv_a=est.p_obs.be5;
    beta_pv_r=est.p_obs.be6;
    
    par{s,1} = be_surp;
    par{s,2} = be_arbitration;
    par{s,3} = beta_inferv_a;
    par{s,4} = beta_inferv_r;
    par{s,5} = beta_pv_a;
    par{s,6} = beta_pv_r;
end
if doStats
    temp = cell2mat(par);
    [h,p,ci,stats]=ttest(temp(:,1),0);
    statsBeSurp=p;
    disp(['Significance t-test for beta_surp ' num2str(statsBeSurp)]);
    [h,p,ci,stats]=ttest(temp(:,2),0);
    statsBeArbitration=p;
    disp(['Significance t-test for beta_arbitration ' num2str(statsBeArbitration)]);
    [h,p,ci,stats]=ttest(temp(:,5),0);
    statsBePV_A = p;
    disp(['Significance t-test for beta_volatility_a ' num2str(statsBePV_A)]);
    [h,p,ci,stats]=ttest(temp(:,6),0);
    statsBePV_R = p;
    disp(['Significance t-test for beta_volatility_r ' num2str(statsBePV_R)]);
    
   [h,p,ci,stats]=ttest(temp(:,3),0);
    statsBeInf_A = p;
    disp(['Significance t-test for beta_inf_uncertainty_a ' num2str(statsBeInf_A)]);
    [h,p,ci,stats]=ttest(temp(:,4),0);
    statsBeInf_R = p;
    disp(['Significance t-test for beta_inf_uncertainty_r ' num2str(statsBeInf_R)]);
    
    betas = [iSubjectArray' temp];
    
end
save([paths.stats.secondLevel.covariates, '/betas_linear_rsp.mat'],'betas', '-mat');

end