%-----------------------------------------------------------------------
% Job saved on 09-Jan-2016 23:04:07 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.con.spmmat = {'/Users/kasperla/Documents/code/matlab/smoothing_trunk/WAGAD/test_0003/glm/first_design/SPM.mat'};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Advice Onset';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Arbitration';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Arbitration_StableAUnstableR';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Arbitration_StableAStableR';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Arbitration_UnstableAStableR';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Basic Wager';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Belief Precision';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [zeros(6,1)' 1];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Wager_StableAUnstableR';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [zeros(7,1)' 1];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'Wager_StableAStableR';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [zeros(8,1)' 1];
matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'Wager_UnstableAStableR';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = [zeros(9,1)' 1];
matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'Basic Outcome';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = [zeros(10,1)' 1];
matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'Delta1 Advice';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = [zeros(11,1)' 1];
matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'Delta1 Reward';
matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = [zeros(12,1)' 1];
matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'Arbitration_UnstableAUnstableR';
matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = [1 0 -1/3 -1/3 -1/3];
matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'Wager_UnstableAUnstableR';
matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 0 0 1 0 -1/3 -1/3 -1/3];
matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';

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
