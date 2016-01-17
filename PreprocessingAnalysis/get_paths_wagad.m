function paths = get_paths_wagad(iSubj)
% Provides all paths for subject-specific data of WAGAD study
%
fs = filesep;

if nargin < 1
    iSubj = 3;
end

rp_model= {'softmax_multiple_readouts_reward_social'};

%% Paths study

if ismac % Lars laptop
    paths.study = '/Users/kasperla/Documents/code/matlab/smoothing_trunk/WAGAD';
    paths.data =  paths.study;
    paths.code.project =  paths.study;
    paths.code.spm = '/Users/kasperla/Documents/code/matlab/spm12';
    idSubj = sprintf('test_%04d',iSubj);
else % brutus cluster
    paths.study = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD';
    paths.data = fullfile(paths.study, 'data');
    paths.code.project = fullfile(paths.study, 'code', 'project');
    paths.code.spm = fullfile(paths.study, 'code', 'spm12');
    idSubj = sprintf('TNU_WAGAD_%04d',iSubj);
end

% for summary results over all subjects
paths.summary = fullfile(paths.study, 'summaryReports');
[~, ~] = mkdir(paths.summary);


paths.idSubj = idSubj;
paths.idSubjBehav = regexprep(idSubj, 'TNU_', '');


%% Paths code

paths.code.physio = fullfile(paths.code.project, 'PhysIO');
paths.code.model = fullfile(paths.code.project, 'WAGAD_model');
paths.code.preprocessing = fullfile(paths.code.project, 'PreprocessingAnalysis');

paths.code.batches = fullfile(paths.code.preprocessing, 'batches');
paths.code.batch.fnPreprocess = 'batch_preproc_fmri_realign_stc.m';
% paths.code.batch.fnPreprocess = 'batch_preproc_fmri_stc_realign.m';

paths.preproc.nameStrategy = paths.code.batch.fnPreprocess(1:end-2);

paths.code.batch.fnPhysIO = 'batch_physio_regressors.m';
paths.code.batch.fnStatsGlm = 'batch_stats_single_subject_glm.m';
paths.code.batch.fnStatsContrasts = 'batch_stats_single_subject_report_contrasts.m';

paths.cluster.scripts = fullfile(paths.study, 'cluster_scripts');
[~, ~] = mkdir(paths.cluster.scripts);


%% Paths data

paths.subj = fullfile(paths.data, idSubj);
paths.raw = fullfile(paths.subj, 'scandata');
paths.phys = fullfile(paths.subj, 'physlog');
paths.behav = fullfile(paths.subj, 'behav');
paths.funct = fullfile(paths.subj, 'funct');
paths.sess1 = fullfile(paths.funct, '1');
paths.sess2 = fullfile(paths.funct, '2');
paths.struct = fullfile(paths.subj, 'struct');

paths.dirSess = {
    paths.sess1
    paths.sess2
    paths.struct
    };


%% Paths logs

paths.dirLogs = regexprep(paths.dirSess, 'data/funct', 'phys');
paths.dirLogsOther = fullfile(paths.phys, 'logs');

paths.fnMultipleConditions = fullfile(paths.behav, [paths.idSubjBehav '_multiple_conditions.mat']);
paths.fnBehavMatrix = fullfile(paths.behav, [paths.idSubjBehav '_behav_matrix.mat']);

for iRsp = 1:numel(rp_model);
    paths.fnFittedModel{iRsp} = fullfile(paths.behav, sprintf('%s_behav_model_rsp_%s.mat', ...
        paths.idSubjBehav, rp_model{iRsp}));
end

paths.fnPhyslogRenamed = strcat(paths.dirSess(1:2), fs, 'phys.log');
 

%% Paths renamed raw data

paths.fnFunctRenamed = {
    'funct_run1.nii'
    'funct_run2.nii'
    'struct.nii'
    };

paths.realign.fnParameters = regexprep(strcat(paths.dirSess, fs ,'rp_', ...
    paths.fnFunctRenamed), 'nii$', 'txt');


paths.fnFunctRaw = {
    'run1'
    'run2'
    '*_1_*t1w3danat*'
    };

% try to determine raw nii-file anmes, if existing
try
    paths.fnFunctRaw = cellfun(@(x) regexprep(ls(fullfile(paths.raw, ...
        sprintf('*%s*.nii',x))),'\n',''), paths.fnFunctRaw, ...
        'UniformOutput', false);
