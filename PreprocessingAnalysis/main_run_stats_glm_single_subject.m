% Script main_run_stats_glm_single_subject
% Performs Sets up and estimates 1st level design matrix for selected subjects
%
%  main_run_stats_glm_single_subject
%
% adapts subject-specific input data for template batch, including
%   - scan info timing (number of slices/volumes, TR)
%   - directory for GLM output
%   - input functional files
%   - input multiple regressors and conditions
%
%   See also
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
iExcludedSubjects = [6 14 25 32 31 33 34 37 44];

paths = get_paths_wagad(); % dummy subject to get general paths

% manual setting...if you want to exclude any subjects
iSubjectArray = get_subject_ids(paths.data)';
iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);

fnBatchStatsGlm = fullfile(paths.code.batches, ...
    paths.code.batch.fnStatsGlm);

useCluster = true;

iRunArray = 1:2; % Sessions that enter GLM
idPreproc = 1;
idDesign   = 3; % GLM design matrix selection by Id See also get_paths_wagad which folder it is :-)

% initialise spm
spm_get_defaults('modality', 'FMRI');
if ~exist('cfg_files', 'file')
    spm_jobman('initcfg')
end
% 1 GB instead of 64 MB for chunks of estimation...much faster
spm_get_defaults('stats.maxmem', 2^30);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iSubj = iSubjectArray
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Load paths, setup matlabbatch for subject
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % load subject specific paths
    paths = get_paths_wagad(iSubj, idPreproc, idDesign);
    
    
    %% Load template batch, change relevant subject-specific paths in batch & save
    
    clear matlabbatch;
    run(fnBatchStatsGlm);
    
    % update glm dir
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(paths.stats.glm.design);
    
    % update scan info
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = paths.scanInfo.TR(1);
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = paths.scanInfo.nSlices(1);
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = ceil(paths.scanInfo.nSlices(1)/2);
    
    
    % update functional files
    fnFunctGlmInputArray = [];
    for iRun = iRunArray
        fnFunctGlmInputArray = [fnFunctGlmInputArray; ...
            get_vol_filenames(paths.preproc.output.fnFunctArray{iRun}) ...
            ];
    end;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = fnFunctGlmInputArray;
    
    % update multiple conditions and regressors
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = ...
        {paths.fnMultipleConditions};
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {...
        paths.fnMultipleRegressors};
    
    % save subject-specific batch in subject-folder, but as mat-file for
    % simplicity, and with a time stamp
    fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnStatsGlm');
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
    
end