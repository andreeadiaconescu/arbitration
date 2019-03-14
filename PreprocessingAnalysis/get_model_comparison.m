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

[models_wagad]          = loadWAGADModelEvidence(iSubjectArray,paths);
[alpha,exp_r,xp,pxp,bor]=spm_BMS(models_wagad);
disp(['Best model: ', num2str(find(exp_r==max(exp_r)))]);

% Bayes Omnibus Risk (probability that model frequencies are equal)
BMS_results.alpha      = alpha;
BMS_results.exp_r      = exp_r;
BMS_results.pxp        = pxp;
BMS_results.bor        = bor;

disp(BMS_results);

modelLabels = {'M1','M2','M3','M4','M5','M6'};


if doPlotFigures
    H=exp_r;
    N=numel(H);
    colors=bone(numel(H));
    for i=1:N
        h=bar(i,H(i));
        if i==1, hold on, end
        set(h,'FaceColor',colors(i,:))
    end
    set(gca,'XTick',1:6)
    set(gca,'XTickLabel',modelLabels);
    
    % Create ylabel
    ylabel('p(m|y)');
    
end

