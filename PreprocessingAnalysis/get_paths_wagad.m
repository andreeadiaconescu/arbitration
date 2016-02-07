function paths = get_paths_wagad(iSubj, idPreprocStrategy, idGlmDesign)
% Provides all paths for subject-specific data of WAGAD study
%
fs = filesep;

if nargin < 1
    iSubj = 3;
end

if nargin < 2
    idPreprocStrategy = 1;
end

if nargin < 3
    idGlmDesign = 1;
end


namePreprocStrategies = {'preproc_realign_stc', 'preproc_stc_realign'};
nameGlmDesigns = {'first_design'};
nameResponseModels= {'softmax_multiple_readouts_reward_social','hgf_ioio_precision_weight_new_config'};

%% Paths study

preproc.nameStrategies = namePreprocStrategies;
preproc.nameStrategy = namePreprocStrategies{idPreprocStrategy};
glm.nameDesigns = nameGlmDesigns;
glm.nameDesign = nameGlmDesigns{idGlmDesign}; 

if ismac
    [~,username] = unix('whoami');
    username(end) = []; % remove trailing end of line character
    
    switch username
        case 'kasperla'; % Lars laptop
            
            paths.study = '/Users/kasperla/Documents/code/matlab/smoothing_trunk/WAGAD';
            paths.data =  paths.study;
            paths.code.project =  paths.study;
            paths.code.spm = '/Users/kasperla/Documents/code/matlab/spm12';
            
        case 'drea' % Andreeas laptop
            paths.study = '/Users/drea/Dropbox/MadelineMSc/';
            paths.data =  '/Users/drea/Dropbox/MadelineMSc/DatafMRI/fMRI_data/'; % behav data
            code.project = '/Users/drea/Dropbox/MadelineMSc/Code/WAGAD';
            code.spm = '/Users/drea/Documents/MATLAB/spm12';
            
        otherwise % @Madeline: change to your own paths HERE

            paths.study = '/Users/mstecy/Dropbox/MadelineMSc/';
            paths.data =  '/Users/mstecy/Dropbox/MadelineMSc/DatafMRI/fMRI_data/';
            code.project = '/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD';
            code.spm = '/Users/mstecy/Desktop/IOIO_Wager_Computational_Model/PreprocessingSingleSubjectAnalysis/spm12'; 
    end
    
else % brutus cluster
    paths.study = '/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD';
    paths.data = fullfile(paths.study, 'data');
    code.project = fullfile(paths.study, 'code', 'project');
    code.spm = fullfile(paths.study, 'code', 'spm12');
end

paths.patternIdSubj = 'TNU_WAGAD_%04d';
paths.patternIdSubjBehav = 'WAGAD_%04d';  
paths.idSubj = sprintf(paths.patternIdSubj, iSubj);
paths.idSubjBehav = sprintf(paths.patternIdSubjBehav, iSubj);


% for summary results over all subjects
paths.summary = fullfile(paths.study, 'summaryReports');
[~, ~] = mkdir(paths.summary);


%% Paths code

code.physio = fullfile(code.project, 'PhysIO');
code.model = fullfile(code.project, 'WAGAD_model');
code.preprocessing = fullfile(code.project, 'PreprocessingAnalysis');

code.batches = fullfile(code.preprocessing, 'batches');

switch preproc.nameStrategy
    case 'preproc_realign_stc'
        code.batch.fnPreprocess = ['batch_preproc_fmri_realign_stc.m'];
    case 'preproc_stc_realign'
        code.batch.fnPreprocess = ['batch_preproc_fmri_stc_realign.m'];
end

code.batch.fnPhysIO = 'batch_physio_regressors.m';
code.batch.fnStatsGlm = 'batch_stats_single_subject_glm.m';
code.batch.fnStatsContrasts = 'batch_stats_single_subject_report_contrasts.m';

paths.cluster.scripts = fullfile(paths.study, 'cluster_scripts');
[~, ~] = mkdir(paths.cluster.scripts);


%% Paths data

paths.subj = fullfile(paths.data, paths.idSubj);
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

for iRsp = 1:numel(nameResponseModels);
    paths.fnFittedModel{iRsp} = fullfile(paths.behav, sprintf('%s_behav_model_rsp_%s.mat', ...
        paths.idSubjBehav, nameResponseModels{iRsp}));
end

paths.fnPhyslogRenamed = strcat(paths.dirSess(1:2), fs, 'phys.log');
 

%% Paths renamed raw data

paths.fnFunctRenamed = {
    'funct_run1.nii'
    'funct_run2.nii'
    'struct.nii'
    };

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

preproc.input.fnFunctArray = strcat( paths.dirSess(1:2), ...
    fs, paths.fnFunctRenamed(1:2));
