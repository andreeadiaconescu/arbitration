function iWinningModel            = calculate_winningModel(paths)

load([paths.stats.secondLevel.covariates, '/BMS.mat']);
[alpha,exp_r,xp,pxp,bor]=spm_BMS(models_wagad);

iWinningModel = find(exp_r==max(exp_r));

end