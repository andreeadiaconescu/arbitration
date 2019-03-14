function wager_plot_scatter_MAPs(current_var,label,currentMAP)

x = current_var(:,1);
y = current_var(:,2);
z = current_var(:,3);
t = current_var(:,4);

Variables = {x y z t};
Groups    = {ones(length(x), 1) 2*ones(length(y), 1) 3*ones(length(z), 1) 4*ones(length(t), 1)};

GroupingVariables = {'Stable Card','Volatile Card',...
                     'Stable Advice','Volatile Advice'};
figure;

H   = Variables;
N=numel(Variables);

switch currentMAP
    case 'accuracy'
        colors=winter(numel(H));
    case 'advice'
        colors=cool(numel(H));
    otherwise
        colors=copper(numel(H));
end
for i=1:N
    e = notBoxPlot(cell2mat(H(i)),cell2mat(Groups(i)));
    set(e.data,'MarkerSize', 10);
    if i == 2 || i == 4
        set(e.data,'Marker','o');
        set(e.data,'Marker','o');
    end
    if i==1, hold on, end
    set(e.data,'Color',colors(i,:))
    set(e.sdPtch,'FaceColor',colors(i,:));
    set(e.semPtch,'FaceColor',[0.9 0.9 0.9]);
end
set(gca,'XTick',1:N)
set(gca,'XTickLabel',GroupingVariables);
set(gca,'FontName','Constantia','FontSize',36);
ylabel(label);
end
