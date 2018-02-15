%-----------------------------------------------------------------------
% Job saved on 26-Jan-2018 12:42:38 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.con.spmmat = {'/Volumes/AndreeasBackUp/WAGAD/data/TNU_WAGAD_0003/glm/preproc_realign_stc/factorial_design_multiple_contrasts/SPM.mat'};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main_Stability';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0 1 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Main_Volatile';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Interaction_Advice';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [-1 1 1 -1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'StabilityvsVolatility';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [1 -1 1 -1];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 1;
matlabbatch{2}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{2}.spm.stats.results.conspec(1).contrasts = Inf;
matlabbatch{2}.spm.stats.results.conspec(1).threshdesc = 'FWE';
matlabbatch{2}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{2}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{2}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{2}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{2}.spm.stats.results.conspec(2).contrasts = Inf;
matlabbatch{2}.spm.stats.results.conspec(2).threshdesc = 'none';
matlabbatch{2}.spm.stats.results.conspec(2).thresh = 0.001;
matlabbatch{2}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{2}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{2}.spm.stats.results.units = 1;
matlabbatch{2}.spm.stats.results.print = 'ps';
matlabbatch{2}.spm.stats.results.write.none = 1;
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{1}.string = 'reportContrastThreshold';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{2}.evaluated = 0.05;
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{3}.string = 'reportContrastCorrection';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{4}.evaluated = 'FWE';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{5}.string = 'fileReport';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{6}.evaluated = '/Volumes/AndreeasBackUp/WAGAD/data/TNU_WAGAD_0003/glm/preproc_realign_stc/factorial_design_multiple_contrasts_2018_01_26_122938_physio.ps';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{7}.string = 'fileSpm';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{8}.evaluated = '/Volumes/AndreeasBackUp/WAGAD/data/TNU_WAGAD_0003/glm/preproc_realign_stc/factorial_design_multiple_contrasts/SPM.mat';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{9}.string = 'filePhysIO';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{10}.evaluated = '/Volumes/AndreeasBackUp/WAGAD/data/TNU_WAGAD_0003/preproc_realign_stc/physio/physio_run1.mat';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{11}.string = 'fileStructural';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{12}.evaluated = '/Volumes/AndreeasBackUp/WAGAD/data/TNU_WAGAD_0003/preproc_realign_stc/struct/wBrain.nii';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{13}.string = 'titleGraphicsWindow';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.inputs{14}.evaluated = 'WAGAD_0003';
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.outputs = cell(1, 0);
matlabbatch{3}.cfg_basicio.run_ops.call_matlab.fun = @tapas_physio_report_contrasts;
