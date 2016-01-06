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
    iSubjectArray = 3;
end

for iSubj = iSubjectArray
    paths = get_paths_wagad(iSubj);
    
    %% Split realignment parameter file into 2 
    nVols(1) = load(fullfile(paths.sess1, 'nvols.txt'));
    nVols(2) = load(fullfile(paths.sess2, 'nvols.txt'));
    fileRealignConcat = ls(fullfile(paths.preproc.output.sess1, 'rp_*funct_run1.txt'));
    fileRealignConcat(end) = []; % remove new line character
    realignParamsConcat = ...
        load(fileRealignConcat);
    realignParamsSess1 = realignParamsConcat(1:nVols(1), :);
    realignParamsSess2 = realignParamsConcat(nVols(1)+(1:nVols(2)), :);
    
    save(fullfile(paths.preproc.output.sess1, 'rp_run1_split.txt'), ...
        'realignParamsSess1', '-ASCII')
    save(fullfile(paths.preproc.output.sess2, 'rp_run2_split.txt'), ...
        'realignParamsSess2', '-ASCII')
    
    %% load PhysIO batch, adapt parameters and run
    
end
