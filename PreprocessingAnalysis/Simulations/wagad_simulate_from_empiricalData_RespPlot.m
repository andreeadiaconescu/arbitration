function wagad_simulate_from_empiricalData_RespPlot(variables_all)

%% Plot slopes
yLabelArray    = {'\zeta','\beta','\sigma_1',' \xi','\sigma_2,a','\sigma_2,c','\mu_3,a','\mu_3,c'};
colourArray    = {'b', 'k', 'm', 'r', 'c', 'g','k','y'};
xLimitArray    = {[-1.5 5], [0 5.5], [-4 1],[-1.3 4.3], [-4 4], [-2 4],[-10.3 1.3],[-5 3]};
yLimitArray    = {[-1.5 5], [0 5.5], [-4 1],[-1.3 4.3], [-4 4], [-2 4],[-10.3 1.3],[-5 3]};

parameterArray = yLabelArray;
nParameters    = size(parameterArray,2);
figure;
for iParameter = 1:nParameters
    subplot(4,2,iParameter);
    X = variables_all(:,iParameter);
    Y = variables_all(:,iParameter + nParameters);
    
    regressionMatrix       = [X ones(size(X))];
    B                      = regressionMatrix\Y;
    slopeArray(iParameter) = B(1);
    
    [R,P] = corrcoef(X,Y);
    [~,~,~,~,STATS] = regress(Y,regressionMatrix);
    effectSize      = (STATS(1))./(1-STATS(1));
    
    corrCoefficientArray(iParameter) = R(1,2);
    pValueArray(iParameter)        = P(1,2);
    
    effectSizeArray(iParameter)    = effectSize;
    
    scatter(X, Y, [],'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',colourArray{iParameter},...
        'LineWidth',1.5);
    hold all;
    plot(X, B(1)*X+B(2), 'k');
    title({sprintf('Correlation = %.3f', corrCoefficientArray(iParameter)),...
        sprintf('p =%.1E', pValueArray(iParameter)),...
        sprintf('Cohens f = %.3f', sqrt(effectSizeArray(iParameter)))});
    xlabel(sprintf('parameter: %s', yLabelArray{iParameter}));
    xlim(xLimitArray{iParameter});
    ylim(yLimitArray{iParameter});
    set(gca,'FontName','Constantia','FontSize',20);
end

titleString = sprintf('%s - Recoverability Perceptual MAPs (Model: %s)','hgf_binary3l_reward_social');
% nicer figure name w/o white spaces and minus
figFileString = regexprep(regexprep(...
    regexprep([titleString '.png'], '( |-|:|\(|\))*', '_'), ...
    '(_)+', '_'), '_\.','\.');
% saveas(gcf, fullfile(options.sim.figure, ...
%     figFileString));

end