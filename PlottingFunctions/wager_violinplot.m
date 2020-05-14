function [meanVariables,errVariables] = wager_violinplot(current_var,label)

x = current_var(:,1);
y = current_var(:,2);
z = current_var(:,3);
t = current_var(:,4);

Variables = [x; y; z; t];
Groups    = [ones(length(x), 1); 2*ones(length(y), 1); 3*ones(length(z), 1);4*ones(length(t), 1)];

errVariables      = [std(x)/sqrt(length(x));...
                    std(y)/sqrt(length(y));...
                    std(z)/sqrt(length(z));...
                    std(t)/sqrt(length(t))];
meanVariables     = [mean(x); mean(y); mean(z); mean(t)];

GroupingVariables = {'Stable Card','Volatile Card',...
                     'Stable Advice','Volatile Advice'};

figure; violinplot(Variables, Groups);
set(gca,'xticklabel',GroupingVariables);
ylabel(label);
end