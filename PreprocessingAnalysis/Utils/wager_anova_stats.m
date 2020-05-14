function wager_anova_stats(current_var,varName)

fprintf('\n===\n\t The following tests are applied to the variable:\n\n');
disp(varName);
fprintf('\n\n===\n\n');



% Repeated-measures ANOVA with within-subject factors
betweenSubjectLabels = [1:size(current_var,1)]';

t = table(betweenSubjectLabels,current_var(:,1),current_var(:,2),current_var(:,3),current_var(:,4),...
    'VariableNames',...
    {'betweenSubjectLabels','stable_card','volatile_card','stable_advice','volatile_advice'});
Meas  = table([1:4]','VariableNames',{'phases'});

rm = fitrm(t,'stable_card-volatile_advice~betweenSubjectLabels','WithinDesign',Meas);

ranovatbl = ranova(rm);

ANOVA_CurrentVar = ranovatbl;

disp(ANOVA_CurrentVar);

% 2-way Repeated Measures ANOVA

variable             = reshape(current_var,size(current_var,1)*4,1);
subjectLabel         = [betweenSubjectLabels;betweenSubjectLabels;betweenSubjectLabels;betweenSubjectLabels];
factor2_phase        = [ones(size(current_var,1),1);-1*ones(size(current_var,1),1);ones(size(current_var,1),1);...
                        -1*ones(size(current_var,1),1)];
factor1_cue          = [ones(size(current_var,1),1);ones(size(current_var,1),1);-1*ones(size(current_var,1),1);...
                        -1*ones(size(current_var,1),1)];
stats                = rm_anova2(variable,subjectLabel,factor1_cue,factor2_phase,{'cue','phase'});

disp(stats);
end