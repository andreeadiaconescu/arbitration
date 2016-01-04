function paths = get_paths_wagad(iSubj)
% Provides all paths for subject-specific data of WAGAD study
%
fs = filesep;

if nargin < 1
    iSubj = 3;
end

rp_model= {'softmax_multiple_readouts_reward_social'};

idSubj = sprintf('TNU_WAGAD_%04d',iSubj);

paths.idSubj = idSubj;
% paths.summary = '/terra/workspace/adiaconescu/studies/social_learning_pharma/code/snr/stability_subjects_phantom';

paths.idSubjBehav = idSubj(5:end);
paths.code.project = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/project';
paths.code.physio = fullfile(paths.code.project, 'PhysIO');
paths.code.model = fullfile(paths.code.project, 'WAGAD_model');
paths.root = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data';
paths.subj = fullfile(paths.root, idSubj);
paths.data = paths.subj; 
paths.raw = fullfile(paths.data, 'scandata');
paths.phys = fullfile(paths.data, 'physlog');
paths.behav = fullfile(paths.data, 'behav');
paths.funct = fullfile(paths.data, 'funct');
paths.sess1 = fullfile(paths.funct, '1');
paths.sess2 = fullfile(paths.funct, '2');
paths.struct = fullfile(paths.data, 'struct');

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

paths.fnFunctRaw = cellfun(@(x) regexprep(ls(fullfile(paths.raw, ...
    sprintf('*%s*.nii',x))),'\n',''), paths.fnFunctRaw, ...
    'UniformOutput', false);

paths.nSess = length(paths.fnFunctRaw);
% mkdir(paths.backup);
