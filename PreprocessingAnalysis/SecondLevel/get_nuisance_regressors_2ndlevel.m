function [nuisanceRegressors, iRowSubjects] = ...
    get_nuisance_regressors_2ndlevel(paths, iSubjectArray)
% returns nuisance regressors for specified subjects
%   Note: The specific fiel format is assumed to have subject ids in the
%   first column, and numbers in all others (e.g. from database export to
%   excel)
%
%   nuisanceRegresors = get_nuisance_regressors_2ndlevel(paths, iSubjectArray)
%
% IN
%   paths   structure of important paths and string patterns in this study
%           See also get_paths_wagad
%           in particular, the following items are needed
%               paths.stats.secondLevel.fnNuisanceRegressors
%               paths.nameMaskSubject
%
% OUT
%   nuisanceRegressors  [nSubjects, nRegressors] nuisance regressor matrix
%                       for all selected subjects
%   iRowSubjects        rows in given text file where nuisance regressors
%                       for specified subjects were found
%
% EXAMPLE
%   get_nuisance_regressors_2ndlevel
%
%   See also
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
if nargin < 1 || isempty(paths)
    paths = get_paths_wagad();
end

% read file into cell of strings, line by line
fnNuisanceRegressors = paths.stats.secondLevel.fnNuisanceRegressors;
fid = fopen(fnNuisanceRegressors, 'r');
C = textscan(fid, '%s', 'Delimiter', '\n');
stringRowsFile = C{1};
fclose(fid);

if nargin < 2
    iSubjectArray = get_subject_ids()';
end

nSubjects = numel(iSubjectArray);
nuisanceRegressors = [];
iRowSubjects = zeros(nSubjects, 1);
for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    idSubj = sprintf(paths.patternIdSubj, iSubj);
    iRowSubjects(s) = tapas_physio_find_string(stringRowsFile, idSubj);
    
    % remove subject id from row, read in rest of row as numbers
    rowRegressors = textscan(regexprep(stringRowsFile{iRowSubjects(s)}, ...
        idSubj, ''), '%f');
    
    % create nuisance array now that we know how many columns we need:
    if s == 1
        nuisanceRegressors = zeros(nSubjects, numel(rowRegressors{1}));
    end
    
    nuisanceRegressors(s,:) = rowRegressors{1};
end
