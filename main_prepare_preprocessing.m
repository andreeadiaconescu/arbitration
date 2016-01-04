%% main script to semi-automatically prepare data for spatial preprocessing
%   0) Define paths
%   1) Copy (and rename) image nifti files, create folders
%   2) Copy (and rename) physiological log files, create folders
%   3) Compute behavioral model (HGF) and multiple regressors for subject
%   4) FSL skull stripping
%   5) TODO: (i.e. reorienting to AC-PC)
%   6) TODO: and physio-regressors creation


[idSubjectArray, dirSubjectArray] = ...
    get_subject_ids();

idSubjectArray = reshape(idSubjectArray, 1, []);

prepStepArray = [1 2 3];

doRenameRaw     = ismember(1, prepStepArray);
doRenamePhys    = ismember(2, prepStepArray);
doComputeHgf    = ismember(3, prepStepArray);
doFslSkullStrip = ismember(4, prepStepArray);



%% Loop over subjects

for idSubj = idSubjectArray(4:end)
    fprintf('Preparing subject %d\n', idSubj);
    try
        iSessFunctionalArray = [1 2]; % true functional sessions: run1, run2, rest
        
        paths = get_paths_data(idSubj);
        
        
        %% Rename and move raw data to corresponding directories (optional, maybe
        % done before)
        if doRenameRaw
            rename_raw_files(paths);
        end
        
        %% Write nvols.txt into each functional run folder
        for iSess = iSessFunctionalArray
            V = spm_vol(fullfile(paths.dirSess{iSess}, paths.fnFunctRenamed{iSess}));
            nVols = numel(V);
            save(fullfile(paths.dirSess{iSess}, 'nvols.txt'), 'nVols', '-ASCII');
        end
        
        
        %% Find corresponding SCANPHYSLOG-files and copy them to corresponding folders
        addpath(paths.code.physio);
        
        if doRenamePhys
            for iSess = iSessFunctionalArray
                [~, fnFunctRaw] = fileparts(paths.fnFunctRaw{iSess});
                fnScanphyslog = tapas_physio_find_matching_scanphyslog_philips(fnFunctRaw, paths.phys);
                mkdir(paths.dirLogs{iSess});
                % move phys log files in appropriate directory; NOTE: I copy here for safety
                % if sure, change to move :-)
                copyfile(fullfile(paths.phys, fnScanphyslog), fullfile(paths.dirLogs{iSess}, 'phys.log'));
            end
            
            % move other files in appropriate directory; NOTE: I copy here for safety
            %mkdir(paths.dirLogsOther);
            %copyfile(fullfile(paths.phys, '*.log'), paths.dirLogsOther);
        end
        
        
        %% Compute HGF behavioral model for subject
        addpath(paths.code.model);
        
        if doComputeHgf
            get_multiple_conditions(idSubj);
        end
        
        
        %% Reorientation of all functional and structural files via spm_display/spm_check_registration
        
        % TODO!
        
        
        %% brain extraction via fsl
        % works, but only meaningful after reorientation!
        if doFslSkullStrip
            for iSess = iSessFunctionalArray
                brain_extract_fsl(paths.dirSess{iSess}, paths.fnFunctRenamed{iSess});
            end
        end
        
    catch errorId
        errorIdArray{idSubj} = errorId;
        hasIdSubjError(idSubj) = 1;
    end
    
end