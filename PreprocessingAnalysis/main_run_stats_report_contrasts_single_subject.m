% Script main_run_stats_report_contrasts_single_subject
% Computes and visualizes contrasts of interests and nuisance regressors
% F-contrasts to assess efficacy of physiological noise correction
%
%  main_run_stats_report_contrasts_single_subject
%
%
%   See also tapas_physio_report_contrasts
%
% Author:   Andreea Diaconescu & Lars Kasper
% Created:  2016-01-09
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: new_script2.m 354 2013-12-02 22:21:41Z kasperla $
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters to set (subjects, preproc-flavor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idPreproc = 1;
idDesign   = 3; % GLM design matrix selection by Id See also get_paths_wagad which folder it is :-
%iExcludedSubjects = [6 14 25 32 31 33 34 37 44]; % Subjects excluded from the analysis 

iExcludedSubjects = [3:4 5 6:10 14 25 32 31 33 34 37 44];

paths = get_paths_wagad(); % dummy subject to get general paths

% manual setting...if you want to exclude any subjects
iSubjectArray = get_subject_ids(paths.data)';
iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);

% dummy subject to get general paths for selected design/preproc strategies
paths = get_paths_wagad(iSubjectArray(1), idPreproc,idDesign);

useCluster = false;

doInteractivePlotOnly = false; % prevents deleting existing contrasts

fnBatchStatsContrasts = fullfile(paths.code.batches, ...
    paths.code.batch.fnStatsContrasts);

fnBatchStatsContrastsPhysio = fullfile(paths.code.batches, ...
    paths.code.batch.fnStatsContrastsPhysio);



% initialise spm
spm_get_defaults('modality', 'FMRI');
if ~exist('cfg_files', 'file')
    spm_jobman('initcfg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iSubj = iSubjectArray
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Load paths, setup report-contrasts matlabbatch for subject
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % load subject specific paths
    paths = get_paths_wagad(iSubj, idPreproc, idDesign);
    
    % report file with timeStamp
    fnReport = regexprep(paths.stats.contrasts.fnReport, '\.ps', ...
        [datestr(now, '_yyyy_mm_dd_HHMMSS') '\.ps']);
    
    
    % Load template batch, change relevant subject-specific paths in batch & save
    %try
    clear matlabbatch;
    run(fnBatchStatsContrasts);
    
    % update SPM.mat dir & batch
    if doInteractivePlotOnly & ~useCluster
        % delete contrast creation
        matlabbatch{2}.spm.stats.results.spmmat = cellstr(paths.stats.fnSpm);
        matlabbatch(1) = [];
    else
        matlabbatch{1}.spm.stats.con.spmmat = cellstr(paths.stats.fnSpm);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Concat other matlabbatch to run PhysIO-toolbox report contrasts function,
    %   using information from created physio-structure for relevant
    %   contrasts,  FWE-corrected
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % the following changes to the input function of the matlab batch
    % correspond to the direct call of
    %     args = tapas_physio_report_contrasts(...
    %         'reportContrastThreshold', 0.05, ...
    %         'reportContrastCorrection', 'FWE', ...
    %         'fileReport', fnReport, ...
    %         'fileSpm', paths.stats.fnSpm, ...
    %         'filePhysIO', paths.preproc.output.fnPhysioArray{1}, ...
    %         'fileStructural', paths.preproc.output.fnStruct, ...
    %         'titleGraphicsWindow, paths.idSubjBehav);
    matlabbatch1 = matlabbatch;
    clear matlabbatch
    run(fnBatchStatsContrastsPhysio)
    matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{6}.evaluated = ...
        spm_file(fnReport, 'suffix', '_physio');
    matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{8}.evaluated = ...
        paths.stats.fnSpm;
    matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{10}.evaluated = ...
        paths.preproc.output.fnPhysioArray{1};
    matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{12}.evaluated = ...
        paths.preproc.output.fnStruct;
    matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{14}.evaluated = ...
        paths.idSubjBehav;
    
    % concat batches
    matlabbatch = [matlabbatch1 matlabbatch];
    
    % save subject-specific batch in subject-folder, but as mat-file for
    % simplicity, and with a time stamp
    
    fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnStatsContrasts');
    save(fnBatchSave, 'matlabbatch');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run matlabbatch...either interactively or on cluster
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if useCluster
        [nameScriptBrutus, fileScriptBrutus] = ...
            submit_job_cluster_matlabbatch(paths, fnBatchSave);
    else
        spm_jobman('run', matlabbatch);
    end
    
    %catch err
    %end
    
    fnReportArray{iSubj} = fnReport;
    
end

%% move created spm_*.ps from contrast report to right location, if existing
for iSubj = iSubjectArray
    
    paths           = get_paths_wagad(iSubj, idPreproc, idDesign);
    fnReport        = fnReportArray{iSubj};
    fnReportPhysio  = spm_file(fnReport, 'suffix', '_physio');
    
    % pause until file is created
    fprintf('Waiting for creation of file %s', fnReportPhysio);
    while ~exist(fnReportPhysio, 'file')
        pause(1);
        fprintf('.');
    end
    fprintf('\n');
    
    % move last created standard postscript file from spm contrast manager
    % to meaningful name
    pathGlm = paths.stats.glm.design;
    fnReportDefault = dir(fullfile(pathGlm, 'spm_*ps'));
    
    if numel(fnReportDefault) > 0
        fnReportDefault = fullfile(pathGlm, fnReportDefault(end).name);
        movefile(fnReportDefault, fnReport);
    end
    
end