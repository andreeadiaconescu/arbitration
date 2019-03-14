function get_behaviour_data(iSubjectArray)
% extracts behaviour variables, computes HGF for given subjects for
% concatenated design matrix, plus base regressors for event onsets
%
if nargin < 1
    iSubjectArray = setdiff([3:47], [9 14 25 31 32 33 34 37]);
    % 6,7 = noisy; 9
end

for iSubj = iSubjectArray
    %% Load Model and inputs
    paths = get_paths_wagad(iSubj);
    addpath(paths.code.model);
    input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));% input structure
    y              = [];
    includedTrials = [];
    probeSelection = [];
    outputmatrix   = [];
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
        
        [outputmatrixSession{iRun},iValid{iRun},Probe{iRun}] = apply_trigger(fileTrigger, ...
            SOC.Session(2).exp_data, offsetRunSeconds);
        choice      = outputmatrixSession{iRun}(:,4);
        wager       = outputmatrixSession{iRun}(:,7);
        y           =  [y; choice wager];
        outputmatrix   = [outputmatrix; outputmatrixSession{iRun}];
        includedTrials = [includedTrials; iValid{iRun}];
        probeSelection = [probeSelection; Probe{iRun}];
    end
    
    y(1,:)                = []; % Remove the first trial since it is not cued by the card
    includedTrials(1,:)   = []; % Remove the first trial since it is not cued by the card

    probeCategories = [probeSelection(1,1) probeSelection(14,1), ...
                       probeSelection(49,1) probeSelection(73,1),...
                       probeSelection(110,1)];
    probes          = [];
    
    for iProbe = 1:numel(probeCategories)
        switch probeCategories(iProbe)
            case 0
                probeValue = 0.5;
            case 1
                probeValue = 0.8;
            case 2
                probeValue = 0.2;
            case 3
                probeValue = 0.5;
                
        end
        
        probeValue(iProbe) = probeValue;
        
        probes = [probes; probeValue(iProbe)];
    end
    [behaviour_variables] = wagad_extract_behaviour(y,input_u,includedTrials,paths);
    behaviour_variables.probe = probes';
    save(paths.fnBehavMatrix,'outputmatrix','behaviour_variables','-mat');
    
    
end

