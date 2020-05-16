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
nRegressors = 10;
% advice, arbitration, wager, wager amount, trial, outcome, epsi2advice, epsi2card, epsi3advice, epsi3card
for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    load(fullfile(paths.stats.fnSpm));
    GLM         = SPM.xX.xKXs.X;
    GLMSelected = GLM(:,[1:2 7 10:16]);
    corrMatrix    = corrcoef(GLMSelected);
    z_transformed = dmpad_fisherz(reshape(corrMatrix,nRegressors^2,1));
    averageCorr{s,1}=reshape(z_transformed,nRegressors,...
        nRegressors);
end
save(fullfile(paths.stats.secondLevel.covariates, 'regressors_averagecorr_Fisherz.mat'),'averageCorr','-mat');

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = dmpad_ifisherz(reshape(averageZCorr,nRegressors^2,1));
finalCorr = reshape(averageGroupCorr,nRegressors,...
    nRegressors);
finalCorr(isnan(finalCorr))=1;
figure;imagesc(finalCorr);
colormap(flipud(gray));  % Change the colormap to gray (so higher values are
                         %   black and lower values are white)

textStrings = num2str(finalCorr(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:nRegressors);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center');
midValue = mean(get(gca, 'CLim'));  % Get the middle value of the color range
textColors = repmat(finalCorr(:) > midValue, 1, 3);  % Choose white or black for the
                                               %   text color of the strings so
                                               %   they can be easily seen over
                                               %   the background color
set(hStrings, {'Color'}, num2cell(textColors, 2));  % Change the text colors

set(gca, 'XTick', 1:nRegressors, ...                             % Change the axes tick marks
         'XTickLabel', {'Advice', 'Arbitration', 'Wager', 'Wager Amount', 'Trial','Outcome',...
         'Epsi2Advice','Epsi2Card','Epsi3Advice','Epsi3Card'}, ...  %   and tick labels
         'YTick', 1:nRegressors, ...
         'YTickLabel', {'Advice', 'Arbitration', 'Wager', 'Wager Amount', 'Trial','Outcome',...
         'Epsi2Advice','Epsi2Card','Epsi3Advice','Epsi3Card'}, ...
         'TickLength', [0 0]);
     
caxis([-1 1]);
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));
end