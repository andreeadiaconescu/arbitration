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
    learningParameters = {'\kappa_r','\kappa_a','\vartheta_r','\vartheta_a'};
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    ka_r=est.p_prc.ka_r;
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
temp = cell2mat(par);

%% Plot MAPs of Learning Parameters
x = temp(:,1);
y = temp(:,2);
z = temp(:,3);
t = temp(:,4);


Priors    = [tapas_sgm(est.c_prc.logitkamu_r,1);tapas_sgm(est.c_prc.logitkamu_a,1);...
    tapas_sgm(est.c_prc.logitthmu_r,1);tapas_sgm(est.c_prc.logitthmu_a,1)];
Variables = {x y z t};
Groups    = {ones(length(x), 1), 2*ones(length(y), 1), 3*ones(length(z), 1),4*ones(length(t), 1)};

GroupingVariables = learningParameters;

figure;
H   = Variables;
N=numel(Variables);

colors=spring(numel(H));

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
hold on;
scatter([1:4]',Priors,100,'k','d','LineWidth',3);
set(gca,'FontName','Constantia','FontSize',20);
ylabel('MAPs Learning Parameters');
%% Plot Zeta
% Zeta
figure; hist((temp(:,[5]))); hold on; stem(log(1),'d','LineWidth',3);
% Create xlabel
xlabel('log(\zeta)');
% Create ylabel
ylabel('Count');

%% Stats
if doStats
    zeta = temp(:,[5]);
    [h,p,ci,stats]=ttest(zeta,log(1));
    disp(['Significance paired t-test zeta: ' p]);
    statsZeta.pValue=p;
    statsZeta.pValueBonferroni=p*3;
    statsZeta.Tstats= stats.tstat;
    statsZeta.df= stats.df;
    disp(statsZeta);
    
    
    % Differences in Kappa
    [h,p,ci,stats]=ttest(temp(:,1),temp(:,2));
    disp(['Significance paired t-test kappa: ' p]);
    statsKappa.pValue=p;
    statsKappa.pValueBonferroni=p*3;
    statsKappa.Tstats= stats.tstat;
    statsKappa.df= stats.df;
    disp(statsKappa);
    
    % Differences in Theta
    [h,p,ci,stats]=ttest(temp(:,3),temp(:,4));
    disp(['Significance paired t-test theta: ' p]);
    statsTheta.pValue=p;
    statsTheta.pValueBonferroni=p*3;
    statsTheta.Tstats= stats.tstat;
    statsTheta.df= stats.df;
    disp(statsTheta);
    
    diffParameters=[temp(:,2)-temp(:,1) temp(:,4)-temp(:,3)];
    
    MAPparameters = [iSubjectArray' temp];
    parMean=num2str(mean(diffParameters));
    disp(['Parameter Mean Difference (Kappa & Theta): ', parMean])
    parSTD=num2str(mean(temp));
    disp(['Parameter Mean: ', parSTD])
end
save([paths.stats.secondLevel.covariates, '/covariates_model.mat'],'MAPparameters', '-mat');
end

