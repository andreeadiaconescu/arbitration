function wagad_plot_computational_quantities(iSubjectArray)


paths = get_paths_wagad(); % dummy subject to get general paths

if nargin < 1
    % manual setting...if you want to exclude any subjects
    iExcludedSubjects = [14 25 32 33 34 37];
    iSubjectArray = get_subject_ids(paths.data)';
    % manual setting...if you want to exclude any subjects
    iSubjectArray = setdiff(iSubjectArray, iExcludedSubjects);
end

addpath(paths.code.model);
nSubjects = numel(iSubjectArray);
nTrials   = 159;
tWindow   = 1:nTrials;

colourBlobArray = {'-m','-c','-r','-b','-m','-c','-r','-b','-g','-k'};
yLabelArray = {'\xi{_a}', '\xi{_c}','\mu{_1a}', '\mu{_1c}',...
    '\epsilon{_2a}', '\epsilon{_2c}','\epsilon{_3a}', '\epsilon{_3c}',...
    'Predicted Wager','Actual Wager'};

wager_computational_quantities = {nSubjects};
for iSubject  = 1:nSubjects
        iSubj = iSubjectArray(iSubject);
        paths = get_paths_wagad(iSubj);
        tmp   = load(paths.winningModel,'est','-mat'); % Select the winning model only;
        nonVolatilityModel = load(paths.fnFittedModel{4},'est','-mat');
        
        [computational_quantities]               = wagad_extract_computational_quantities(tmp);
        [computational_quantities_nonVolatility] = wagad_extract_computational_quantities(nonVolatilityModel);
        wager_computational_quantities{iSubject} = computational_quantities;
        nonVol_computational_quantities{iSubject}= computational_quantities_nonVolatility;
end
wager_computational3d          = reshape(wager_computational_quantities,nSubjects,1);
wager_computational3d          = cell2mat(wager_computational3d);
reshaped_wager_computational3d = reshape(wager_computational3d,nTrials,nSubjects,numel(yLabelArray));
meanComputationalQuantity      = squeeze(mean(reshaped_wager_computational3d, 2));
stdComputationalQuantity       = squeeze(std(reshaped_wager_computational3d,[],2));
errorBar                       = stdComputationalQuantity./sqrt(size(wager_computational_quantities,1));

novol_computational3d          = reshape(nonVol_computational_quantities,nSubjects,1);
novol_computational3d          = cell2mat(novol_computational3d);
reshaped_novol_computational3d = reshape(novol_computational3d,nTrials,nSubjects,numel(yLabelArray));
meanNoVolComputationalQuantity      = squeeze(mean(reshaped_novol_computational3d, 2));
stdNoVolComputationalQuantity       = squeeze(std(reshaped_novol_computational3d,[],2));
errorBarNoVol                      = stdNoVolComputationalQuantity./sqrt(size(novol_computational3d,1));

figure;
% Plot each computational quantity here
for c = 1:numel(yLabelArray)
    hp = subplot(5,2,c);
    tnueeg_line_with_shaded_errorbar(tWindow, meanComputationalQuantity(:,c), errorBar(:,c), colourBlobArray(:,c),1)
    set(get(hp,'YLabel'),'String',yLabelArray{c},'FontSize',20);
    set(hp,'LineWidth',2,'FontSize',32, 'FontName','Constantia');
    
end

subplot(5,2,1);
title('Mean Computational Quantities');


% Plot predicted wager with and without volatility tracking
input_u = load(fullfile(paths.code.model, 'final_inputs_advice_reward.txt'));
congruenceBehaviourAdvice = double(input_u(:,1)==input_u(:,1));
temp1                    = (congruenceBehaviourAdvice).*2;
cScoreVolatility         = ((temp1+(ones(size(input_u(:,1),1),1).*-1)).*meanComputationalQuantity(:,9));
cScoreNoVolatility       =((temp1+(ones(size(input_u(:,1),1),1).*-1)).*meanNoVolComputationalQuantity(:,9));

figure;
tnueeg_line_with_shaded_errorbar(tWindow, cScoreVolatility, errorBarNoVol(:,9), colourBlobArray(:,1),1);
hold all;
tnueeg_line_with_shaded_errorbar(tWindow, cScoreNoVolatility, errorBarNoVol(:,9), colourBlobArray(:,2),1);





