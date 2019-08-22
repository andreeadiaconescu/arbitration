function [models_wagad] = loadWAGADModelEvidence(iSubjectArray,paths)

% pairs of perceptual and response model
[iCombPercResp] = wagad_get_model_space;

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