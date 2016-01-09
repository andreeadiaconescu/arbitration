function [nameScriptCluster, fileScriptCluster] =  ...
    submit_job_cluster_matlabbatch(paths, fnBatchSave, jobQueue)
% Creates matlab script file that executes matlabbatch, and submits to cluster
%
% [nameScriptCluster, fileScriptCluster] =  ...
%     submit_job_cluster_matlabbatch(paths, fnBatchSave, jobQueue)
%
% The script executes the matlabbatch in a new Matlab instance
%
% IN
%   paths           Path structure with spm-directory, location of batch files
%                   and cluster script storage directory
%                   See also get_paths_wagad
%   fnBatchSave     full path to batch file (.m/.mat) with
%                   matlabbatch-variable
%   jobQueue        'vip' or 'public' - lsf job queue to which job is
%                   submitted; default: vip
%
% OUT
%   nameScriptCluster file name of generated script executing matlabbatch
%   fileScriptCluster full path to generated script, with file suffix .m
%
% EXAMPLE
%   submit_job_cluster_matlabbatch
%
%   See also
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

% assemble script-m-file to be executed via new matlab instance
% created on brutus node
if nargin < 3
    jobQueue = 'vip';
end


[p, fnShort] = fileparts(fnBatchSave);
fnShort = regexprep(fnShort, '\.m.*', '');

nameScriptCluster = sprintf('run_%s_%s', ...
     paths.idSubjBehav, fnShort);
 
fileScriptCluster = fullfile(paths.cluster.scripts, ...
    [nameScriptCluster '.m']);

% Script file has to run
fid = fopen(fileScriptCluster, 'w+');
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