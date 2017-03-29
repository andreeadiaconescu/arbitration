%-----------------------------------------------------------------------
% Job saved on 29-Jul-2016 15:36:13 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.con.spmmat = {'/Users/kasperla/Documents/code/matlab/smoothing_trunk/WAGAD/test_0003/glm/first_design/SPM.mat'};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main_Stability';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0 1 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Main_Volatile';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Interaction_Reward';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [1 -1 -1 1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Interaction_Advice';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [-1 1 1 -1];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'StabilityvsVolatility';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [1 -1 1 -1];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'VolatilityvsStability';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [-1 1 -1 1];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'EffectReward';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [1 1 -1 -1];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'EffectAdvice';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [-1 -1 1 1];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'EffectRewardStability';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [1 0 -1 0];
matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'EffectAdviceStability';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = [-1 0 1 0];
matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'EffectRewardVolatility';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = [0 1 0 -1];
matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'EffectAdviceVolatility';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = [0 -1 0 1];
matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

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