catch % only data after main_prepare_preprocessing exists
    paths.fnFunctRaw = paths.fnFunctRenamed;
    paths.raw = paths.funct;
end

paths.nSess = length(paths.fnFunctRaw);




%% Derived file paths for SPM batches

paths.preproc.input.fnFunctArray = strcat( paths.dirSess(1:2), ...
    fs, paths.fnFunctRenamed(1:2));
paths.preproc.input.fnStruct = fullfile(paths.struct,  ...
    paths.fnFunctRenamed{3});

paths.preproc.output.root = fullfile(paths.subj, 'preproc_realign_stc');

%% PhysIO Output
paths.preproc.output.physio = fullfile(paths.preproc.output.root, 'physio');
[~,~] = mkdir(paths.preproc.output.physio);
paths.fnMultipleRegressors = fullfile(paths.preproc.output.physio, 'multiple_regressors_concat_run12.txt');
paths.preproc.output.fnPhysioArray = strcat(...
    paths.preproc.output.physio, fs, ...
    {'physio_run1.mat'; ...
    'physio_run2.mat'});

%% Output paths Preprocessing

% replace funct by new folders of preproc output
paths.preproc.output.funct = regexprep(paths.funct, paths.subj, ...
    paths.preproc.output.root);
paths.preproc.output.struct = regexprep(paths.struct, paths.subj, ...
    paths.preproc.output.root);

% all in same folder
paths.preproc.output.sess1 = paths.preproc.output.funct ;
paths.preproc.output.sess2 = paths.preproc.output.funct ;
paths.preproc.output.dirSess = {
    paths.preproc.output.sess1
    paths.preproc.output.sess2
    paths.preproc.output.struct
    };

paths.preproc.output.fnFunctArray = strcat('swau', ...
    paths.fnFunctRenamed);
paths.preproc.output.fnFunctArray{3} = 'wBrain.nii';

% where subject-specific batches are saved
paths.preproc.output.batch = fullfile(paths.subj, 'batches');

[tmp, tmp2] = mkdir(paths.preproc.output.batch);


% realignment parameter filenames
paths.preproc.output.fnRealignConcat = ...
        regexprep(sprintf('rp_%s', paths.fnFunctRenamed{1}), '\.nii', '\.txt');

paths.preproc.output.fnRealignSession = {
    ['rp_', paths.fnFunctRenamed{1}(1:end-4), '_split.txt']
    ['rp_', paths.fnFunctRenamed{2}(1:end-4), '_split.txt']
};    



%% Preproc output: prepend paths for file names

paths.preproc.output.fnRealignConcat = fullfile(paths.preproc.output.sess1, ...
    paths.preproc.output.fnRealignConcat);

paths.preproc.output.fnRealignSession = strcat(paths.preproc.output.dirSess(1:2), ...
   fs, paths.preproc.output.fnRealignSession);

paths.preproc.output.fnFunctArray = ...
    strcat( paths.preproc.output.dirSess, ...
    fs, paths.preproc.output.fnFunctArray);

paths.preproc.output.fnStruct = paths.preproc.output.fnFunctArray{3};

paths.preproc.output.report = fullfile(paths.preproc.output.root, ...
    'report_preproc_quality');



%% Paths GLM
paths.stats.glm.root = fullfile(paths.subj, 'glm');
[~,~] = mkdir(paths.stats.glm.root);
paths.stats.glm.designs = strcat(paths.stats.glm.root, ...
 fs, paths.preproc.nameStrategy, fs, ...
    {
    'first_design'
    });

for iDesign = 1:numel(paths.stats.glm.designs);
    [~,~] = mkdir(paths.stats.glm.designs{iDesign});
end

paths.stats.fnSpmArray = strcat(paths.stats.glm.designs, fs, 'SPM.mat');
paths.stats.contrasts.fnReportArray = strcat(paths.stats.glm.designs, '.ps');

%%  Scan Info

% save scan info in sub-structure
fnFunctionalArray = ...
    strcat(paths.dirSess, filesep, paths.fnFunctRenamed);
inputTR = 2.65781;

if exist(fnFunctionalArray{1}, 'file')
    paths.scanInfo = get_scan_info(fnFunctionalArray, inputTR);
end
