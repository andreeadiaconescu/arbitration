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
    ResponseModelParameters = {'\sigma_1',' \xi','\sigma_2 Advice','\sigma_2 Card',...
                               '\mu_3 Advice','\mu_3 Card'};
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    be_surp       = est.p_obs.be1;
    be_arbitration= est.p_obs.be2;
    beta_inferv_a = est.p_obs.be3;
    beta_inferv_r = est.p_obs.be4;
    beta_pv_a     = est.p_obs.be5;
    beta_pv_r     = est.p_obs.be6;
    zeta          = est.p_obs.ze;
    
    par{s,1} = be_surp;
    par{s,2} = be_arbitration;
    par{s,3} = beta_inferv_a;
    par{s,4} = beta_inferv_r;
    par{s,5} = beta_pv_a;
    par{s,6} = beta_pv_r;
    par{s,7} = log(zeta);
end

parameters = cell2mat(par);
%% MAPs of Response Model Parameters
x = parameters(:,1);
y = parameters(:,2);
z = parameters(:,3);
t = parameters(:,4);
u = parameters(:,5);
v = parameters(:,6);

Variables = {x y z t u v};
Groups    = {ones(length(x), 1) 2*ones(length(y), 1) 3*ones(length(z), 1) 4*ones(length(t), 1),...
            5*ones(length(u), 1) 6*ones(length(v), 1)};

GroupingVariables = ResponseModelParameters;

figure;
H   = Variables;
N=numel(Variables);

colors=parula(numel(H));
    
for i=1:N
    e = notBoxPlot(cell2mat(H(i)),cell2mat(Groups(i)));
    set(e.data,'MarkerSize', 10);
    if i == 2 || i == 4
        set(e.data,'Marker','o');
        set(e.data,'Marker','o');
    end
    if i==1, hold on, end
    set(e.data,'Color',colors(i,:))
    set(e.sdPtch,'FaceColor',colors(i,:));
    set(e.semPtch,'FaceColor',[0.9 0.9 0.9]);
end
set(gca,'XTick',1:N)
set(gca,'XTickLabel',GroupingVariables);
hold all;
scatter([1:6]',[zeros(size(Variables,2),1)]',100,'k','d','LineWidth',3);
set(gca,'FontName','Constantia','FontSize',20);
ylabel('MAPs of Response Model Parameters');

%% Stats

if doStats
    temp = cell2mat(par);
    %%
    [h,p,ci,stats]=ttest(temp(:,1),0);
    disp(['Significance t-test for beta_surp ' num2str(p)]);
    statsBePrecision.p                = p;
    statsBePrecision.stats            = stats.tstat;
    statsBePrecision.p_bonferroni     = p*6;
    disp(statsBePrecision);
    
    %%
    [h,p,ci,stats]=ttest(temp(:,2),0);
    disp(['Significance t-test for beta_arbitration ' num2str(p)]);
    statsBeArbitration.p                = p;
    statsBeArbitration.stats            = stats.tstat;
    statsBeArbitration.p_bonferroni     = p*6;
    disp(statsBeArbitration);
    
    %%
    [h,p,ci,stats]=ttest(temp(:,3),0);
    disp(['Significance t-test for beta_inf_uncertainty_a ' num2str(p)]);
    statsBeInf_A.p                = p;
    statsBeInf_A.stats            = stats.tstat;
    statsBeInf_A.p_bonferroni     = p*6;
    disp(statsBeInf_A);
    
    %%
    [h,p,ci,stats]=ttest(temp(:,4),0);
    disp(['Significance t-test for beta_inf_uncertainty_r ' num2str(p)]);
    statsBeInf_R.p                = p;
    statsBeInf_R.stats            = stats.tstat;
    statsBeInf_R.p_bonferroni     = p*6;
    disp(statsBeInf_R);
    
    %%
    [h,p,ci,stats]=ttest(temp(:,5),0);
    disp(['Significance t-test for beta_volatility_a ' num2str(p)]);
    statsBePV_A.p                = p;
    statsBePV_A.stats            = stats.tstat;
    statsBePV_A.p_bonferroni     = p*6;
    disp(statsBePV_A);
    
    
    %%
    [h,p,ci,stats]=ttest(temp(:,6),0);
    disp(['Significance t-test for beta_volatility_r ' num2str(p)]);
    statsBePV_R.p                = p;
    statsBePV_R.stats            = stats.tstat;
    statsBePV_R.p_bonferroni     = p*6;
    disp(statsBePV_R);
    
    
    betas = [iSubjectArray' temp];
    
end
save([paths.stats.secondLevel.covariates, '/betas_linear_rsp.mat'],'betas', '-mat');

end