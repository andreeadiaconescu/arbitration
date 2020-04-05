function pathOut = get_second_level_brain_images(iSubjectArray)
% computes mean of warped structural and mean functional images of all
% selected subjects
%
%   pathOut = get_second_level_brain_images(iSubjectArray)
%
% IN
%
% OUT
%
% EXAMPLE
%   get_second_level_mean_images
%
%   See also
 
% Author:   Lars Kasper
% Created:  2020-04-04
% Copyright (C) 2020 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%

if nargin < 1
    iSubjectArray =  setdiff([3:47], [14 25 31 32 33 34 37]); % 6 only excluded from neuroimaging analysis because of lack of physlog
end

fnStructArray = get_path_all_subjects('preproc.output.fnStruct', iSubjectArray);
fnFunctArray = get_path_all_subjects('preproc.output.fnWarpedMeanFunct', iSubjectArray);

paths = get_paths_wagad(iSubjectArray(1));

spm_imcalc(fnStructArray, paths.stats.secondLevel.fnMeanStruct, 'mean(X)', {1});  
spm_imcalc(fnFunctArray, paths.stats.secondLevel.fnMeanFunct, 'mean(X)', {1});
                
spm_imcalc(fnFunctArray, 'minIP.nii', 'min(X)', {1});
spm_imcalc(fnFunctArray, 'nSubjectsNonZero.nii', 'sum(X>0)', {1});


spm_check_registration(paths.stats.secondLevel.fnMeanStruct, ...
    paths.stats.secondLevel.fnMeanFunct, 'minIP.nii', 'nSubjectsNonZero.nii');