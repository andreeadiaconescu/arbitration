%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
function main_2ndlevel_job(regressor, learningParameter)
if nargin < 1
    regressor = 'arbitration';
end

if nargin < 2
    learningParameter = 'zeta';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters to set (subjects, preproc-flavor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iExcludedSubjects = [14 25 32 33 34 37];

paths = get_paths_wagad(); % dummy subject to get general paths

% manual setting...if you want to exclude any subjects
iSubjectArray = get_subject_ids(paths.data)';
iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);

datapath = paths.stats.secondLevel.root;
dir1stLevel = 'first_design';
switch regressor
    case 'basic_advice'
        iContrast = 1;
    case 'arbitration'
        iContrast = 2;
    case 'basic_wager'
        iContrast = 3;
    case 'belief_precision'
        iContrast = 4;
    case 'basic_outcome'
        iContrast = 5;
    case 'delta1_advice'
        iContrast = 6;
    case 'delta1_cue'
        iContrast = 7;
end

% Initialize
spm_jobman('initcfg');
which spm

path2ndLevel = fullfile(datapath,'learning_parameters', learningParameter, regressor);

if exist(path2ndLevel, 'dir')
    delete(path2ndLevel)
end;
mkdir(path2ndLevel);


switch learningParameter
    case 'kappa_r'
        iColumn = 1;
    case 'kappa_a'
        iColumn = 2;
    case 'theta_r'
        iColumn = 3;
    case 'theta_a'
        iColumn = 4;
    case 'zeta'
        iColumn = 5;
    case 'beta'
        iColumn = 6;
end

job = load('/cluster/scratch_xl/shareholder/klaas/dandreea/IOIO/matlab_batch/secondlevel_cov_template.mat');
job = job.matlabbatch;
job{1}.spm.stats.factorial_design.dir = {path2ndLevel};

%%

load(fullfile([paths.stats.secondLevel.covariates,'/parameters.mat']));
%%
allparameters=temp;


pathGlmAllSubjects = get_path_all_subjects('stats.glm.design', iSubjectArray);
fnContrastAllSubjects= strcat(pathGlmAllSubjects, filesep, ...
    sprintf('con_%04d.nii', iContrast));

newSub=sub(~cellfun(@isempty,sub));
job{1}.spm.stats.factorial_design.des.t1.scans = fnContrastAllSubjects;
%% Change to the desired glm and contrast
job{1}.spm.stats.factorial_design.des.t1.scans = ...
    regexprep(regexprep(job{1}.spm.stats.factorial_design.des.t1.scans, ...
    'glm_adv_cue_belief', dir1stLevel), ...
    'con_0005', sprintf('con_%04d', iContrast));

%%
%%
drug_grp=load(fullfile([modelpath, 'COMT.txt']));
%%
job{1}.spm.stats.factorial_design.cov(1).c = allparameters(:,iColumn);
job{1}.spm.stats.factorial_design.cov(1).cname = learningParameter;
job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
job{1}.spm.stats.factorial_design.cov(2).c =drug_grp;
job{1}.spm.stats.factorial_design.cov(2).cname = 'drug_group';
job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;
job{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
job{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
job{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
job{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
job{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
job{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
job{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
job{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
job{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
job{2}.spm.stats.fmri_est.method.Classical = 1;
job{3}.spm.stats.con.spmmat(1) = cfg_dep;
job{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
job{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
job{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
job{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
job{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
job{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
job{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
job{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
job{3}.spm.stats.con.consess{1}.tcon.name = 'POS_learning_parameter';
job{3}.spm.stats.con.consess{1}.tcon.convec = [0 1 0];
job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{2}.tcon.name = 'POS_effect_COMT';
job{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 1];
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{3}.tcon.name = 'POS_effect_parameterxCOMT';
job{3}.spm.stats.con.consess{3}.tcon.convec = [0 1 1];
job{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{4}.tcon.name = 'POS_regress_out_par_COMT';
job{3}.spm.stats.con.consess{4}.tcon.convec = [1 0 0];
job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{5}.tcon.name = 'NEG_learning_parameter';
job{3}.spm.stats.con.consess{5}.tcon.convec = [0 -1 0];
job{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{6}.tcon.name = 'NEG_effect_COMT';
job{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 -1];
job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{7}.tcon.name = 'NEG_effect_parameterxCOMT';
job{3}.spm.stats.con.consess{7}.tcon.convec = [0 -1 -1];
job{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{8}.tcon.name = 'NEG_regress_out_par_COMT';
job{3}.spm.stats.con.consess{8}.tcon.convec = [-1 0 0];
job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
job{3}.spm.stats.con.delete = 0;
% Which modules really to include?
actual_job = {job{1},job{2},job{3}};

% Execute actual_job
spm_jobman('interactive',actual_job);
% spm_jobman('run',actual_job);
end
