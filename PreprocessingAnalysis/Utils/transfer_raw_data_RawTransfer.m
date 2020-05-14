% Transfers data to tnunash according to Wiki-convention
%
% /RawTransfer/andreea/<studyId>/fmri/raw/TNU_<studyId>_<subjID>/
% scandata => unprocessed par/rec/nii scandata
% behavior => cogent log files
% physlog  => SCANPHYSLOG*.log
%
% Author: Lars Kasper
% Created: 2014-10-10
%
% (c) TNU, IBT, University & ETH Zurich


%% START CHANGEABLE PARAMETERS 

idStudy = 'DMPAD';

% path within which single subject directories reside
paths.target.study = ['/RawTransfer/andreea/' idStudy '/fmri/raw'];
paths.source.study = '/terra/workspace/adiaconescu/studies/social_learning_pharma/data';


% directories to be transfered
% NOTE: if you add a new source/target-pair here, make sure to add it to
% the targets and sources-cells in the subject loop further down
dirs.target.behavior = 'behavior';
dirs.source.behavior = 'behav';

dirs.target.scandata = 'scandata';
dirs.source.scandata = 'data/raw';

dirs.target.physlog = 'physlog';
dirs.source.physlog = 'phys';

prefix.target.subject = ['TNU_' idStudy];
prefix.source.subject = idStudy;


%% END CHANGEABLE PARAMETERS


% find all subject folders
dirs.subjects = dir(fullfile(paths.source.study, [prefix.source.subject '*']));
dirs.subjects = {dirs.subjects.name}';

nSubjects = numel(dirs.subjects);

%% SUBJECT LOOP
% for all subjects...copy what has not been copied...
for iSubject = 1:nSubjects
    
    % remove studz id from subject to not duplicate prefixes
    idSubject = regexprep(dirs.subjects{iSubject}, prefix.source.subject, '');
    
    % create full subject paths on source and target
    paths.source.subject = fullfile(paths.source.study, ...
        [prefix.source.subject, idSubject]);
    paths.target.subject = fullfile(paths.target.study, ...
        [prefix.target.subject, idSubject]);
    
    % assemble all target and source sub-directories in a cell and prepend
    % the corresponding subject paths
    targets = {
        dirs.target.physlog
        dirs.target.behavior
        dirs.target.scandata
        };
    sources = {
        dirs.source.physlog
        dirs.source.behavior
        dirs.source.scandata
        };
    
    targets = strcat(paths.target.subject, '/', targets);
    
    sources = strcat(paths.source.subject, '/', sources, '/*');
    
    nSources = numel(sources);
    
    %% SOURCE/TARGET FOLDER PAIRS LOOP
    % Copy all files in all sources-paths to all targets for this subject,
    % using rsync -tuvaz (will not copy identical files again, will not
    % delete existing files on target)
    %
    % i.e.
    % copy physlog data
    % copy behavioral data
    % copy raw data
    
    for iSource = 1:nSources
        
        % copy target directory
        pathTarget = fileparts(targets{iSource});
        mkdir(pathTarget);
        
        stringCommand = sprintf('rsync -tuvaz %s %s', sources{iSource}, ...
            targets{iSource});
        
        fprintf('%s\n',stringCommand);
        unix(stringCommand);
    end
end