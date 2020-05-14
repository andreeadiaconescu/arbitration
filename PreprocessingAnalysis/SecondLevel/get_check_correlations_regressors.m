function get_check_correlations_regressors(iSubjectArray)

paths = get_paths_wagad(); % dummy subject to get general paths

if nargin < 1
    % manual setting...if you want to exclude any subjects
    iSubjectArray = get_subject_ids(paths.data)';
    % manual setting...if you want to exclude any subjects
    iExcludedSubjects = [6 14 25 31 32 33 34 37 44];
    iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);
end

addpath(paths.code.model);
nSubjects = numel(iSubjectArray);

for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    load(fullfile(details.firstLevel.sensor.pathStats, '/SPM.mat'));
    GLM=SPM.xX.xKXs.X;
    nConstrats = numel(options.secondlevelRegressors);
    nComputationalQuantities = nConstrats-1;
    GLM=GLM(:,[2:nConstrats]);
    corrMatrix    = corrcoef(GLM);
    z_transformed = dmpad_fisherz(reshape(corrMatrix,nComputationalQuantities^2,1));
    averageCorr{iSub,1}=reshape(z_transformed,nComputationalQuantities,...
        nComputationalQuantities);
end
save(fullfile(options.secondlevelDir.classical, 'regressors_averagecorr_Fisherz.mat'),'averageCorr','-mat');

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = dmpad_ifisherz(reshape(averageZCorr,nComputationalQuantities^2,1));
finalCorr = reshape(averageGroupCorr,nComputationalQuantities,...
    nComputationalQuantities);
figure;imagesc(finalCorr);
caxis([-1 1]);
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));
end