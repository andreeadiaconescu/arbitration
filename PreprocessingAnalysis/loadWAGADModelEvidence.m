function [models_wagad] = loadWAGADModelEvidence(iSubjectArray,paths)

% pairs of perceptual and response model
iCombPercResp = zeros(6,2);
iCombPercResp(1:3,1) = 1;
iCombPercResp(4:6,1) = 2;

iCombPercResp(1:3,2) = 1:3;
iCombPercResp(4:6,2) = 1:3;

nModels = size(iCombPercResp,1);

nSubjects = numel(iSubjectArray);
models_wagad = cell(nSubjects, nModels);

for iSubject = iSubjectArray 
    paths = get_paths_wagad(iSubject);
    % loop over perceptual and response models
    for iModel = 1:nModels
        tmp = load(fullfile(paths.fnFittedModel{iModel}));
        models_wagad{iSubject,iModel} = tmp.est.F;
    end
end
models_wagad = cell2mat(models_wagad);

save([paths.stats.secondLevel.covariates, '/BMS.mat'],'models_wagad', '-mat');
end