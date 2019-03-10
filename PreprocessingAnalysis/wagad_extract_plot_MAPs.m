function wagad_extract_plot_MAPs(iSubjectArray,currentMAP)

if nargin < 2
    currentMAP = 'accuracy';
end


% Dependent Variables: MAP Parameters
[variables_wager]          = wagad_extract_parameters_create_table(iSubjectArray);
[current_var,label,varName]= wager_extract_variable(variables_wager,currentMAP);



[meanVariables,errVariables] ...
                           = wager_violinplot(current_var,label);
wager_anova_stats(current_var,varName);
wager_plot_errorbar_MAPs(meanVariables,errVariables,label);
wager_plot_scatter_MAPs(current_var,label,currentMAP);








