%% main script to semi-automatically prepare data for spatial preprocessing
%   0) Define paths
%   1) Copy (and rename) image nifti files, create folders
%   2) Copy (and rename) physiological log files, create folders
%   3) Compute behavioral model (HGF) and multiple regressors for subject
%   4) FSL skull stripping
%   5) TODO: (i.e. reorienting to AC-PC)
%   6) TODO: and physio-regressors creation


[iSubjectArray, dirSubjectArray] = ...
    get_subject_ids();

iSubjectArray = reshape(iSubjectArray, 1, []);

% manual subject selection
iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);

prepStepArray = [3];% [1 2 3]; % to start with

doRenameRaw     = ismember(1, prepStepArray);
doRenamePhys    = ismember(2, prepStepArray);
doComputeHgf    = ismember(3, prepStepArray);
doFslSkullStrip = ismember(4, prepStepArray);

useCluster = true; % submits HGF computation to cluster

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iSubj = iSubjectArray
    fprintf('Preparing subject %d\n', iSubj);
    try
        iRunArray = [1 2]; % true functional sessions: run1, run2, rest
        
        paths = get_paths_wagad(iSubj);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Rename and move raw data to corresponding directories (optional, maybe
        % done before)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if doRenameRaw
            rename_raw_files(paths);
            
            % Update scan info (nVols, nSlices, TR...and write info files to folders
            % where functional files reside
            fnFunctionalRenamedArray = ...
                strcat(paths.dirSess, filesep, paths.fnFunctRenamed);
            inputTR = 2.65781;
            paths.scanInfo = get_scan_info(fnFunctionalRenamedArray, inputTR);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Find corresponding SCANPHYSLOG-files and copy them to corresponding folders
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        addpath(paths.code.physio);
        
        if doRenamePhys
            for iRun = iRunArray
                [~, fnFunctRaw] = fileparts(paths.fnFunctRaw{iRun});
                fnScanphyslog = tapas_physio_find_matching_scanphyslog_philips(fnFunctRaw, paths.phys);
                mkdir(paths.dirLogs{iRun});
                % move phys log files in appropriate directory; NOTE: I copy here for safety
                % if sure, change to move :-)
                copyfile(fullfile(paths.phys, fnScanphyslog), fullfile(paths.dirLogs{iRun}, 'phys.log'));
            end
            
            % move other files in appropriate directory; NOTE: I copy here for safety
            % mkdir(paths.dirLogsOther);
            % copyfile(fullfile(paths.phys, '*.log'), paths.dirLogsOther);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Compute HGF behavioral model for subject
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        addpath(paths.code.model);
        
        if doComputeHgf
            if useCluster
                doPlotFigures = 0;
                submit_job_cluster_functioncall(paths, 'get_multiple_conditions', {iSubj, doPlotFigures});
            else
                
                get_multiple_conditions(iSubj);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Reorientation of all functional and structural files via 
        %   spm_display/spm_check_registration
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % TODO!
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Brain extraction via fsl
        % works, but only meaningful after reorientation!
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if doFslSkullStrip
            for iRun = iRunArray
                brain_extract_fsl(paths.dirSess{iRun}, paths.fnFunctRenamed{iRun});
            end
        end
        
    catch errorId
        errorIdArray{iSubj} = errorId;
        hasIdSubjError(iSubj) = 1;
    end
    
end