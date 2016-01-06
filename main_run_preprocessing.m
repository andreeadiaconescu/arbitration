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

% manual setting...if you want to exclude any subjects
iSubjectArray = setdiff(iSubjectArray, [14]);

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
    fnBatchSave = paths.code.batch.fnPreprocess;
    fnBatchSave(end-1:end) = []; % remove .m
    
    % add time stamp & path
    stringDate = datestr(now(), 'yyyy_mm_dd_HHMMSS');
    fnBatchSave = sprintf('%s_%s.mat', fnBatchSave, ...
        stringDate);
    fnBatchSave = fullfile(paths.preproc.output.batch, ...
        fnBatchSave);
    
    save(fnBatchSave, 'matlabbatch');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run matlabbatch...either interactively or on cluster
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if useCluster
        % assemble script-m-file to be executed via new matlab instance
        % created on brutus node
        nameScriptBrutus = sprintf('run_%s_%s_%s', ...
            paths.code.batch.fnPreprocess(1:end-2), paths.idSubjBehav, ...
            stringDate);
        fileScriptBrutus = fullfile(paths.cluster.scripts, ...
            [nameScriptBrutus '.m']);
        
        % Script file has to run
        fid = fopen(fileScriptBrutus, 'w+');
        fprintf(fid, [ ...
            'addpath %s;\n' ...
            'spm_get_defaults(''modality'', ''FMRI'');\n' ...
            'spm_get_defaults(''cmdline'', 1);\n' ...
            'spm_jobman(''initcfg'');\n' ...
            'spm_jobman(''run'', ''%s'');\n' ...
            ], ...
            paths.code.spm, fnBatchSave);
        fclose(fid);
        
        % Submit execution of job to brutus]
        jobQueue = 'vip';
        switch jobQueue
            case 'vip' % asks for more memory
                cmdSubmit = sprintf(['cd %s; bsub -q vip.36h -R "rusage[mem=8192]" -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
                    '-r %s; cd %s'], paths.cluster.scripts, ...
                    nameScriptBrutus, nameScriptBrutus, pwd);
            case 'pub'
                cmdSubmit = sprintf(['cd %s;bsub -q pub.1h -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
                    '-r %s; cd %s'], paths.cluster.scripts, ...
                    nameScriptBrutus, nameScriptBrutus, pwd);
        end
        disp(cmdSubmit);
        unix(cmdSubmit);
        
    else
        spm_jobman('run', matlabbatch);
    end
    
end