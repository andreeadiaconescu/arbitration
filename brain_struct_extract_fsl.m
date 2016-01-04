setenv('FSLDIR', '/usr/share/fsl/5.0')
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
% system(['. ${FSLDIR}/etc/fslconf/fsl.sh']);
pathFunct = '/terra/workspace/adiaconescu/studies/social_learning_pharma/data/DMPAD_0002/data/struct/'; 
fileIn= fullfile(pathFunct, 'struct.nii');
fileOut = fullfile(pathFunct, 'struct_noskull.nii');


cmdStr = [ '. ${FSLDIR}/etc/fslconf/fsl.sh;', ...
'/usr/share/fsl/5.0/bin/bet ' ...
fileIn, ' ', ...
fileOut, ' ', ...
'-S -f 0.5 -g 0'];

disp(cmdStr);
system(cmdStr);

cmdStr2 = [
 'gunzip ' ...   
 fileOut '.gz'
];

system(cmdStr2);
