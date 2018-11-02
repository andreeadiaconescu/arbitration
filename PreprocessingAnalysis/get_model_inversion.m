function get_model_inversion(iSubjectArray, idDesign)
% computes HGF for given subjects and creates parametric modulators for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [9 14 25 31 32 33 34 37]);
    
    % 6,7 = noisy; 9
end

if nargin < 2
    idDesign = 2;
end

errorSubjects = {};
errorIds = {};
errorFile = 'errorInversion.mat';
for iSubj = iSubjectArray
    %% Load Model and inputs
    iD = iSubj;
    fprintf('\n=======\n\n\tInverting subject %d\n\n', iD)
    % try % continuation with new subjects, if error
    paths = get_paths_wagad(iSubj,1,idDesign);
    addpath(paths.code.model);
    
    input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure: is this the input structure?
    
    y = [];
    
    %% Load Onsets
    % construct output matrix from behavioral log files:
    % outputmatrix=[onsets1 onsets2 onsets3 choice onsets_resp RS' inmatrix(:,17)];
    
    outputmatrix = [];
    for iRun = 1:2
        
        % try whether run 1 and 2 (male adviser) exist
        fileBehav = fullfile(paths.behav, ...
            sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun));
        if ~exist(fileBehav)
            % we use run 5+6 (female adviser)
            fileBehav = fullfile(paths.behav, ...
                sprintf('%sperblock_IOIO_run%d.mat', paths.idSubjBehav, iRun+4));
        end
        load(fileBehav);
        
        trigger = SOC.param(2).scanstart;
        
        fileTrigger = fullfile(paths.behav, sprintf('scanner_trigger_%d.txt', iRun));
        save(fileTrigger,'trigger','-ascii','-tabs');
        
        % later runs are offset by duration of previous runs for
        % concatentation
        offsetRunSeconds = 0 + ...
            sum(paths.scanInfo.TR(1:iRun-1).*paths.scanInfo.nVols(1:iRun-1));
        
        outputmatrixSession{iRun} = apply_trigger(fileTrigger, ...
            SOC.Session(2).exp_data, offsetRunSeconds);
        choice  = outputmatrixSession{iRun}(:,4);
        wager   = outputmatrixSession{iRun}(:,7);
        y       = [y; choice wager];
        outputmatrix = [outputmatrix; outputmatrixSession{iRun}];
    end
    save(paths.fnBehavMatrix,'outputmatrix','-mat');
    
    %% Run Inversion
    for iRsp= 1:numel(paths.fileResponseModels)
        fprintf('\n=======\n\n\t\tInverting subject %d, model %d\n\n', iD, iRsp)
        
        est=fitModel(y,input_u,'hgf_binary3l_reward_social_config',...
            paths.fileResponseModels{iRsp});
        
        [predicted_wager]   = calculate_predicted_wager(est,paths);
        est.predicted_wager = predicted_wager;
        est.cscore          = SOC.cscore;
        
        save(paths.fnFittedModel{iRsp}, 'est');
        
    end
    
    %     catch err
    %         errorSubjects{end+1,1}.id = iD;
    %         errorSubjects{end}.error = err;
    %         errorIds{end+1} = iD;
    %     end
end

save(fullfile(paths.behav, errorFile), 'errorSubjects', 'errorIds');