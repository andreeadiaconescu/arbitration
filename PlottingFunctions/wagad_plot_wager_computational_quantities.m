function wagad_plot_wager_computational_quantities(iSubjectArray)


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

colourBlobArray = {'g','-m','-r','-b','-m','-c'};
yLabelArray = {'\sigma_1 Decision', '\xi Social',...
              '\sigma_2 Advice', '\sigma_2 Card',...
              '\mu_3 Advice', '\mu_3 Card'};

wager_beta_computational_quantities = {nSubjects};
for iSubject  = 1:nSubjects
        iSubj = iSubjectArray(iSubject);
        paths = get_paths_wagad(iSubj);
        tmp   = load(paths.winningModel,'est','-mat'); % Select the winning model only;
        
        [computational_quantities]                    = wagad_extract_beta_computational_quantities(tmp);
        wager_beta_computational_quantities{iSubject} = computational_quantities;
end
wager_computational3d          = reshape(wager_beta_computational_quantities,nSubjects,1);
wager_computational3d          = cell2mat(wager_computational3d);
reshaped_wager_computational3d = reshape(wager_computational3d,nTrials,nSubjects,numel(yLabelArray));
meanComputationalQuantity      = squeeze(mean(reshaped_wager_computational3d, 2));
stdComputationalQuantity       = squeeze(std(reshaped_wager_computational3d,[],2));
errorBar                       = stdComputationalQuantity./sqrt(size(wager_beta_computational_quantities,1));

figure;
% Plot each computational quantity here
for c = 1:numel(yLabelArray)
    hp = subplot(3,2,c);
    tnueeg_line_with_shaded_errorbar(tWindow, meanComputationalQuantity(:,c), errorBar(:,c), colourBlobArray(:,c),1)
    set(get(hp,'YLabel'),'String',yLabelArray{c},'FontSize',20);
    set(hp,'LineWidth',2,'FontSize',36, 'FontName','Constantia');
    
end

subplot(3,2,1);
title('Mean Computational Quantities');


end



