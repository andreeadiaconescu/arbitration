function [Y, M] = wagad_extract_roi_timeseries(...
    iSubjectArray)
%Extract roi time series from regions of interest (group effect regions)
%   Uses UniQC Toolbox for dealing with fMRI time series and ROI extraction

if nargin < 1
    iSubjectArray = 3;
end

doPlotRoi = true;
idxMaskArray = [1 1]; % mask indices to be used from fnMaskArray
iContrast = 3;
nMasks = numel(idxMaskArray);

% integer for n-ary cluster export of contrast, indicating which cluster is
% indeed within the targeted anatomical region
idxValidClusters = [1 3];
iCondition = 1; % 1 = advice presentation, needed fo trial binning
doPlotRoiUnbinned = false;
doPlotTrialMean = false; % via separate MrImage mean('trials')

idxRunArray = [1 2]; % concatenated runs [1 2]
nRuns = numel(idxRunArray);
for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj);
    
    fnMaskArray = strcat(paths.stats.secondLevel.contrasts{iContrast}, ...
        filesep, paths.stats.secondLevel.roiAnalysis.fnMaskArray);
    
    YArray = cell(nRuns,1);
    for iRun = 1:nRuns
        fnFunct = regexprep(paths.preproc.output.fnFunctArray{idxRunArray(iRun)}, 'sw', 'w'); % use unsmoothed
        YArray{iRun} = MrImage(fnFunct);
        % t vector concatenates over runs:
        if iRun > 1
            %             YArray{iRun}.dimInfo.set_dims('t', 'firstSamplingPoint', ...
            %                 YArray{iRun-1}.dimInfo.t.samplingPoints{1}(end)+1);
            idxDimT = YArray{iRun}.dimInfo.get_dim_index('t');
            YArray{iRun}.dimInfo.samplingPoints{idxDimT} = ...
                YArray{iRun}.dimInfo.samplingPoints{idxDimT} + YArray{iRun-1}.dimInfo.samplingPoints{idxDimT}(end);
        end
    end
    
    % concatenate all runs in one image
    Y = YArray{1}.combine(YArray, 't');
    
    %% Load SPM of subject to get timing info etc (for peri-stimulus binning
    % according to advice onsets
    % Get time bins (relative to trial onsets) for each volume
    % NOTE: The runs are concatenated
    nVols = paths.scanInfo.nVols;
    iVolStart = 1 + sum(nVols(1:(iRun-1)));
    iVolEnd = sum(nVols(1:iRun));
    load(paths.stats.fnSpm);
    % pst = SPM.Sess(1).U(iCondition).pst(iVolStart:iVolEnd);
    ons = SPM.Sess(1).U(iCondition).ons;
    ons = ons(1:10);
    TR = SPM.xY.RT;
    Y.dimInfo.set_dims('t', 'resolutions', TR, 'firstSamplingPoint', 0, 'samplingWidths', TR);
    binTimes = [0:.5:20];
    % Y.bin_epoch(binTimes, pst) % result: nBinTimes x ??? (mean? sd?
    % because different number of scans end up in each bin
    %% Epoch into trials
    binTimes = 10;
    Z = Y.split_epoch(ons, binTimes); % result: nBinTimes x nTrials instead of nScans
    
    %% Roi extraction for full time series and trials-mean
    
    M = cell(1,nMasks);
    for iMask = 1:nMasks
        % remove other clusters (e.g., cholinergic), by there n-ary index
        M{iMask} = MrImage(fnMaskArray{idxMaskArray(iMask)});
        M{iMask}.data(~ismember(M{iMask}.data, idxValidClusters)) = 0;
    end
    
    % extract data from ROI and compute stats on that
    if doPlotRoiUnbinned
        Y.extract_rois(M);
        Y.compute_roi_stats();
        Y.rois{1}.plot();  % time courses from roi and sd-bands
    end
    
    doKeepExistingRois = false;
    Z.extract_rois(M,doKeepExistingRois); % deleting existing rois via 0
    Z.compute_roi_stats();
    
    if doPlotTrialMean
        X = Z.mean('trials');
        X.extract_rois(M,doKeepExistingRois);
        X.compute_roi_stats();
        X.rois{end}.plot();
    end
    
    %% handmade shaded PST-plot, average over trials and voxels
    if doPlotRoi
        
        for iMask = 1:nMasks
            [~,fnMaskShort] = fileparts(fnMaskArray{idxMaskArray(iMask)});
            stringTitle = sprintf(...
                'Roi %s: Peristimulus plot, mean (over voxels and trials) +/- s.e.m time series', ...
                fnMaskShort);
            figure('Name', stringTitle);
            
            nVoxels = Z.rois{end}.perVolume.nVoxels;
            nBins = Z.dimInfo.nSamples('t');
            nTrials = numel(ons);
            
            % data in rois is [nVoxels,nBins,nTrials] and has to be transformed
            % into [nVoxels*nTrials,nBins) to do stats for plot
            y = reshape(permute(cell2mat(Z.rois{iMask}.data), [3 1 2]), [], nBins);
            t = Z.dimInfo.samplingPoints{Z.dimInfo.get_dim_index('t')};
            
            % baseline correction for drift etc:, and scale to mean == 100
            % remove height differences at trial-time = 0;
            y = 100./mean(y(:))*(y - y(:,1));
            
            tnueeg_line_with_shaded_errorbar(t, mean(y)', std(y)'./sqrt(nVoxels*nTrials), 'g')
            title(stringTitle);
            xlabel('Peristimulus Time (seconds)');
            ylabel('Signal Change (%)');
        end
    end
    
end
end

