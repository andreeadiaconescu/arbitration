function wagad_scatterplot_computational_quantities(iSubjectArray)


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
nBeliefs  = 10;
nWagerTraj= 6;
tWindow   = 1:nTrials;

colourBlobArray = {'g','m','r'};
yLabelArray = {'\sigma_1 Decision','\xi{_a}', '\mu_3 Advice'};

wager_computational_quantities = {nSubjects};
for iSubject  = 1:nSubjects
        iSubj = iSubjectArray(iSubject);
        paths = get_paths_wagad(iSubj);
        tmp   = load(paths.winningModel,'est','-mat'); % Select the winning model only;
        
        [computational_quantities]               = wagad_extract_computational_quantities(tmp);
        wager_computational_quantities{iSubject} = computational_quantities;
end
wager_computational3d          = reshape(wager_computational_quantities,nSubjects,1);
wager_computational3d          = cell2mat(wager_computational3d);
reshaped_wager_computational3d = reshape(wager_computational3d,nTrials,nSubjects,nBeliefs);
meanComputationalQuantity      = squeeze(mean(reshaped_wager_computational3d, 2));
Arbitration_Wager              = meanComputationalQuantity(:,[1 end]);

for iSubject  = 1:nSubjects
        iSubj = iSubjectArray(iSubject);
        paths = get_paths_wagad(iSubj);
        tmp   = load(paths.winningModel,'est','-mat'); % Select the winning model only;
        
        [computational_quantities]                    = wagad_extract_beta_computational_quantities(tmp);
        wager_beta_computational_quantities{iSubject} = computational_quantities;
end
wager_computational3d          = reshape(wager_beta_computational_quantities,nSubjects,1);
wager_computational3d          = cell2mat(wager_computational3d);
reshaped_wager_computational3d = reshape(wager_computational3d,nTrials,nSubjects,nWagerTraj);
meanWagerQuantity              = squeeze(mean(reshaped_wager_computational3d, 2));
Wager_Quantities               = meanWagerQuantity(:,[1 2 5]);

quantitiesForWager             = Wager_Quantities;
nQuantities                    = 3;

figure;
% Plot each computational quantity here
for iQuantity = 1:nQuantities
    hp = subplot(1,3,iQuantity);
    X = Arbitration_Wager(:,2);
    Y = quantitiesForWager(:,iQuantity);
    
    regressionMatrix       = [X ones(size(X))];
    B                      = regressionMatrix\Y;
    [R,P]                  = corrcoef(X,Y);
    [~,~,~,~,STATS]        = regress(Y,regressionMatrix);
    effectSize             = (STATS(1))./(1-STATS(1));
    
    pValueArray(iQuantity)        = P(1,2);
    slopeArray(iQuantity)         = R(1,2);
    effectSizeArray(iQuantity)    = effectSize;
    
    scatter(X, Y, [],'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',colourBlobArray{iQuantity},...
        'LineWidth',2);
    hold all;
    plot(X, B(1)*X+B(2), '-k');
    axis square;
    set(get(hp,'YLabel'),'String',yLabelArray{iQuantity},'FontSize',20);
    xlabel(sprintf('Average Wager'));
    title({sprintf('correlation = %.3f', slopeArray(iQuantity)),...
        sprintf('p =%.1E', pValueArray(iQuantity)),...
        sprintf('Cohens f = %.3f', sqrt(effectSizeArray(iQuantity)))});
    set(hp,'LineWidth',2,'FontSize',36, 'FontName','Constantia');
end

end



