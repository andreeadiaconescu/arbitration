function [nameScriptCluster, fileScriptCluster] =  ...
    submit_job_cluster_functioncall(paths, functionName, inputArgumentArray, jobQueue)
% Creates matlab script file that adds paths, calls function, and submits to cluster
%
%   [nameScriptCluster, fileScriptCluster] =  ...
%       submit_job_cluster_functioncall(functionHandle, inputArgumentArray, pathsToAdd,jobQueue)
%
% The script executes the matlabbatch in a new Matlab instance
%
% IN
%
%   paths               Path structure with spm-directory, location of batch files
%                       and cluster script storage directory
%                       See also get_paths_wagad
%   functionName      string or handle @functionName that should be executed
%   inputArgumentArray  cell(nArguments,1) of input arguments for function
%                       Handle; leave {}, if none needed
%   pathsToAdd          cell(nPaths,1) of paths that should be added on
%                       cluster
%   jobQueue            'vip' or 'public' - lsf job queue to which job is
%                       submitted; default: vip
%
% OUT
%   nameScriptCluster   file name of generated script executing matlabbatch
%                       (includes time stamp)
%   fileScriptCluster full path to generated script, with file suffix .m
%
% EXAMPLE
%   submit_job_cluster_functioncall(paths, 'get_multiple_conditions', {3})
%
%   See also
%
% Author:   Lars Kasper
% Created:  2016-01-10
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

% assemble script-m-file to be executed via new matlab instance
% created on brutus node
if nargin < 1
    paths = get_paths_wagad(3);
end

if nargin < 2
    functionName = 'get_multiple_conditions';
end

if nargin < 3
    inputArgumentArray = {3};
end

if nargin < 4
    jobQueue = 'vip';
end

% TODO: the following can be done via more general input parameters
% paths to be added WITHOUT subfolders
pathsToAddArray = {
    paths.code.spm
    };

% paths to be added WITH subfolders
pathsToAddGenArray = {
    paths.code.project
    };

if ~ischar(functionName)
    functionName = func2str(functionName);
end

nameScriptCluster = sprintf('run_%s_%s_%s', ...
     paths.idSubjBehav, functionName, datestr(now, 'yyyy_mm_dd_HHMMSS'));
 
fileScriptCluster = fullfile(paths.cluster.scripts, ...
    [nameScriptCluster '.m']);

% Create Script file that has to run function
fid = fopen(fileScriptCluster, 'w+');

% print the paths to add into script
nPaths = numel(pathsToAddArray);
for p = 1:nPaths
   fprintf(fid, 'addpath %s;\n', pathsToAddArray{p});
end

nPaths = numel(pathsToAddGenArray);
for p = 1:nPaths
   fprintf(fid, 'addpath(genpath(''%s''));\n', pathsToAddGenArray{p});
end

%% Assemble argument string
nArguments = numel(inputArgumentArray);
stringInputParameters = '';
for iArgument = 1:nArguments
   currentArg = inputArgumentArray{iArgument};
   
   if isnumeric(currentArg)
        stringInputParameters = [stringInputParameters ...
            sprintf('%s', num2str(currentArg))];
   else % print strings with ''
        stringInputParameters = [ stringInputParameters ...
            sprintf('''%s''', num2str(currentArg))];     
   end
      
   % add comma, if not last argument
   if iArgument < nArguments
       stringInputParameters = [stringInputParameters ', '];
   end
   
end

% print function name and arguments
fprintf(fid, '%s(%s);\n', functionName, stringInputParameters);

fclose(fid);

%% Submit execution of job to brutus]
switch jobQueue
    case 'vip' % asks for more memory
        cmdSubmit = sprintf(['cd %s; bsub -q vip.36h -R "rusage[mem=8192]" -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
            '-r %s; cd %s'], paths.cluster.scripts, ...
            nameScriptCluster, nameScriptCluster, pwd);
    case 'pub'
        cmdSubmit = sprintf(['cd %s;bsub -q pub.1h -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
            '-r %s; cd %s'], paths.cluster.scripts, ...
            nameScriptCluster, nameScriptCluster, pwd);
end
disp(cmdSubmit);
unix(cmdSubmit);