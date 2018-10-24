%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
function main_2ndlevel_job(idDesign,iSubjectArray,regressor,learningParameter)
if nargin < 1
    idDesign = 2;
end

if nargin < 2
    iExcludedSubjects = [6 14 25 31 32 33 34 37 44];
    % manual setting...if you want to exclude any subjects
    iSubjectArray = get_subject_ids(paths.data)';
    iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);
end

if nargin < 3
    regressor = 'advice_epsilon3';
end
if nargin < 4
    learningParameter = 'zeta';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters to set (subjects, preproc-flavor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
paths = get_paths_wagad(); % dummy subject to get general paths
dir1stLevel = paths.nameGlmDesigns{idDesign};

% initialise spm
spm_get_defaults('modality', 'FMRI');
if ~exist('cfg_files', 'file')
    spm_jobman('initcfg')
end

datapath      = paths.stats.secondLevel.root;

[iContrast] = get_WAGAD_contrast(dir1stLevel,regressor);


% Initialize
spm_jobman('initcfg');
which spm

paths = get_paths_wagad(iSubjectArray); % dummy subject to get general paths
path2ndLevel = fullfile(paths.stats.secondLevel.design,'learning_parameters', learningParameter, regressor);

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

job = load(fullfile([paths.stats.secondLevel.root, '/secondlevel_cov_template.mat']));
job = job.matlabbatch;
job{1}.spm.stats.factorial_design.dir = {path2ndLevel};

%%
load(fullfile([paths.stats.secondLevel.covariates,'/covariates_model1.mat']));
%%
allparameters=temp;
pathGlmAllSubjects = get_path_all_subjects('stats.glm.design', iSubjectArray);
fnContrastAllSubjects= strcat(pathGlmAllSubjects, filesep, ...
    sprintf('con_%04d.nii', iContrast));
job{1}.spm.stats.factorial_design.des.t1.scans = fnContrastAllSubjects;
%%
nuisance_regressors=get_nuisance_regressors_2ndlevel(paths, iSubjectArray);
job{1}.spm.stats.factorial_design.cov(1).c = allparameters(:,iColumn);
job{1}.spm.stats.factorial_design.cov(1).cname = learningParameter;
job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
job{1}.spm.stats.factorial_design.cov(2).c =nuisance_regressors(:,1);
job{1}.spm.stats.factorial_design.cov(2).cname = 'gender';
job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
job{1}.spm.stats.factorial_design.cov(3).c =nuisance_regressors(:,2);
job{1}.spm.stats.factorial_design.cov(3).cname = 'age';
job{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
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
job{3}.spm.stats.con.consess{2}.tcon.name = 'POS_effect_gender';
job{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 1];
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{3}.tcon.name = 'POS_regress_out_all';
job{3}.spm.stats.con.consess{3}.tcon.convec = [1 0 0];
job{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{4}.tcon.name = 'NEG_learning_parameter';
job{3}.spm.stats.con.consess{4}.tcon.convec = [0 -1 0];
job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{5}.tcon.name = 'NEG_effect_gender';
job{3}.spm.stats.con.consess{5}.tcon.convec = [0 0 -1];
job{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{6}.tcon.name = 'NEG_regress_out_all';
job{3}.spm.stats.con.consess{6}.tcon.convec = [-1 0 0];
job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
job{3}.spm.stats.con.delete = 0;
job{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
job{4}.spm.stats.results.conspec.titlestr = '';
job{4}.spm.stats.results.conspec.contrasts = [Inf];
job{4}.spm.stats.results.conspec.threshdesc = 'none';
job{4}.spm.stats.results.conspec.thresh = 0.001;
job{4}.spm.stats.results.conspec.extent = 100;
job{4}.spm.stats.results.conspec.conjunction = 1;
job{4}.spm.stats.results.conspec.mask.none = 1;
job{4}.spm.stats.results.units = 1;
job{4}.spm.stats.results.print = 'ps';
job{4}.spm.stats.results.write.none = 1;

% Which modules really to include?
actual_job = {job{1},job{2},job{3},job{4}};

% Execute actual_job
spm_jobman('run',actual_job);
end
