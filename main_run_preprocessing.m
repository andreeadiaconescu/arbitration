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

% manual setting...
iSubjectArray = 3;

fnBatchPreprocess = fullfile(paths.code.batches, paths.code.batch.fnPreprocess);

useCluster = false;

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
         matlabbatch{23}.cfg_basicio.run_ops.runjobs.jobs{1} = ...
         regexprep(matlabbatch{23}.cfg_basicio.run_ops.runjobs.jobs{1}, ...
             'batch_report_quality\.m', 'batch_report_quality_no_figures\.m');
    end
    
    % save subject-specific batch in subject-folder, but as mat-file for
    % simplicity
    save(fullfile(paths.preproc.output.batch, ...
        regexprep(paths.code.batch.fnPreprocess, '\.m', '\.mat')), ...
        'matlabbatch');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run matlabbatch...either interactively or on cluster
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if useCluster
    else
        spm_jobman('interactive', matlabbatch);
    end
    
end