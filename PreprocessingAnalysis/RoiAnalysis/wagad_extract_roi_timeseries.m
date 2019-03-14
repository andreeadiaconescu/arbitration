function [Y, M] = wagad_extract_roi_timeseries(...
    iSubjectArray)
%Extract roi time series from regions of interest (group effect regions)
%   Uses UniQC Toolbox for dealing with fMRI time series and ROI extraction

if nargin < 1
    iSubjectArray = 3;
end

iMask = 1;
iContrast = 3;
iMidbrainClusters = [1 3];
iCondition = 1; % 1 = advice presentation, needed fo trial binning

iRun = [1]; % concatenated runs [1 2]
for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj);
    fnFunct =  paths.preproc.output.fnFunctArray(iRun);
    fnMask = fullfile(paths.stats.secondLevel.contrasts{iContrast}, ...
        paths.stats.secondLevel.roiAnalysis.fnMaskArray{iMask});
    
    % concatenate all runs in one image
    Y = MrImage(fnFunct);
    
    % remove other clusters (cholinergic), still a hack after visual
    % inspection
    M = MrImage(fnMask);
    M.data(~ismember(M.data, iMidbrainClusters)) = 0;
    
    % extract data from ROI and compute stats on that
    Y.extract_rois(M);
    Y.compute_roi_stats();
    Y.rois{1}.plot();  % time courses from roi and sd-bands
    
    %% Load SPM of subject to get timing info etc (for peri-stimulus binning
    % according to advice onsets
    % Get time bins (relative to trial onsets) for each volume
    % NOTE: The runs are concatenated
    nVols = paths.scanInfo.nVols;
    iVolStart = 1 + sum(nVols(1:(iRun-1)));
    iVolEnd = sum(nVols(1:iRun));
    pst = SPM.Sess(1).U(iCondition).pst(iVolStart:iVolEnd);
    ons = SPM.Sess(1).U(iCondition).ons;
    TR = SPM.xY.RT;
    binTimes = [0:.5:20];
    % Y.bin_epoch(binTimes, pst) % result: nBinTimes x ??? (mean? sd?
    % because different number of scans end up in each bin
    Y.split_epoch(ons, binTimes); % result: nBinTimes x nTrials instead of nScans
end
end

