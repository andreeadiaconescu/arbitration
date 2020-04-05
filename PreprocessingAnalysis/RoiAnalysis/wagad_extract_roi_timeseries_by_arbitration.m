function [] = wagad_extract_roi_timeseries_by_arbitration(idxSubjectArray)
% Extract roi time series from regions of interest (group effect regions)
%   Uses UniQC Toolbox for dealing with fMRI time series and ROI extraction
% USE
%   wagad_extract_roi_timeseries(idxSubjectArray)

if nargin < 1
    idxSubjectArray = 3%setdiff([3:47], [6 14 25 31 32 33 34 37]);
end

%% #MOD user defined-parameters
doSave              = false; % save ROI values and current plots to file
doPlotRoi           = true;
doPlotRoiUnbinned   = true; % plot before epoching
doUseParallelPool   = false; % set true on EULER to parallelize over subjects
idxMaskArray        = [1:4]; % mask indices to be used from fnMaskArray
idxRunArray         = [1 2]; % concatenated runs [1 2]
colourArray         = {'b','g'};
% number sampled time bins per trial after epoching,
% default:7, because ITI <= 16s (< 7 TR)
% note: number of included trials is adapted to number of bins, if last
% trials are too short wrt nBinTimes*TR
nBinTimes       = 7;

%% only change if you know what you are doing:

idxContrastArray= [3; 1; 1; 1]; % determines 2nd level dir where the activation mask can be found

% cell of cluster index vectors corresponding to each mask
% each integer is an index for n-ary cluster export of a contrast,
% indicating which activated cluster is indeed within the targeted
% anatomical region
idxValidActivationClusters  = {[1], [1], [1], [1]};

iCondition                  = 1; % 1 = advice presentation, needed fo trial binning


%% derived parameters
nMasks = numel(idxMaskArray);
nRuns = numel(idxRunArray);
nSubjects = numel(idxSubjectArray);

if doUseParallelPool && isempty(gcp('noCreate'))
    % this is an interactive pool with more memory, i.e. additional command
    % line argument -R "rusage[mem=16000]" in cluster profile
    parpool('EulerLSF4h_16GB', nSubjects);
end

