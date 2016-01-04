function brain_extract_fsl(pathFunct, fnRun)
% IN
%   pathFunct   full path to directory holding functional file
%   fnRun       file name of run

setenv('FSLDIR', '/usr/share/fsl/5.0')
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
% system(['. ${FSLDIR}/etc/fslconf/fsl.sh']);

if nargin < 1
    pathFunct = '/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0072/data/funct/rest'; 
end

if nargin < 2
    fnRun = 'funct_rest.nii';
end
fileIn= fullfile(pathFunct, fnRun);
fileOut = fullfile(pathFunct, 'funct.nii');
fileMask = fullfile(pathFunct, 'funct_mask.nii');
fileMaskOut=fullfile(pathFunct, 'mean_funct_mask.nii');

cmdStr = [ '. ${FSLDIR}/etc/fslconf/fsl.sh;', ...
'/usr/share/fsl/5.0/bin/bet ' ...
fileIn, ' ', ...
fileOut, ' ', ...
'-F -f 0.5 -g 0'];
disp(cmdStr);
system(cmdStr);

cmdStr2 = [
 'gunzip ' ...   
 fileOut '.gz'
];

system(cmdStr2);

cmdStr3 = [
 'gunzip ' ...   
 fileMask '.gz'
];
system(cmdStr3);

cmdStr4 = ['. ${FSLDIR}/etc/fslconf/fsl.sh;', ...
'/usr/share/fsl/5.0/bin/fslmaths ' ...   
 fileMask, ' ', ...
 '-Tmean ', ...
 fileMaskOut
];
system(cmdStr4);

cmdStr5 = [
 'gunzip ' ...   
 fileMaskOut '.gz'
];

system(cmdStr5);


