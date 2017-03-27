function get_model_comparison(iSubjectArray, doPlotFigures)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
end

if nargin < 2
    doPlotFigures = 1;
end

for iSubj = iSubjectArray
    for j = 1:3
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
    d = load(paths.fnFittedModel{3},'est','-mat');
    m{iSubj,4} = d.est.F;
end

temp                    = cell2mat(m);
[alpha,exp_r,xp,pxp,bor]=spm_BMS(temp);
disp(['Best model: ', num2str(find(exp_r==max(exp_r)))]);


if doPlotFigures
    H=exp_r;
    N=numel(H);
    colors=bone(numel(H));
    for i=1:N
        h=bar(i,H(i));
        if i==1, hold on, end
        set(h,'FaceColor',colors(i,:))
    end
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',{'Integrated','Bayes Optimal','Advice Only','Reward Only'})
    ylabel('p(r|y)');
    figure; bar(pxp);ylabel('Protected Exceedance Probabilities');
end
