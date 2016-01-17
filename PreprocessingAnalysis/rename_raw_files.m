function output = rename_raw_files(paths)
%renames files for easier identification
%
%   output = rename_raw_files(input)
%
% IN
%
% OUT
%
% EXAMPLE
%   rename_raw_files
%
%   See also
%
% Author: Lars Kasper
% Created: 2013-10-09
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: tedit2.m 170 2013-03-13 15:32:09Z kasperla $

if nargin < 1
    paths = get_paths_pharm_data();
end
% paths = get_paths();
fnFunctRaw = paths.fnFunctRaw;
fnFunctRenamed = paths.fnFunctRenamed;

pathTemp = pwd;
cd(paths.raw)
% copyfile fm_09102013_1001320_5_1_wipt1w3dtfeanatsenseV42.nii struct.nii
% fnFunctRaw{1}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0088/data/raw/dm_21032014_0851080_12_1_wipfmri2x2_run1senseV42.nii';
% fnFunctRaw{1}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0085/data/raw/dm_27032014_1806200_8_1_wipfmri2x2_run1senseV42.nii';
% fnFunctRaw{1}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0101/data/raw/dm_27042014_1123310_12_1_wipfmri2x2_run1senseV42.nii';
% fnFunctRaw{2}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0101/data/raw/dm_27042014_1152290_14_1_wipfmri2x2_run2senseV42.nii';
% fnFunctRaw{4}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0101/data/raw/dm_27042014_1112110_9_1_fmri2x2_restsenseV42.nii';
% fnFunctRaw{4}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0121/data/raw/dm_10102014_0829060_8_1_fmri2x2_restsenseV42.nii';
% fnFunctRaw{1}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0125/data/raw/dm_26092014_1049180_11_1_wipfmri2x2_run1senseV42.nii';
% fnFunctRaw{5}='/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0125/data/raw/dm_26092014_0945000_3_1_fmri2x2_phantom_shortsensV42.nii';
for i = 1:length(fnFunctRaw)
    fprintf('copying %s to \n %s\n', fnFunctRaw{i}, fnFunctRenamed{i});
    copyfile(fnFunctRaw{i}, fnFunctRenamed{i});
end


mkdir(paths.funct);
mkdir(paths.struct);
mkdir(paths.sess1);
mkdir(paths.sess2);

movefile(fullfile(paths.raw, 'funct*.nii'), paths.funct);
movefile(fullfile(paths.funct, 'funct_run1.nii'), paths.sess1);
movefile(fullfile(paths.funct, 'funct_run2.nii'), paths.sess2);

movefile(fullfile(paths.raw, 'struct*.nii'), paths.struct);

cd(pathTemp);