function reorder_matlabbatch(fileBatch, indexOld, indexNew, ...
    fileBatchNew)
% reorders matlabbatch modules (e.g. inserting a new module), taking care of changed
% dependencies
%
%   reorder_matlabbatch(fileBatch, indexOld, indexNew, ...
%    fileBatchNew)
%
% NOTE: This can be used, if a new module shall be inserted into an
% existing matlabbatch. Simply add the new module with correct dependencies
% at the end, save the batch, and then run this module, specifying where
% the module should end up.
%
% WARNING: Only simple dependencies are taken care of. Dependency names are
% not updated (still, this should work, but can be confusing when reviewing
% the batch)
%
%
% IN
%   fileBatch   SPM batch file (.m) to be read
%   indexOld    [1, nReorderedModules]
%               indices of matlabbatch modules that shall be inserted somewhere
%               else
%   indexOld    [1, nReorderedModules]
%               new indices of matlabbatch modules that shall be reordered
%   fileBatchNew
%               name of new batch file
%               default: 'updated_'fileBatch
%
% OUT
%
% EXAMPLE
%   reorder_matlabbatch('my_batch.m', [10 11], [3 5] 'my_batch.m');
%   => puts module #10 at position 3 in the batch, and module #11 at
%   position 5, updating the necessary dependency numbers
%
%   See also
%
% Author: Lars Kasper
% Created: 2015-06-06
% Copyright (C) 2015 TNU, Institute for Biomedical Engineering, University of Zurich and ETH Zurich.
%
% This file is part of the TAPAS PhysIO Toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%
% $Id: reorder_matlabbatch.m 734 2015-03-26 15:40:33Z kasperla $



%% Set up input arguments, check format
if nargin < 1
    fileBatch = '/Users/kasperla/Dropbox/Conferences/SPMZurich15/PracticalsPhysIOPreprocessing/example_physio_short/raw/batches/demo02_compare_batch_quality/batch_preproc_fmri_stc_realign.m';
end

if nargin < 4
    [p,f,ext] = fileparts(fileBatch);
    fileBatchNew = fullfile(p, ['updated_' f ext]);
end

if nargin < 3
    indexNew = [3 4];
end

if nargin < 2
    indexOld = [17 18];
end



nReorderedModules = numel(indexOld);



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

for iModule = 1:nReorderedModules
    
   iOld = indexOld(iModule);
   iNew = indexNew(iModule);
    
   % Find all lines with 
   %    a) sub-string matlabbatch{XY}, and extract the number of the module
   %    b) sub-string indicating a dependency, i.e. substruct\(''.'',''val'', ''{}'',{([0-9]*)}
   %       and extract dependency number
   exprMatlabbatch = 'matlabbatch\{([0-9]*)\}';
   exprDependency = 'substruct\(''\.'',''val'', ''\{\}'',\{([0-9]*)\},';

   % line-wise strings of batch module id and, if existing, dependency id
        idModuleArray = regexp(tlines, exprMatlabbatch, 'tokens');
        idDependencyArray = regexp(tlines, exprDependency, 'tokens');
        
        % replace lines from the end, according to the following scheme:
        
        % First, replace iOld by 0 (unused index!)
        
        % index iOld > iNew:
        % increase all module and dependency ids in [iNew, iOld-1] by 1
        % leave others untouched
        
        % index iNew > iOld
        % decrease all module and dependency ids in [iOld + 1, iNew] by 1
        
        % Finally, replace 0 by iNew
        
        mbOld = sprintf('matlabbatch\\{%d\\}', iOld); % \\ to really print one \ escape character for regexprep confusion avoidance
        mbZero = sprintf('matlabbatch\\{%d\\}', 0);
        mbNew = sprintf('matlabbatch\\{%d\\}', iNew);

        % \\ to enable some escape characters to be printed for regexprep
        depOld = sprintf('substruct\\(''\\.'',''val'', ''\\{\\}'',\\{%d\\},', iOld);
        depZero = sprintf('substruct\\(''\\.'',''val'', ''\\{\\}'',\\{%d\\},', 0);
        depNew = sprintf('substruct\\(''\\.'',''val'', ''\\{\\}'',\\{%d\\},', iNew);

        % replace module and dependency id of iOld with 0s
        tlines = regexprep(tlines, mbOld, mbZero);
        tlines = regexprep(tlines, depOld, depZero);
        
        % for each line, check the current value of module number and
        % dependency, and adapt according to rules above, i.e.
        %
        % index iOld > iNew:
        % increase all module and dependency ids in [iNew, iOld-1] by 1
        % leave others untouched
        
        % index iNew > iOld
        % decrease all module and dependency ids in [iOld + 1, iNew] by 1
        
        for l = nLines:-1:1
            stringIdModule = idModuleArray{l};
            stringIdDependency = idDependencyArray{l};
            
            if ~isempty(stringIdModule)
                idxModule = str2num(stringIdModule{1}{1});
                idxModuleNew = get_new_index(idxModule, iOld, iNew);
                tlines{l} = regexprep(tlines{l}, ...
                    sprintf('matlabbatch\\{%d\\}', idxModule), ...
                    sprintf('matlabbatch\\{%d\\}', idxModuleNew));
            end
            
            if ~isempty(stringIdDependency)
                idxModule = str2num(stringIdDependency{1}{1});
                idxModuleNew = get_new_index(idxModule, iOld, iNew);
                tlines{l} = regexprep(tlines{l}, ...
                    sprintf('substruct\\(''\\.'',''val'', ''\\{\\}'',\\{%d\\},', idxModule), ...
                    sprintf('substruct\\(''\\.'',''val'', ''\\{\\}'',\\{%d\\},', idxModuleNew));
            end
            
        end
    
         % replace module and dependency id 0 (placeholder) with iNew
        tlines = regexprep(tlines, mbZero, mbNew);
        tlines = regexprep(tlines, depZero, depNew);
      
end


tlines = regexprep(tlines, '\\', '\\\\');

if ispc
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

end

%% Local Functions
%% calculates new index, if index iOld was shifted to iNew
% This takes care of shifts forward/backward
function idxModuleNew = get_new_index(idxModule, iOld, iNew);

if iNew > iOld && ...
        idxModule >= iOld +1 && ...
        idxModule <= iNew
    idxModuleNew = idxModule - 1;
elseif iNew < iOld && ...
        idxModule >= iNew && ...
        idxModule <= iOld - 1
    idxModuleNew = idxModule + 1;
else
    idxModuleNew = idxModule;
    
end
end