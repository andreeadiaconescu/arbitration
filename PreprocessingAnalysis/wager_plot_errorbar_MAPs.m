function wager_plot_errorbar_MAPs(meanVariables,errVariables,label)

GroupingVariables = {'Stable Card','Volatile Card',...
                     'Stable Advice','Volatile Advice'};

figure; 

H   = meanVariables;
err = errVariables;
N=numel(meanVariables);
colors=winter(numel(H));
for i=1:N
    h=bar(i,H(i));
    hold on; 
    e = errorbar(i,H(i),err(i));
    e.Marker = '.';
    e.MarkerSize = 10;
    e.MarkerEdgeColor = 'black';
    e.MarkerFaceColor = 'white';
    e.Color = 'black';
    e.CapSize = 15;
    if i==1, hold on, end
    set(h,'FaceColor',colors(i,:));
end
set(gca,'XTick',1:N)
set(gca,'XTickLabel',GroupingVariables);
set(gca,'FontName','Constantia','FontSize',20);
ylabel(label);
end