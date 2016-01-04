%% main script to semi-automatically prepare data for spatial preprocessing
%   1) Define paths
%   2) Copy (and rename) image nifti files, create folders
%   3) Copy (and rename) physiological log files, create folders
%   4) FSL skull stripping
%   5) TODO: (i.e. reorienting to AC-PC) 
%   5) TODO: and physio-regressors creation

iSubj = 3; % WAGAD_XXXX


iSessFunctionalArray = [1 2]; % true functional sessions: run1, run2, rest

doRenameRaw = true; % do renaming of raw data files (again)

paths = get_paths_data(iSubj);


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
addpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/spm12/toolbox/PhysIO');

for iSess = iSessFunctionalArray
    [~, fnFunctRaw] = fileparts(paths.fnFunctRaw{iSess});
    fnScanphyslog = tapas_physio_find_matching_scanphyslog_philips(fnFunctRaw, paths.phys);
    mkdir(paths.dirLogs{iSess});
    % move phys log files in appropriate directory; NOTE: I copy here for safety
    % if sure, change to move :-)
    copyfile(fullfile(paths.phys, fnScanphyslog), fullfile(paths.dirLogs{iSess}, 'phys.log'));
end

% move other files in appropriate directory; NOTE: I copy here for safety
mkdir(paths.dirLogsOther);
copyfile(fullfile(paths.phys, '*.log'), paths.dirLogsOther);

%% Reorientation of all functional and structural files via spm_display/spm_check_registration

% TODO!

%% brain extraction via fsl
% works, but only meaningful after reorientation!

for iSess = iSessFunctionalArray
   brain_extract_fsl(paths.dirSess{iSess}, paths.fnFunctRenamed{iSess});
end