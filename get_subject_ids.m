function [idSubjectArray, dirSubjectArray] = ...
    get_subject_ids(pathData, prefixSubject)
if nargin < 1
    paths = get_paths_wagad(3);
    pathData = paths.data;
end

if nargin < 2
    prefixSubject = 'TNU_WAGAD_';
end

dirSubjectArray = dir(fullfile(pathData, [prefixSubject '*']));
dirSubjectArray = {dirSubjectArray.name}';

% find folders which exactly match specification by ending with 4 digits
iSubjectArray = regexp(dirSubjectArray, [prefixSubject '\d{4}$']);
iSubjectArray = find(~cell2mat(cellfun(@isempty, iSubjectArray, ...
    'UniformOutput', false)));

% get strings of digits
idSubjectArray = cellfun(@(x) num2str(x(end-3:end)), ...
    dirSubjectArray(iSubjectArray), 'UniformOutput', false);

% convert to number
idSubjectArray = cell2mat(cellfun(@str2num, idSubjectArray, ...
    'UniformOutput', false));