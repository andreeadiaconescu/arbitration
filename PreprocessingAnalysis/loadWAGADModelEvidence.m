function [models_wagad] = loadWAGADModelEvidence(iSubjectArray,paths)

original_models = true;

if original_models == true
    % pairs of perceptual and response model
    iCombPercResp = zeros(8,1); 
else 
    % pairs of perceptual and response model
    iCombPercResp = zeros(3,1);
end

nModels = size(iCombPercResp,1);

nSubjects = numel(iSubjectArray);
models_wagad = cell(nSubjects, nModels);

for iSubject = iSubjectArray
    
    
    % loop over perceptual and response models
    for iModel = 1:nModels
        
        tmp = load(fullfile(paths.fnFittedModel{iModel}));
        models_wagad{iSubject,iModel} = tmp.est.F;
    end
end
models_wagad = cell2mat(models_wagad);
end