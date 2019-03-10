function itemArray = get_path_all_subjects(stringItem, iSubjectArray,idDesign)
% returns an item of the paths-structure for all subjects, e.g. contrast
% files from 1st level analysis for 2nd level analysis
%
%   output = get_path_all_subjects(input)
%
% IN
%   stringItem      string with sub-structure of paths, e.g. 'glm.design'
%   iSubjectArray   [1, nSubjects] specify for which subjects item is
%                   returned; default: all existing subjects in study
%                   folder
% OUT
%   itemArray       cell (nSubjects,1) of requested item for all specified
%                   subjects
%
% EXAMPLE
%   pathsGlmDesigns = get_path_all_subjects('stats.glm.design')
%    %   => returns {
%                   subj01/glm/currentDesign
%                   subj02/glm/currentDesign]
%                   etc.
%                   }
%
%   See also get_paths_wagad
%
% Author:   Lars Kasper
% Created:  2016-02-06
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

% get one subject paths info and replace relevant part of filename to
% generate paths for all subjects
if nargin < 1
    stringItem = 'stats.glm.design';
end

if nargin < 2
    iSubjectArray = get_subject_ids()';
end

if nargin < 3
    idDesign = 2; % GLM design matrix selection by Id See also get_paths_wagad which folder it is 
end

idPreproc = 1;
paths = get_paths_wagad(iSubjectArray(1), idPreproc,idDesign);
nSubjects = numel(iSubjectArray);
itemArray = cell(nSubjects, 1);
for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    
    % replace subject specific directory
    itemArray{s} = regexprep(...
        eval(sprintf('paths.%s',stringItem)), ...
        paths.idSubj, sprintf(paths.patternIdSubj, iSubj));
    
    % replace subject-specific file prefix
    itemArray{s} = regexprep(itemArray{s}, paths.idSubjBehav, ...
        sprintf(paths.patternIdSubjBehav, iSubj));
end