%% Subject loop for extraction and plotting of ROI time series for all
% runs and masks
% parfor
for iSubj = 1:nSubjects
    idxSubj = idxSubjectArray(iSubj);
    paths = get_paths_wagad(idxSubj);
    roiOpts = paths.stats.secondLevel.roiAnalysis; % short cut to substruct
    
    fnMaskArray = strcat(paths.stats.secondLevel.contrasts(idxContrastArray), ...
        filesep, roiOpts.fnMaskArray);
    
    %%
    epochedYArray = cell(nRuns,1);
    nValidTrialsPerRun = zeros(nRuns,1);
    
    load(paths.winningModel,'est','-mat');
    
    % compute arbitration
    px       = [0.5; 1./est.traj.sahat_a(:,1)];
    pc       = [0.5; 1./est.traj.sahat_r(:,1)];
    wx       = px./(px + pc);
    wc       = pc./(px + pc);
    
    for iRun = 1:nRuns
        fprintf('\n\tExtracting roi time series from subj %s (%d/%d), run %d ...', ...
            paths.idSubj, iSubj, nSubjects, iRun);
        fnFunct = regexprep(paths.preproc.output.fnFunctArray{idxRunArray(iRun)}, 'sw', 'w'); % use unsmoothed
        Y = MrImage(fnFunct);
        fprintf('loaded Y in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        %% Load SPM of subject to get timing info etc (for peri-stimulus binning
        % according to advice onsets)
        % Get time bins (relative to trial onsets) for each volume
        % NOTE: The runs are concatenated in the GLM
        nVols = paths.scanInfo.nVols;
        
        iVolStart = 1 + sum(nVols(1:(iRun-1)));
        temp = load(paths.stats.fnSpm, 'SPM');
        SPM = temp.SPM;
        
        %% Take onsets in particular linked to arbitration
        ons = SPM.Sess(1).U(iCondition).ons;
        social     = wx>0.5;
        individual = wc>0.5;
        socialOns  = social.*ons;
        indivOns   = individual.*ons;
        
        TR = SPM.xY.RT;
        
        Y.dimInfo.set_dims('t', 'resolutions', TR, 'firstSamplingPoint', ...
            (iVolStart-1)*TR, 'samplingWidths', TR, 'units', 's');
        
        % social
        idxSocialTrialsWithinRun = find(socialOns >= Y.dimInfo.t.ranges(1) & ...
            socialOns <= Y.dimInfo.t.ranges(2) - TR*nBinTimes);
        socialOnsMicroTime = socialOns(idxSocialTrialsWithinRun);
        nValidSocialTrialsPerRun(iRun) = numel(idxSocialTrialsWithinRun);
        
        % individual
        idxIndivTrialsWithinRun = find(indivOns >= Y.dimInfo.t.ranges(1) & ...
            indivOns <= Y.dimInfo.t.ranges(2) - TR*nBinTimes);
        indivOnsMicroTime = indivOns(idxIndivTrialsWithinRun);
        nValidIndivTrialsPerRun(iRun) = numel(idxIndivTrialsWithinRun);
        
        %% Roi definition and extraction for full time series of run
        
        fprintf('computing masks in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        M = cell(1,nMasks);
        for iMask = 1:nMasks
            % remove other clusters (e.g., cholinergic), by their n-ary index
            M{iMask} = MrImage(fnMaskArray{idxMaskArray(iMask)});
            M{iMask}.data(~ismember(M{iMask}.data, idxValidActivationClusters{iMask})) = 0;
        end
        
        doKeepExistingRois = false;
        
        Y.extract_rois(M, doKeepExistingRois);
        Y.compute_roi_stats();
        
        %% Create an artificial MrImage for epoching, with one Roi-mean time series per slice
        % i.e. one Roi per slice, with 1 voxel
        % NOTE: mean over ROI voxels OK for later epoching, because data was
        % slice-timing corrected before; otherwise, slice-specific timing would
        % have to be included into epoching
        
        
        fprintf('epoching of Y in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        
        
        dimInfoRoi = Y.dimInfo.copyobj;
        dimInfoRoi.set_dims({'x','y','z'}, 'nSamples', [1, 1, nMasks]);
        
        % permute to 4-dim to match dimensionality of dimInfo, which needs
        % x,y,z for epoching like SPM
        dataRoi = permute(cell2mat(cellfun(@(x) x.perVolume.mean, Y.rois, ...
            'UniformOutput', false)), [3 4 1 2]);
        Z = MrImage(dataRoi, 'dimInfo', dimInfoRoi);
        Z.name = sprintf('%s_mean_ts_one_roi_per_slice', paths.idSubj);
        
        % extract data from ROI and compute stats on that
        if doPlotRoiUnbinned
            Y.rois{1}.plot();  % time courses from roi and sd-bands
        end
        
        % now we only have to epoch a few voxels instead of the whole 3D volume
        % Epoch into trials
        fprintf('\nEpoching social arbitration trials:\n');
        epochedSocialYArray{iRun} = Z.split_epoch(socialOnsMicroTime, nBinTimes);
        fprintf('\nEpoching individual arbitration trials:\n');
        epochedIndivYArray{iRun} = Z.split_epoch(indivOnsMicroTime, nBinTimes);
        
        % right indices for trials to allow for proper concatenation
        % use relative indices (not absolute) to avoid inserting all-zero
        % time series for skipped trials
        epochedSocialYArray{iRun}.dimInfo.set_dims('trials', 'samplingPoints', ...
            sum(nValidSocialTrialsPerRun(1:(iRun-1))) + (1:nValidSocialTrialsPerRun(iRun)));
        
        epochedIndivYArray{iRun}.dimInfo.set_dims('trials', 'samplingPoints', ...
            sum(nValidIndivTrialsPerRun(1:(iRun-1))) + (1:nValidIndivTrialsPerRun(iRun)));
        
    end % run
    
    epochedSocialY = epochedSocialYArray{1}.concat(epochedSocialYArray, 'trials');
    epochedIndivY = epochedIndivYArray{1}.concat(epochedIndivYArray, 'trials');
    
    %% handmade shaded PST-plot, averaged over trials
    for iMask = 1:nMasks
        idxMask = idxMaskArray(iMask);
        [~,~] = mkdir(roiOpts.results.rois{idxMask});
        
        [~,fnMaskShort] = fileparts(fnMaskArray{idxMaskArray(iMask)});
        stringTitle = sprintf(...
            'ROI %s (%s): Peristimulus plot, mean arbitration (over trials) +/- s.e.m time series', ...
            regexprep(fnMaskShort, '_', ' '), paths.idSubj);
        
        nVoxels = 1;% already a mean, otherwise: Y.rois{iMask}.perVolume.nVoxels;
        nTrialsSocial = epochedSocialY.dimInfo.trials.nSamples;
        nTrialsIndividual = epochedIndivY.dimInfo.trials.nSamples;
        
        % data (mean ROI voxel time series) is [nMasks, nBins,nTrials] and has to be transformed
        % into [nTrials, nBins]) to do stats for plot
        ySocial = permute(epochedSocialY.select('z',iMask).remove_dims.data, [2, 1]);
        tSocial = epochedSocialY.dimInfo.t.samplingPoints{1};
        
        yIndiv = permute(epochedIndivY.select('z',iMask).remove_dims.data, [2, 1]);
        tIndiv = epochedIndivY.dimInfo.t.samplingPoints{1};
        
        % baseline correction for drift etc:, and scale to mean == 100
        % remove height differences at trial-time = 0;
        ySocial = 100./mean(ySocial(:))*(ySocial - ySocial(:,1));
        yIndiv = 100./mean(yIndiv(:))*(yIndiv - yIndiv(:,1));
        
        % save for later plotting
        if doSave
            fprintf('parsave in worker %d (id %s)\n', iSubj, paths.idSubj);
            %parsave
            parsave_roi(...
                roiOpts.results.fnTimeSeriesArraySocial{idxMask}, ...
                tSocial,ySocial,nVoxels,nTrialsSocial,stringTitle);
            
            parsave_roi(...
                roiOpts.results.fnTimeSeriesArrayCard{idxMask}, ...
                tIndiv,yIndiv,nVoxels,nTrialsIndividual,stringTitle);
        end
        
        if doPlotRoi
            fprintf('plotting in worker %d (id %s)\n', iSubj, paths.idSubj);
            fh = wagad_plot_roi_CombinedTimeseries(tSocial, yIndiv, ySocial, nVoxels, nTrialsIndividual, nTrialsSocial,...
                stringTitle,colourArray);
            if doSave
                saveas(fh, roiOpts.results.fnFigureSubjectArray{idxMask});
            end
        end
    end
end %for iSubj

end

