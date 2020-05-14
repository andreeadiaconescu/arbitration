% Script wagad_report_preproc_quality
% Loads preproc time series stats for multiple subjects, plots and saves to PS-file
%
%
%  wagad_report_preproc_quality
%
%
%   See also batch_report_quality_no_figures batch_preprc_fmri_realign_stc
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
%% Parameter settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


paths = get_paths_wagad();


if ismac
    iSubjectArray = get_subject_ids(paths.study, 'test_')';
else
    iSubjectArray = get_subject_ids(paths.study)';
end


stringDate = datestr(now(), 'yyyy_mm_dd_HHMMSS');
fileQualityReportPs = fullfile(paths.summary, ...
    sprintf('%s_report_preproc.ps', stringDate));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iSubj = iSubjectArray
    
    paths = get_paths_wagad(iSubj);
    fs = filesep;
    
    %% find report directories
    dirPreprocSteps = dir(paths.preproc.output.report);
    dirPreprocSteps = {dirPreprocSteps.name}';
    iValidDirs = find(~cell2mat(cellfun(@isempty, ...
        regexp(dirPreprocSteps, '^\d{2}_.*'), 'UniformOutput', false)));
    dirPreprocSteps = dirPreprocSteps(iValidDirs);
    nPreprocSteps = numel(dirPreprocSteps);
    
    %% Decide whether raw or processed structural file shall be used for display alongside functional
    % Note that raw is the first step!
    iStepUsePreprocessedStruct = 4;
    
    fileStructArray = cell(nPreprocSteps, 1);
    fileStructArray(1:iStepUsePreprocessedStruct-1) = ...
        repmat({paths.preproc.input.fnStruct}, iStepUsePreprocessedStruct - 1, 1);
    
    fileStructArray(iStepUsePreprocessedStruct:nPreprocSteps) = ...
        repmat({paths.preproc.output.fnStruct}, nPreprocSteps-iStepUsePreprocessedStruct+1, 1);
    
    %% loop over all preproc steps
    for iPreprocStep = 1:nPreprocSteps
        
        %
        fileReportArray = {
            'mean.nii'
            'sd.nii'
            'snr.nii'
            'diffOddEven.nii'
            'maxAbsDiff.nii'
            };
        
        % prepend paths
        fileReportArray = strcat(paths.preproc.output.report, fs,...
            dirPreprocSteps{iPreprocStep}, fs, fileReportArray);
        
        % add functional files for reporting
        fileReportArray = [
            fileStructArray{iPreprocStep};
            fileReportArray];
        
        
        % call CheckReg with selected files
        spm_check_registration(fileReportArray{:});
        
        stringTitle = sprintf('%s - %s', paths.idSubjBehav, dirPreprocSteps{iPreprocStep});
        suptitle(stringTitle);
        
        % save to selected PS file
        spm_print(fileQualityReportPs);
        
    end
    
end