function multiple_regressors = get_multiple_regressors_physio(iSubjectArray)
% computes PhysIO regressors and assembles with pre-existing realignment
% parameters to 1 concatenated multiple_regressors-matrix for both sessions
%
%  multiple_regressors = get_multiple_regressors_physio(iSubjectArray)
%
% NOTE: splits realignment file into 2 sessions to be used with physio
%
% IN
%   iSubjectArray   indices of subjects where computation shall occur
% OUT
%   multiple_regressors
%                   concatenated (for both sessions) physiological
%                   regressors
%   
% EXAMPLE
%   get_multiple_regressors_physio
%
%   See also
%
% Author:   Lars Kasper
% Created:  2016-01-06
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
% $Id: new_function2.m 354 2013-12-02 22:21:41Z kasperla $

if nargin < 1
    iSubjectArray = get_subject_ids()';
end

for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Split realignment parameter file into 2 for PhysIO
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nVols(1) = load(fullfile(paths.sess1, 'nvols.txt'));
    nVols(2) = load(fullfile(paths.sess2, 'nvols.txt'));
    realignParamsConcat = ...
        load(paths.preproc.output.fnRealignConcat);
    realignParamsSess1 = realignParamsConcat(1:nVols(1), :);
    realignParamsSess2 = realignParamsConcat(nVols(1)+(1:nVols(2)), :);
    
    save(paths.preproc.output.fnRealignSession{1}, ...
        'realignParamsSess1', '-ASCII')
    save(paths.preproc.output.fnRealignSession{2}, ...
        'realignParamsSess2', '-ASCII')
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% For each Run load PhysIO batch, adapt parameters and run
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for iRun = 1:2
        clear matlabbatch
        run(fullfile(paths.code.batches, paths.code.batch.fnPhysIO));
        
        % path to save multiple regressors, physio object and output figures
        matlabbatch{1}.spm.tools.physio.save_dir = ...
            {paths.preproc.output.physio};
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = ...
            paths.fnPhyslogRenamed(iRun);
        matlabbatch{1}.spm.tools.physio.log_files.respiration = ...
            matlabbatch{1}.spm.tools.physio.log_files.cardiac;
        matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = nVols(iRun);
        
        % adapt run-specific file names
        matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors =...
            sprintf('multiple_regressors_run%d.txt', iRun);
        matlabbatch{1}.spm.tools.physio.model.output_physio = ...
            sprintf('physio_run%d.mat', iRun);
        matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = ...
            sprintf('physio_run%d.fig', iRun);
        matlabbatch{1}.spm.tools.physio.model.movement.yes.file_realignment_parameters = ...
            paths.preproc.output.fnRealignSession(iRun);
        
        %save batch to subject-specific folder
        fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnPhysIO');
        % append current run to file name
        fnBatchSave = regexprep(fnBatchSave, '\.mat', ['_run' int2str(iRun) '\.mat']);
        save(fnBatchSave, 'matlabbatch');
        
        spm_jobman('run', matlabbatch);
    end

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Concatenate multiple regressor files and save to behav-folder, 
    %   where multiple_conditions reside, add regressors of Ones for 1st
    %   session
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % concat mult reg
    for iRun = 1:2
        multipleRegressorsSess{iRun,1} = load(fullfile(paths.preproc.output.physio,...
            sprintf('multiple_regressors_run%d.txt', iRun)));
    end
    multipleRegressorsConcat = cell2mat(multipleRegressorsSess);
    
    % add column of ones for 1st session
    multipleRegressorsConcat(:,end+1) = 0;
    multipleRegressorsConcat(1:nVols(1),end) = 1;
    
    save(paths.fnMultipleRegressors, ...
        'multipleRegressorsConcat', '-ASCII')
    
end
