function get_model_comparison(iSubjectArray, doPlotFigures)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [10 13 23 14 25 32 33 34 37]);
end

if nargin < 2
    doPlotFigures = 1;
end

pathfamily = '/Users/drea/Documents/Social_Learning/BEHAV/gpo/regr_results/';

for iSubj = iSubjectArray
    for j = 1:8
        m{iSubj,j} = [];
    end
    %% Load Model and inputs
    paths = get_paths_wagad(iSubj,1);
    a = load(paths.fnFittedModel{1},'est','-mat');
    m{iSubj,1} = a.est.F;
    b = load(paths.fnFittedModel{2},'est','-mat');
    m{iSubj,2} = b.est.F;
    c = load(paths.fnFittedModel{3},'est','-mat');
    m{iSubj,3} = c.est.F;
    d = load(paths.fnFittedModel{4},'est','-mat');
    m{iSubj,4} = d.est.F;
    e = load(paths.fnFittedModel{5},'est','-mat');
    m{iSubj,5} = e.est.F;
    f = load(paths.fnFittedModel{6},'est','-mat');
    m{iSubj,6} = f.est.F;
    g = load(paths.fnFittedModel{7},'est','-mat');
    m{iSubj,7} = g.est.F;
    h = load(paths.fnFittedModel{8},'est','-mat');
    m{iSubj,8} = h.est.F;
    
end

temp                    = cell2mat(m);
[alpha,exp_r,xp,pxp,bor]=spm_BMS(temp);
disp(['Best model: ', num2str(find(exp_r==max(exp_r)))]);


if doPlotFigures
    H=pxp;
    N=numel(H);
    colors=bone(numel(H));
    for i=1:N
        h=bar(i,H(i));
        if i==1, hold on, end
        set(h,'FaceColor',colors(i,:))
    end
    set(gca,'XTick',1:8)
    set(gca,'XTickLabel',{'Integrated2','Social2','Reward2','Bayes2',...
                          'Integrated1','Social1','Reward1''Bayes1'});
    
    ylabel('Protected Exceedance Probabilities');
end

load([pathfamily 'family_allmodels.mat']);
family1=family_allmodels;
clear family_allmodels;
family1.exp_r=[];
family1.xp=[];
family1.s_samp=[];
family1.alpha0=[];
family1.s_samp=[];
family1.names={'Integrated2','Integrated1'};
family1.partition = [1 1 1 1 2 2 2 2];
[family_responsemodels,model1] = spm_compare_families(temp,family1);
figure;
H=family_responsemodels.xp;
N=numel(H);
colors=jet(numel(H));
for i=1:N
    h=bar(i,H(i));
    if i==1, hold on, end
    set(h,'FaceColor',colors(i,:))
end
set(gca,'XTick',1:4)
set(gca,'XTickLabel',{'Integrated2','Integrated1'});
ylabel('Exceedance Probability');
