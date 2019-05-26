function fhArray =  wagad_plot_group_roi_timeseries(idxSubjectArray)
% Summarizes results of all subjects of ROI extraction in two plots; one
% plot with subplots over all subjects, another one averaging over subjects
% the subject-specific trial mean
%
%   fhArray =  wagad_plot_group_roi_timeseries(idxSubjectArray)
%
% IN
%
% OUT
%
% EXAMPLE
%   wagad_plot_group_roi_timeseries
%
%   See also wagad_extract_roi_timeseries wagad_plot_group_roi_timeseries

% Author:   Lars Kasper
% Created:  2019-05-26
% Copyright (C) 2019 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%

if nargin < 1
    idxSubjectArray = setdiff([3:47], [6 14 25 31 32 33 34 37]);
end

idxMaskArray = [1]; % masks to be plotted
equalYLimits = [-0.3 0.7]; % percent signal changes


nMasks = numel(idxMaskArray);
nSubjects = numel(idxSubjectArray);
nRows = floor(sqrt(nSubjects/(16/10))); % because screen is wider than high by 16/10, take less rows in plot
nColumns = ceil(nSubjects/nRows);

nBins = 7;
meanY = zeros(nSubjects,nBins);
stdY = zeros(nSubjects,nBins);

paths = get_paths_wagad(idxSubjectArray(1)); % for general options
roiOpts = paths.stats.secondLevel.roiAnalysis;
fhArray = [];
for iMask = 1:nMasks
    idxMask = idxMaskArray(iMask);
    [~,fnMaskShort] = fileparts(roiOpts.fnMaskArray{idxMask});
    stringSupTitle = sprintf(...
        'ROI %s: Peristimulus plot, mean (over trials) +/- s.e.m time series', ...
        regexprep(fnMaskShort, '_', ' '));
    fh = figure('Name', stringSupTitle);
    fhArray(end+1,1) = fh;
    
    %% loop over subjects to load data and populate per-subject subplots of 
    % trial means
    for iSubj = 1:nSubjects
        fprintf('Subj %d/%d\n', iSubj, nSubjects);
        paths = get_paths_wagad(idxSubjectArray(iSubj));
        roiOpts = paths.stats.secondLevel.roiAnalysis;
        
        idxSubj = sscanf(paths.idSubj, paths.patternIdSubj);
        load(roiOpts.results.fnTimeSeriesArray{idxMask}, ...
            't', 'y', 'nVoxels', 'nTrials');
        
        subplot(nRows,nColumns,iSubj);
        stringTitle = sprintf('Subj %d', idxSubj);
        wagad_plot_roi_timeseries(t, y, nVoxels, nTrials, stringTitle, fh)
       
        % compactify axis labels for this large plot
        xlabel('PST (seconds)');
        if mod(iSubj, nColumns) ~=1
            ylabel(''); % ylabel only in first columns
        end
        ylim(equalYLimits);
        
        meanY(iSubj,:) = mean(y);
        stdY(iSubj,:) = std(y)./sqrt(nVoxels*nTrials);
        
    end
    suptitle(stringSupTitle);
    
    saveas(fh, roiOpts.results.fnFigureGroupArray{idxMask});
    
    %% Plot with group mean over subjects;
    stringSupTitle = sprintf(...
        'ROI %s: Peristimulus plot, mean +/- s.e.m (over subjects) of mean (over trials) time series', ...
        regexprep(fnMaskShort, '_', ' '));
    fh = figure('Name', stringSupTitle);
    
    fhArray(end+1,1) = fh;
    
    wagad_plot_roi_timeseries(t, meanY, 1, nSubjects, stringSupTitle, fh)
    
    
    saveas(fh, roiOpts.results.fnFigureGroupMeanArray{idxMask});
    
end