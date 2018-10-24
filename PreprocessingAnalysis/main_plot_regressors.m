function main_plot_regressors(pmod,SOC,est,paths,doPlotFigures,PlotFigureA,PlotFigureB)

probabilityReward = [ones(25,1)'.*0.9, ones(15,1)'.*0.60, ones(30,1)'.*0.5, ones(25,1)'.*0.4, ...
    ones(25,1)'.*0.9,ones(15,1)'.*0.9, ones(25,1)'.*0.1];

probabilityAdvice = [ones(25,1)'.*0.9, ones(15,1)'.*0.90, ones(30,1)'.*0.6, ones(25,1)'.*0.1, ...
    ones(25,1)'.*0.6, ones(15,1)'.*0.1, ones(25,1)'.*0.5];


if doPlotFigures
    if PlotFigureA
        figure;
        % Subplots
        subplot(5,1,1);
        plot(probabilityReward,'b', 'LineWidth', 4);
        hold on
        plot(probabilityAdvice,'r', 'LineWidth', 4);
        ylabel('Probabilities');
        
        subplot(5,1,2);
        plot(pmod(1,1).param{1}, 'm', 'LineWidth', 4);
        ylabel(pmod(1,1).name{1});
        
        subplot(5,1,3);
        plot(pmod(1,1).param{2} , 'r', 'LineWidth', 4);
        ylabel(pmod(1,1).name{2});
        
        subplot(5,1,4);
        plot(pmod(1,3).param{1}, 'c', 'LineWidth', 4);
        ylabel(pmod(1,3).name{1});
        
        subplot(5,1,5);
        plot(pmod(1,3).param{2}, 'b', 'LineWidth', 4);
        ylabel(pmod(1,3).name{2});
        hold on;
        xlabel('Trial number');
        subplot(5,1,1);
        hold on;
        title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
            num2str(est.p_obs.ze), ...
            ' for subject ', paths.idSubjBehav], ...
            'FontWeight', 'bold');
    elseif PlotFigureB
        figure;
        % Subplots
        subplot(4,1,1);
        plot(pmod(1,2).param{1}, 'm', 'LineWidth', 4);
        hold on;
        plot(ones(170,1).*0.25,'k','LineWidth', 1,'LineStyle','-.');
        
        subplot(4,1,2);
        plot(pmod(1,2).param{2} , 'r', 'LineWidth', 4);
        hold on;
        plot(ones(170,1).*0.25,'k','LineWidth', 1,'LineStyle','-.');
        
        subplot(4,1,3);
        plot(pmod(1,2).param{3}, 'c', 'LineWidth', 4);
        hold on;
        plot(ones(170,1).*1,'k','LineWidth', 1,'LineStyle','-.');
        
        subplot(4,1,4);
        plot(pmod(1,2).param{4}, 'b', 'LineWidth', 4);
        hold on;
        plot(predict_wager , 'r', 'LineWidth', 4);
        plot(ones(170,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
        xlabel('Trial number');
        subplot(4,1,1);
        hold on;
        title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
            num2str(est.p_obs.ze), ...
            ' for subject ', paths.idSubjBehav], ...
            'FontWeight', 'bold');
    else
        figure;
        % Subplots
        subplot(4,1,1);
        plot(pmod(1,3).param{1}, 'm', 'LineWidth', 4);
        ylabel(pmod(1,3).name{1});
        subplot(4,1,2);
        plot(pmod(1,3).param{2} , 'r', 'LineWidth', 4);
        ylabel(pmod(1,3).name{2});
        subplot(4,1,3);
        plot(pmod(1,3).param{3}, 'c', 'LineWidth', 4);
        ylabel(pmod(1,3).name{3});
        subplot(4,1,4);
        plot(pmod(1,3).param{4}, 'b', 'LineWidth', 4);
        ylabel(pmod(1,3).name{1});
        hold on;
        xlabel('Trial number');
        subplot(4,1,1);
        hold on;
        title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
            num2str(est.p_obs.ze), ...
            ' for subject ', paths.idSubjBehav], ...
            'FontWeight', 'bold');
    end
end

end