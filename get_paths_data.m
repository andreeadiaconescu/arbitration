function paths = get_paths_data(iSubj)

fs = filesep;

if nargin < 1
    iSubj = 1;
end

idSubj = sprintf('WAGAD_%04d',iSubj);

paths.idSubj = idSubj;
% paths.summary = '/terra/workspace/adiaconescu/studies/social_learning_pharma/code/snr/stability_subjects_phantom';
paths.root = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/data';
paths.subj = fullfile(paths.root, idSubj);
paths.data = fullfile(paths.subj, 'data');
paths.raw = fullfile(paths.data, 'scandata');
paths.phys = fullfile(paths.subj, 'phys');
paths.funct = fullfile(paths.data, 'funct');
paths.sess1 = fullfile(paths.funct, '1');
paths.sess2 = fullfile(paths.funct, '2');
paths.rest = fullfile(paths.funct, 'rest');
paths.phantom = fullfile(paths.funct, 'phantom');
paths.struct = fullfile(paths.data, 'struct');

paths.dirSess = {
    paths.sess1
    paths.sess2
    paths.struct
    };

paths.dirLogs = regexprep(paths.dirSess, 'data/funct', 'phys');
paths.dirLogsOther = fullfile(paths.phys, 'logs');

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
