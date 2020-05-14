function [fh,sh,lgh_a] = wagad_plot_trajectories(iSubject,trajectories,ColorScheme,fh,sh)

counterArray = {[1:3],[4:6],[7:9],[10:12],[13:15]};
ylabelArray = {'\mu{_3a}','mu{_1a}','mu{_3c}','mu{_1c}','predicted_wager'};
titleArray = {'Estimated volatility advice','Prediction advice',...
    'Estimated volatility card','Prediction card',...
    'Predicted Wagers'};
if isempty(fh)
    % Set up display
    scrsz = get(0,'screenSize');
    outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
    fh = figure(...
        'OuterPosition', outerpos,...
        'Name','Model fit results');
else
    figure(fh);
end

for iTrajectory     = 1:size(trajectories,2)-1
    sh(iTrajectory)   = subplot(5,1,iTrajectory);
    currentTrajectory = trajectories(iTrajectory);
    currCol           = counterArray{iTrajectory};
    axes(sh(iTrajectory))
    plot(1:160, cell2mat(currentTrajectory), 'Color', ColorScheme(currCol), 'LineWidth', 2);
    hold on;
    xlim([1 160]);
    title(titleArray(iTrajectory), 'FontWeight', 'bold');
    xlabel('Trial number');
    ylabel(ylabelArray(iTrajectory));
end
sh(5)   = subplot(5,1,5);
lgh_a{iSubject} = plot(1:160, cell2mat(trajectories(5)), 'Color', ColorScheme(counterArray{5}), 'LineWidth', 2);
hold on;
xlim([1 160]);
title(titleArray(5), 'FontWeight', 'bold');
xlabel('Trial number');
ylabel(ylabelArray(5));

