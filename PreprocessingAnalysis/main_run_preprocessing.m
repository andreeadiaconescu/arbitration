function main_run_preprocessing(iSubjectArray)
% Script main_run_preprocessing
% Performs preprocessing of fMRI data for multiple subjects, using
% pre-existing single-subject batch
%
%  main_run_preprocessing
%
%
%   See also
%
% Author:   Andreea Diaconescu & Lars Kasper
% Created:  2016-01-04
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

if nargin < 1
    
    % manual setting...if you want to exclude any subjects
    iSubjectArray = setdiff([3:47], [14 25 32 33 34 37]);
end



% checked via run through via in WAGAD/data-folder run:
% find . -name swau*run1* |sort

% redo swua => stc_realign
% iSubjectArray = [17 18 20 22 23 24];

% redo swau => realign_stc
% for all but 14 (file not found!) same 2 errors:

% iSubjectArray = [8, 9, 11, 14:23];

fnBatchPreprocess = fullfile(paths.code.batches, ...
    paths.code.batch.fnPreprocess);

useCluster = true;

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
    %% Load paths, setup matlabbatch for subject
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % load subject specific paths
    paths = get_paths_wagad(iSubj);
    
    % load matlabbach, update system-specific absolute paths in batch
    pathsBatchOld = {
        '/Users/kasperla/Documents/code/matlab/smoothing_trunk/WAGAD/batches'
        '/Users/kasperla/Documents/code/matlab/spm12'
        };
    
    pathsBatchNew = {
        paths.code.batches
        paths.code.spm
        };
    
    matlabbatch = update_matlabbatch_paths(...
        fnBatchPreprocess, pathsBatchOld, pathsBatchNew);
    
    
    %% change relevant subject-specific paths in batch & save
    
    % update subject dir
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = ...
        {{paths.subj}};
    
    % update functional files
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = ...
        {paths.preproc.input.fnFunctArray}';
    
    % update structural file
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = ...
        {{paths.preproc.input.fnStruct}};
    
    if useCluster
        % use report-quality batch without interactive output
        matlabbatch{end}.cfg_basicio.run_ops.runjobs.jobs{1} = ...
            regexprep(matlabbatch{end}.cfg_basicio.run_ops.runjobs.jobs{1}, ...
            'batch_report_quality\.m', 'batch_report_quality_no_figures\.m');
    end
    
    % save subject-specific batch in subject-folder, but as mat-file for
    % simplicity, and with a time stamp
    fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnPreprocess');
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