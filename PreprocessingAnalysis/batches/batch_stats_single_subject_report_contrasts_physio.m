%-----------------------------------------------------------------------
% Job saved on 22-Feb-2016 18:39:04 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (12.1)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{1}.string = 'reportContrastThreshold';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{2}.evaluated = 0.05;
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{3}.string = 'reportContrastCorrection';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{4}.evaluated = 'FWE';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{5}.string = 'fileReport';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{6}.evaluated = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data/TNU_WAGAD_0009/glm/preproc_realign_stc/ModelBased_ModelFree_2016_02_22_181635.ps';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{7}.string = 'fileSpm';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{8}.evaluated = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data/TNU_WAGAD_0009/glm/preproc_realign_stc/ModelBased_ModelFree/SPM.mat';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{9}.string = 'filePhysIO';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{10}.evaluated = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data/TNU_WAGAD_0009/preproc_realign_stc/physio/physio_run1.mat';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{11}.string = 'fileStructural';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{12}.evaluated = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data/TNU_WAGAD_0009/preproc_realign_stc/struct/wBrain.nii';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{13}.string = 'titleGraphicsWindow';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.inputs{14}.evaluated = 'WAGAD_0009';
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.outputs = {};
matlabbatch{1}.cfg_basicio.run_ops.call_matlab.fun = @tapas_physio_report_contrasts;
