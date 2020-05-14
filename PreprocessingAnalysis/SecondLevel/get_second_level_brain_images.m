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
    iSubjectArray =  setdiff([3:47], [14 25 30 31 32 33 34 37 40]); 
    % 6 only excluded from neuroimaging analysis because of lack of physlog
    % 30 and 40 have artifacts
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

function dmpad_check_correlations_regressors(options)
options.firstLevelDesignName = 'Control';
        
for iSub = 1: numel(options.subjectIDs)
    id = char(options.subjectIDs{iSub});
    details = dmpad_subjects(id,options);
    load(fullfile(details.firstLevel.sensor.pathStats, '/SPM.mat'));
    GLM=SPM.xX.xKXs.X;
    nConstrats = numel(options.secondlevelRegressors);
    nComputationalQuantities = nConstrats-1;
    GLM=GLM(:,[2:nConstrats]);
    corrMatrix    = corrcoef(GLM);
    z_transformed = dmpad_fisherz(reshape(corrMatrix,nComputationalQuantities^2,1));
    averageCorr{iSub,1}=reshape(z_transformed,nComputationalQuantities,...
        nComputationalQuantities);
end
save(fullfile(options.secondlevelDir.classical, 'regressors_averagecorr_Fisherz.mat'),'averageCorr','-mat');

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = dmpad_ifisherz(reshape(averageZCorr,nComputationalQuantities^2,1));
finalCorr = reshape(averageGroupCorr,nComputationalQuantities,...
        nComputationalQuantities);
figure;imagesc(finalCorr);
caxis([-1 1]);
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));
end