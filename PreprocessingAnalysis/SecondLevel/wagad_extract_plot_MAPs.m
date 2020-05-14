function wagad_extract_plot_MAPs(iSubjectArray,currentMap)

if nargin < 2
    currentMap = 'accuracy';
end

probe = true;


% Dependent Variables: MAP Parameters
[variables_wager]          = wagad_extract_parameters_create_table(iSubjectArray);
[current_var,label,varName]= wager_extract_variable(variables_wager,currentMap);
if probe
    [current_var]         = wagad_analyze_probe(iSubjectArray);
end

[meanVariables,errVariables] ...
    = wager_violinplot(current_var,label);
wager_anova_stats(current_var,varName);
wager_plot_errorbar_MAPs(meanVariables,errVariables,label);
wager_plot_scatter_MAPs(current_var,label,currentMap);








