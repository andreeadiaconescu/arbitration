function [current_var,label,varName]= wager_extract_variable(variables_wager,currentMAP)


accuracy      = [variables_wager(:,17) variables_wager(:,18) variables_wager(:,19) variables_wager(:,20)];
advice        = [variables_wager(:,21) variables_wager(:,22) variables_wager(:,23) variables_wager(:,24)];
wager         = [variables_wager(:,25) variables_wager(:,26) variables_wager(:,27) variables_wager(:,28)];


switch currentMAP
    case 'accuracy'
        label       = 'Performance Accuracy';
        varName     = 'accuracy';
        current_var = accuracy;
    case 'advice'
        label       = 'Taking Advice';
        varName     = 'advice';
        current_var = advice;
    case 'wager'
        label       = 'Wager Magnitude';
        varName     = 'wager';
        current_var = wager;
    case 'probe'
        label       = 'MC Probe';
        varName     = 'probe';
        current_var = [];
        
end

end