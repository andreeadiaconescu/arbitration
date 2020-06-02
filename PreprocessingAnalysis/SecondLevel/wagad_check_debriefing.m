function wagad_check_debriefing(iSubjectArray)

paths = get_paths_wagad(); % dummy subject to get general paths


addpath(paths.code.model);
nSubjects = numel(iSubjectArray);

for s = 1:nSubjects
    iSubj = iSubjectArray(s);
    paths = get_paths_wagad(iSubj);
    %%
    load(paths.winningModel,'est','-mat'); % Select the winning model only
    ka_r=est.p_prc.ka_r;
    ka_a=est.p_prc.ka_a;
    th_r=est.p_prc.th_r;
    th_a=est.p_prc.th_a;
    ze=est.p_obs.ze;
    beta=est.p_obs.be_ch;
    par{s,1} = ka_r; % kappa reward
    par{s,2} = ka_a; % kappa advice
    par{s,3} = th_r; % theta reward
    par{s,4} = th_a; % theta advice
    par{s,5} = log(ze);   % zeta
    par{s,6} = beta; % decision noise
end

% load data
[~,~,txt]      = xlsread(paths.design.debriefing,'Debriefing');
design_matrix  = [cell2mat(par) ones(size(cell2mat(par),1),1)];
% Independent Variables
nValidClmn = size(iSubjectArray,2)+1;
debriefing_advice_helpfulness                   = cell2mat(txt(2:nValidClmn,7)); % 4 is the average
debriefing_follow_adviser                       = cell2mat(txt(2:nValidClmn,8)); % 3 in percentage
debriefing_intentional_adviser                  = cell2mat(txt(2:nValidClmn,14)); % 5

% T-tests regarding how often participants' reported listening to the
% adviser
[h,p,ci,stats]=ttest(debriefing_follow_adviser,0.5);
statsDebriefing.pValue=p;
statsDebriefing.Tstats= stats.tstat;
statsDebriefing.df= stats.df;
disp(statsDebriefing);

% GLM
[B,BINT,R,RINT,stats.regression_results_rating] = regress(debriefing_advice_helpfulness,design_matrix);
disp(['GLM with taking debriefing_advice_helpfulness as the dependent variable:'...
    'the R-square statistic, the F statistic and p value  ' ...
    num2str(stats.regression_results_rating(1:3))]);

[B,BINT,R,RINT,stats.regression_results_validity] = regress(debriefing_follow_adviser,design_matrix);
disp(['GLM with taking debriefing_follow_adviser as the dependent variable:'...
    'the R-square statistic, the F statistic and p value  ' ...
    num2str(stats.regression_results_validity(1:3))]);

figure; histogram(debriefing_intentional_adviser);

% Correlations
[R,P]=corrcoef(cell2mat(par(:,2)),debriefing_advice_helpfulness);
disp(['Correlation between kappa_a and advice_helpfulness? Pvalue: ' num2str(P(1,2))]);
stats.correlation_kappaAdviceRating = R(1,2);
stats.p_kappaAdviceRating = P(1,2);
disp(stats);
wagad_plot_regression((cell2mat(par(:,2))),debriefing_advice_helpfulness);
xlabel('Adviser Helpfulness');
ylabel('\kappa{_a}');

[p,tbl,stats] = anova1(cell2mat(par(:,5)),categorical(debriefing_intentional_adviser));
stats.F_zetaAdviceRating = tbl{2,5};
stats.p_zetaAdviceRating = p;
disp(stats);

