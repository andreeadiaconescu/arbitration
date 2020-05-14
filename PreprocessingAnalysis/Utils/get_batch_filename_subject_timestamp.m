function fnBatchSave = get_batch_filename_subject_timestamp(paths, fnBatchItemString)
% creates filename of subject specific batch, including template name and time stamp
%
%   fnBatchSave = get_batch_filename_subject_timestamp(paths, fnBatchItemString)
%
% IN
%   paths   See also get_paths_wagad
%   fnBatchItemString   The item name of the corresponding batch in
%                       paths.code.batch, 
%                       e.g. fnPhysio, fnPreprocess
%
% OUT
%
% EXAMPLE
%   fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnPreprocess')
%
% fnBatchSave =
%
%    '/WAGAD/test_0003/batches/batch_preproc_fmri_realign_stc_2016_01_06_154019.mat'
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
fnBatchSave = paths.code.batch.(fnBatchItemString);
fnBatchSave(end-1:end) = []; % remove .m

% add time stamp & path
currentTime = now();
stringDate = datestr(currentTime, 'yyyy_mm_dd_HHMMSS');
fnBatchSave = sprintf('%s_%s.mat', fnBatchSave, ...
    stringDate);

maxBatchNameLength = namelengthmax - 15; %-15 for run_WAGAD_0004_ etc. prefix later
% Matlab variable length limit of 63 prevent -r call to long script name
if numel(fnBatchSave) > maxBatchNameLength % 
    
    % try shorter date identifier first
    stringDate = datestr(currentTime, 'yymmdd_HHMMSS');
    fnBatchSave = sprintf('%s_%s.mat', fnBatchSave, ...
        stringDate);
    
    % shorten script name as well...could create collisions with similarly
    % named scripts...
    if numel(fnBatchSave) > maxBatchNameLength
         fnBatchSave = sprintf('%s_%s.mat', ...
             fnBatchSave(1:(maxBatchNameLength-numel(stringDate)-1)), ...
        stringDate);
    
    end
end

fnBatchSave = fullfile(paths.preproc.output.batch, ...
    fnBatchSave);