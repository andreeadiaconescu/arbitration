function [Y, M] = wagad_extract_roi_timeseries(...
    iSubjectArray)
%Extract roi time series from regions of interest (group effect regions)
%   Uses UniQC Toolbox for dealing with fMRI time series and ROI extraction

if nargin < 1
    iSubjectArray = 3;
end

%%
doPlotRoi = true;
idxMaskArray = [1 1]; % mask indices to be used from fnMaskArray
iContrast = 3;
nMasks = numel(idxMaskArray);

% integer for n-ary cluster export of contrast, indicating which cluster is
% indeed within the targeted anatomical region
idxValidClusters = [1 3];
iCondition = 1; % 1 = advice presentation, needed fo trial binning
doPlotRoiUnbinned = false;

idxRunArray = [1 2]; % concatenated runs [1 2]
nRuns = numel(idxRunArray);
%for iSubj = iSubjectArray;
iSubj = iSubjectArray;
paths = get_paths_wagad(iSubj);

fnMaskArray = strcat(paths.stats.secondLevel.contrasts{iContrast}, ...
    filesep, paths.stats.secondLevel.roiAnalysis.fnMaskArray);

%%
epochedYArray = cell(nRuns,1);
for iRun = 1:nRuns
    fprintf('\n\tExtracting roi time series from subj %s (%d/%d), run %d ...', ...
        paths.idSubj, find(iSubj==iSubjectArray), numel(iSubjectArray), iRun);
    fnFunct = regexprep(paths.preproc.output.fnFunctArray{idxRunArray(iRun)}, 'sw', 'w'); % use unsmoothed
    Y = MrImage(fnFunct);
    
    %% Load SPM of subject to get timing info etc (for peri-stimulus binning
    % according to advice onsets
    % Get time bins (relative to trial onsets) for each volume
    % NOTE: The runs are concatenated in the GLM
    nVols = paths.scanInfo.nVols;
    
    iVolStart = 1 + sum(nVols(1:(iRun-1)));
    iVolEnd = sum(nVols(1:iRun));
    load(paths.stats.fnSpm);
    
    ons = SPM.Sess(1).U(iCondition).ons;
    TR = SPM.xY.RT;
    
    Y.dimInfo.set_dims('t', 'resolutions', TR, 'firstSamplingPoint', ...
        (iVolStart-1)*TR, 'samplingWidths', TR, 'units', 's');
    
    % select only onsets within timing range of this run
    idxTrialsWithinRun = find(ons >= Y.dimInfo.t.ranges(1) & ...
        ons <= Y.dimInfo.t.ranges(2));
    ons = ons(idxTrialsWithinRun);
    
    
    %% Roi definition and extraction for full time series of run
    
    M = cell(1,nMasks);
    for iMask = 1:nMasks
        % remove other clusters (e.g., cholinergic), by there n-ary index
        M{iMask} = MrImage(fnMaskArray{idxMaskArray(iMask)});
        M{iMask}.data(~ismember(M{iMask}.data, idxValidClusters)) = 0;
    end
    
    doKeepExistingRois = false;
    
    Y.extract_rois(M, doKeepExistingRois);
    Y.compute_roi_stats();
    
    %% Create an artificial MrImage for epoching, with one Roi-mean time series per slice
    % i.e. one Roi per slice, with 1 voxel
    % NOTE: mean over ROI voxels OK for later epoching, because data was
    % slice-timing corrected before; otherwise, slice-specific timing would
    % have to be included into epoching
    
    dimInfoRoi = Y.dimInfo.copyobj;
    dimInfoRoi.set_dims({'x','y','z'}, 'nSamples', [1, 1, nMasks]);
    
    % permute to 4-dim to match dimensionality of dimInfo, which needs 
    % x,y,z for epoching like SPM
    dataRoi = permute(cell2mat(cellfun(@(x) x.perVolume.mean, Y.rois, ...
        'UniformOutput', false)), [3 4 1 2]); 
    Z = MrImage(dataRoi, 'dimInfo', dimInfoRoi);
    
    % extract data from ROI and compute stats on that
    if doPlotRoiUnbinned
        Y.rois{1}.plot();  % time courses from roi and sd-bands
    end
    
    % now we only have to epoch a few voxels instead of the whole 3D volume
    % Epoch into trials
    binTimes = 7; % number sampled time bins per trial, ITI <= 16s (< 7 TR)
    epochedYArray{iRun} = Z.split_epoch(ons, binTimes);
    
    % right indices for trials to allow for proper concatenation
    epochedYArray{iRun}.dimInfo.set_dims('trials', 'samplingPoints', ...
        idxTrialsWithinRun);
end % run

epochedY = epochedYArray{1}.concat(epochedYArray, 'trials');


%% handmade shaded PST-plot, average over trials and voxels
if doPlotRoi
    plotY = epochedY;
    for iMask = 1:nMasks
        idxMask = idxMaskArray(iMask);
        [~,~] = mkdir(paths.stats.secondLevel.roiAnalysis.results.rois{idxMask});
        
        [~,fnMaskShort] = fileparts(fnMaskArray{idxMaskArray(iMask)});
        stringTitle = sprintf(...
            'Roi %s: Peristimulus plot, mean (over trials) +/- s.e.m time series', ...
            regexprep(fnMaskShort, '_', ' '));
        fh = figure('Name', stringTitle);
        
        nVoxels = 1;% already a mean, otherwise: Y.rois{iMask}.perVolume.nVoxels;
        nTrials = plotY.dimInfo.trials.nSamples;
        
        % data (mean ROI voxel time series) is [nMasks, nBins,nTrials] and has to be transformed
        % into [nTrials, nBins]) to do stats for plot
        y = permute(plotY.select('z',iMask).remove_dims.data, [2, 1]);
        t = plotY.dimInfo.t.samplingPoints{1};
        
        % baseline correction for drift etc:, and scale to mean == 100
        % remove height differences at trial-time = 0;
        y = 100./mean(y(:))*(y - y(:,1));
        
        tnueeg_line_with_shaded_errorbar(t, mean(y)', std(y)'./sqrt(nVoxels*nTrials), 'g')
        title(stringTitle);
        xlabel('Peristimulus Time (seconds)');
        ylabel('Signal Change (%)');
        
        saveas(fh, paths.stats.secondLevel.roiAnalysis.results.fnFigureArray{idxMask});
        save(paths.stats.secondLevel.roiAnalysis.results.fnTimeSeriesArray{idxMask}, ...
            't','y', 'nVoxels', 'nTrials', 'stringTitle');
    end
end

% end %for iSubj
end