preproc.input.fnStruct = fullfile(paths.struct,  ...
    paths.fnFunctRenamed{3});

preproc.output.root = fullfile(paths.subj, preproc.nameStrategy);

%% PhysIO Output
preproc.output.physio = fullfile(preproc.output.root, 'physio');
[~,~] = mkdir(preproc.output.physio);
paths.fnMultipleRegressors = fullfile(preproc.output.physio, 'multiple_regressors_concat_run12.txt');
preproc.output.fnPhysioArray = strcat(...
    preproc.output.physio, fs, ...
    {'physio_run1.mat'; ...
    'physio_run2.mat'});

%% Output paths Preprocessing

% replace funct by new folders of preproc output
preproc.output.funct = regexprep(paths.funct, paths.subj, ...
    preproc.output.root);
preproc.output.struct = regexprep(paths.struct, paths.subj, ...
    preproc.output.root);

% all in same folder
preproc.output.sess1 = preproc.output.funct ;
preproc.output.sess2 = preproc.output.funct ;
preproc.output.dirSess = {
    preproc.output.sess1
    preproc.output.sess2
    preproc.output.struct
    };



switch preproc.nameStrategy
    case 'preproc_realign_stc' 
        preproc.output.pfxFunct = 'swau';
        preproc.output.pfxRealignParams = 'rp_';
    case 'preproc_stc_realign';
        preproc.output.pfxFunct = 'swua';
        preproc.output.pfxRealignParams = 'rp_a';
end

preproc.output.fnFunctArray = strcat(preproc.output.pfxFunct, ...
    paths.fnFunctRenamed);

preproc.output.fnFunctArray{3} = 'wBrain.nii';

% where subject-specific batches are saved
preproc.output.batch = fullfile(paths.subj, 'batches');

[tmp, tmp2] = mkdir(preproc.output.batch);


% realignment parameter filenames
preproc.output.fnRealignConcat = [...
        preproc.output.pfxRealignParams paths.fnFunctRenamed{1}(1:end-4), ...
        '.txt'];

preproc.output.fnRealignSession = {
    [preproc.output.pfxRealignParams , paths.fnFunctRenamed{1}(1:end-4), '_split.txt']
    [preproc.output.pfxRealignParams , paths.fnFunctRenamed{2}(1:end-4), '_split.txt']
};    



%% Preproc output: prepend paths for file names

preproc.output.fnRealignConcat = fullfile(preproc.output.sess1, ...
    preproc.output.fnRealignConcat);

preproc.output.fnRealignSession = strcat(preproc.output.dirSess(1:2), ...
   fs, preproc.output.fnRealignSession);

preproc.output.fnFunctArray = ...
    strcat( preproc.output.dirSess, ...
    fs, preproc.output.fnFunctArray);

preproc.output.fnStruct = preproc.output.fnFunctArray{3};

preproc.output.report = fullfile(preproc.output.root, ...
    'report_preproc_quality');



%% Paths GLM
glm.root = fullfile(paths.subj, 'glm');

[~,~] = mkdir(glm.root);
glm.design = fullfile(glm.root, preproc.nameStrategy, glm.nameDesign);

mkdir(glm.design);

paths.stats.fnSpm = strcat(glm.design, fs, 'SPM.mat');

contrasts.fnReport = strcat(glm.design, '.ps');
contrasts.names = {'arbitration'; 'belief_precision'};
contrasts.indices = [2 4];

%%  Scan Info

% save scan info in sub-structure
fnFunctionalArray = ...
    strcat(paths.dirSess, filesep, paths.fnFunctRenamed);
inputTR = 2.65781;

if exist(fnFunctionalArray{1}, 'file')
    paths.scanInfo = get_scan_info(fnFunctionalArray, inputTR);
end


%% Second level folders

secondLevel.root = fullfile(paths.data, 'SecondLevel');
secondLevel.covariates = fullfile(secondLevel.root,'covariates');
secondLevel.fnCovariates = fullfile(secondLevel.covariates, 'parameters.mat');
secondLevel.fnNuisanceRegressors = fullfile(secondLevel.covariates, 'nuisance_regressors.txt');
secondLevel.design = strcat(secondLevel.root, fs, preproc.nameStrategy, fs,...
    glm.nameDesign);


secondLevel.contrasts = strcat(secondLevel.design, fs, contrasts.names);

% for iContrast = 1:numel(secondLevel.contrasts);
%     [~,~] = mkdir(secondLevel.contrasts{iContrast});
% end


%% Assemble sub-modules of paths-structure

paths.stats.contrasts = contrasts;
paths.code = code;
paths.preproc = preproc;
paths.stats.glm = glm;
paths.stats.secondLevel = secondLevel;