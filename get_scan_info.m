function scanInfo = get_scan_info(fnFunctionalArray, inputTR)
% Returns fMRI scan dimensions and timing for all sessions
%
%   scanInfo = get_scan_info(fnFunctionalArray)
%
% IN
%   fnFunctionalArray   cell(nRuns,1) of
%                       either
%                           paths of functional sessions, where
%                           nVols.txt, nSlices.txt, nVoxels.txt, TR.txt exists
%                       or
%                           full-path file names of 4D-nifti-files for each
%                           session
%   inputTR             TR in seconds (hard-coded input written to file, at
%                       the moment, in principle, could be read from nifti)
% OUT
%   scanInfo            structure of scan information containing
%           .nVols      number of volumes
%           .nSlices    number of slices
%           .nVoxels    number of x/y/z/t voxels
%           .TR         TR (in seconds)...NOTE: this is hard-coded right
%                       now from a second input parameter
%           .TA         time of acquisition (for slice-timing correction)
%                       = TR * (1-1/nSlices);
%
% EXAMPLE
%   get_scan_info
%
%   See also get.paths_wagad
%
% Author:   Lars Kasper
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
% $Id: new_function2.m 354 2013-12-02 22:21:41Z kasperla $

if nargin < 1
    paths = get_paths_wagad(3);
    fnFunctionalArray = ...
        strcat(paths.dirSess, filesep, paths.fnFunctRenamed);
end

if nargin < 2
    inputTR = 2.65781;
end

inputsArePaths = isdir(fnFunctionalArray{1});


nRuns = numel(fnFunctionalArray);
for iRun = 1:nRuns
    
    %% Define file names where info is stored
    if inputsArePaths
        pathFunctional = fnFunctionalArray{iRun};
    else
        pathFunctional = fileparts(fnFunctionalArray{iRun});
    end
    
    fnSli = fullfile(pathFunctional, 'nSlices.txt');
    fnVols = fullfile(pathFunctional, 'nVols.txt');
    fnVoxels = fullfile(pathFunctional, 'nVoxels.txt');
    fnTr = fullfile(pathFunctional, 'TR.txt');
    
    hasInfoFiles = exist(fnSli, 'file') & exist(fnVols, 'file') & ...
        exist(fnVoxels, 'file') & exist(fnTr, 'file');
    
    %% slow reading from image files of infos only, if no small text files exist
    if ~hasInfoFiles
        V = spm_vol(fnFunctionalArray{iRun});
        nVols = numel(V);
        nVoxels = V(1).dim;
        nSlices = V(1).dim(3);
        TR = inputTR;
        
        save(fnSli, 'nSlices', '-ASCII');
        save(fnVols, 'nVols', '-ASCII');
        save(fnVoxels, 'nVoxels', '-ASCII');
        save(fnTr, 'TR', '-ASCII');
        
    else
        %% if pre-existing info files, use those!
        load(fnSli);
        load(fnVols);
        load(fnVoxels);
        load(fnTr);
    end
    
    TA = TR*(1-1/nSlices);
    scanInfo.TR(iRun) = TR;
    scanInfo.nSlices(iRun) = nSlices;
    scanInfo.nVols(iRun) = nVols;
    scanInfo.nVoxels(iRun, :) = nVoxels;
    scanInfo.TA(iRun) = TA;
end