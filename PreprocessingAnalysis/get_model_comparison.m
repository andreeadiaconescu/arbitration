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

paths = get_paths_wagad();
pathfamily = paths.fileModelFamilyTemplate;

[models_wagad]          = loadWAGADModelEvidence(iSubjectArray,paths);
[alpha,exp_r,xp,pxp,bor]=spm_BMS(models_wagad);
disp(['Best model: ', num2str(find(exp_r==max(exp_r)))]);

original_models = paths.origModels;

if original_models == true
    % pairs of perceptual and response model
    modelLabels = {'Integrated2','Social2','Reward2','Bayes2',...
        'Integrated1','Social1','Reward1','Bayes1'};
    
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
    [family_responsemodels,model1] = spm_compare_families(models_wagad,family1);
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
    set(gca,'XTickLabel',{'Integrated1','Integrated2'});
    ylabel('Exceedance Probability');
    
else
    % pairs of perceptual and response model
    modelLabels = {'Integrated','Social','Reward','Bayes'};
end


if doPlotFigures
    H=exp_r;
    N=numel(H);
    colors=bone(numel(H));
    for i=1:N
        h=bar(i,H(i));
        if i==1, hold on, end
        set(h,'FaceColor',colors(i,:))
    end
    set(gca,'XTick',1:8)
    set(gca,'XTickLabel',modelLabels);
    
    % Create ylabel
    ylabel('p(m|y)');
    
end

