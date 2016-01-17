function varargout = update_matlabbatch_paths(fileBatch, pathsOld, pathsNew, ...
    fileBatchNew)
% Update absolute paths in SPM batch file (.m) with new paths
%
%   matlabbatch = update_matlabbatch_paths(fileBatch, pathsOld, pathsNew, ...
%    fileBatchNew)
%
% NOTE: Also takes care of different file separators between Linux/Mac (/)
% and Windows (\)
%
% IN
%   fileBatch   SPM batch file (.m) to be read
%   pathsOld    string or cell(nPaths,1) of
%               old paths (or array of paths) that shall be updated
%   pathsNew    string or cell(nPaths,1) of
%               new paths (or array of paths) that shall replace the ones
%               in pathsOld
%   fileBatchNew
%               name of new batch file with updated paths
%               default: empty, 
%                        i.e. the altered version is not saved, but the
%                        corresponding output matlabbatch is returned
%
% OUT
%   matlabbatch if output argument is specified, this matlabbatch will
%               contained all the altered parts
% EXAMPLE
%   matlabbatch = update_matlabbatch_paths('mb_realign.m', pathSpmOld,
%               pathSpmNew, 'mb_realign_new_laptop.m')
%
%   See also
%
% Author: Lars Kasper
% Created: 2015-01-29
% Copyright (C) 2015 TNU, Institute for Biomedical Engineering, University of Zurich and ETH Zurich.
%
% This file is part of the TAPAS PhysIO Toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%
% $Id: update_matlabbatch_paths.m 734 2015-03-26 15:40:33Z kasperla $



%% Set up input arguments, check format
if nargin < 1
    fileBatch = '/Users/kasperla/Dropbox/Conferences/SPMZurich15/PracticalsPhysIOPreprocessing/example_physio_short/raw/batch/batch_realign.m';
end

if nargin < 4 || isempty(fileBatchNew)
    [p,f,ext] = fileparts(fileBatch);
    fileBatchNew = fullfile(p, ['updated_' f ext]);
    doSaveNewBatch = false;
else
    doSaveNewBatch = true;
end

if nargin < 3
    pathsNew = {
        'pathNew'
        'dirNew'
        };
end

if nargin < 2
    pathsOld ={
        '/Users/kasperla/Dropbox/Conferences/SPMZurich15'
        'PracticalsPhysIOPreprocessing/example_physio_short'
        };
end




if ~iscell(pathsOld);
    pathsOld = {pathsOld};
end

if ~iscell(pathsNew)
    pathsNew = {pathsNew};
end

nPaths = numel(pathsOld);



%% read in m-file line by line, including newline-character (easier for
% fprintf later on)


fid = fopen(fileBatch);

l = 1;
tlines{l} = fgets(fid);

while ischar(tlines{l})
    l           = l+1;
    tlines{l}   = fgets(fid);
end

% remove last line since it is empty
nLines          = l-1;
tlines(l)       = [];
fclose(fid);

% replace old paths with new lines for all lines at once, and looped over
% paths

hasBackslashNew = ~strcmp(filesep, '/');

for p = 1:nPaths
    
    if hasBackslashNew
        % have to replace \ by \\ for replacements
        pathsNew{p} = regexprep(pathsNew{p}, '\\', '\\\\');
    end
    
    hasBackslashOld = any(regexp(pathsOld{p}, '\\'));
    
    if hasBackslashOld
        pathsOld{p} = regexprep(pathsOld{p}, '\\', '\\\\');
    end
    
    tlines = regexprep(tlines, pathsOld{p}, pathsNew{p});
end


if hasBackslashNew
    % have to replace \ by \\ to be fprintf correctly
    tlines = regexprep(tlines, '\\', '\\\\');
    tlines = regexprep(tlines, '/', '\\\\');
end

% also duplicate %, sice they have to occur twice to be printed correctly
tlines = regexprep(tlines, '%', '%%');

%% Write new file with replaced lines

fid = fopen(fileBatchNew, 'w');
for l = 1:nLines
    fprintf(fid, tlines{l});
end

fclose(fid);

% return updated matlabbatch
if nargout
    run(fileBatchNew);
    varargout{1} = matlabbatch;
end

% delete new batch m-file, if unwanted
if ~doSaveNewBatch
    delete(fileBatchNew);
end