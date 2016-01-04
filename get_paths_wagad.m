function paths = get_paths_wagad(iSubj)
% Provides all paths for subject-specific data of WAGAD study
%
fs = filesep;

if nargin < 1
    iSubj = 3;
end

rp_model= {'softmax_multiple_readouts_reward_social'};


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

paths.idSubj = idSubj;

paths.idSubjBehav = regexprep(idSubj, 'TNU_', '');
paths.code.physio = fullfile(paths.code.project, 'PhysIO');
paths.code.model = fullfile(paths.code.project, 'WAGAD_model');

paths.code.batches = fullfile(paths.code.project, 'batches');
paths.code.batch.fnPreprocess = 'batch_preproc_fmri_realign_stc.m';


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

paths.dirLogs = regexprep(paths.dirSess, 'data/funct', 'phys');
paths.dirLogsOther = fullfile(paths.phys, 'logs');

paths.fnMultipleConditions = fullfile(paths.behav, [paths.idSubjBehav '_multiple_conditions.mat']);
paths.fnBehavMatrix = fullfile(paths.behav, [paths.idSubjBehav '_behav_matrix.mat']);

for iRsp = 1:numel(rp_model);
    paths.fnFittedModel{iRsp} = fullfile(paths.behav, sprintf('%s_behav_model_rsp_%s.mat', ...
        paths.idSubjBehav, rp_model{iRsp}));
end

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

try
    paths.fnFunctRaw = cellfun(@(x) regexprep(ls(fullfile(paths.raw, ...
        sprintf('*%s*.nii',x))),'\n',''), paths.fnFunctRaw, ...
        'UniformOutput', false);
catch % only data after main_prepare_preprocessing exists
    paths.fnFunctRaw = paths.fnFunctRenamed;
    paths.raw = paths.funct;
end

paths.nSess = length(paths.fnFunctRaw);



%% derived paths for SPM batches
paths.preproc.input.fnFunctArray = strcat( paths.dirSess(1:2), ...
    fs, paths.fnFunctRenamed(1:2));
paths.preproc.input.fnStruct = fullfile(paths.struct,  ...
    paths.fnFunctRenamed{3});

paths.preproc.output.root = fullfile(paths.subj, 'preproc_realign_stc');

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

% prepend paths
paths.preproc.output.fnFunctArray = ...
    strcat( paths.preproc.output.dirSess, ...
    fs, paths.preproc.output.fnFunctArray);

paths.preproc.output.fnStruct = paths.preproc.output.fnFunctArray{3};

paths.preproc.output.report = fullfile(paths.preproc.output.root, ...
    'report_preproc_quality');

% for saving overall (multi-subj) study results
paths.summary = fullfile(paths.study, 'summaryReports');
[tmp, tmp2] = mkdir(paths.summary);
