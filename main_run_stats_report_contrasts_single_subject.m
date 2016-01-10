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

paths = get_paths_wagad(); % dummy subject to get general paths

if ismac
    iSubjectArray = get_subject_ids(paths.data, 'test_')';
else
    iSubjectArray = get_subject_ids(paths.data)';
end

% manual setting...if you want to exclude any subjects
% 3 finished successfully
% 6 and 14 don't work because of missing physio or split session
% 12 is still running
% 18 has weird svd error => follow up!
%
iSubjectArray = setdiff(iSubjectArray, [3 6 12 14 18]);

fnBatchStatsContrasts = fullfile(paths.code.batches, ...
    paths.code.batch.fnStatsContrasts);

useCluster = false;

iDesign   = 1; % GLM design matrix selection by Id See also get_paths_wagad which folder it is :-)

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
    paths = get_paths_wagad(iSubj);
    
    % Load template batch, change relevant subject-specific paths in batch & save
    try
    clear matlabbatch;
    run(fnBatchStatsContrasts);
    
    % update SPM.mat dir
    matlabbatch{1}.spm.stats.con.spmmat = paths.stats.fnSpmArray(iDesign);
    
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
    
    %% move created spm_*.ps to right location
    pathGlm = paths.stats.glm.designs{iDesign};
    fnReportDefault = dir(fullfile(pathGlm, 'spm_*ps'));
    fnReportDefault = fullfile(pathGlm, fnReportDefault(end).name);
    
    fnReport = regexprep(paths.stats.contrasts.fnReportArray{iDesign}, '\.ps', ...
        [datestr(now, '_yyyy_mm_dd_HHMMSS') '\.ps']);
    movefile(fnReportDefault, fnReport);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% run PhysIO-toolbox report contrasts function,
    %   using information from created physio-structure for relevant
    %   contrasts
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % FWE-corrected
    args = tapas_physio_report_contrasts(...
        'reportContrastThreshold', 0.05, ...
        'reportContrastCorrection', 'FWE', ...
        'fileReport', fnReport, ...
        'fileSpm', paths.stats.fnSpmArray{iDesign}, ...
        'filePhysIO', paths.preproc.output.fnPhysioArray{1}, ...
        'fileStructural', paths.preproc.output.fnStruct);
    
    
    % again with liberal threshold: 0.001 uncorrected
    args = tapas_physio_report_contrasts(...
        'fileReport', fnReport, ...
        'fileSpm', paths.stats.fnSpmArray{iDesign}, ...
        'filePhysIO', paths.preproc.output.fnPhysioArray{1}, ...
        'fileStructural', paths.preproc.output.fnStruct);
    catch err
    end

end