function [behaviour_variables] = wagad_extract_behaviour(y,input_u,iValid,paths)
% Get responses, performance accuracy, cumulative score
% Behaviour statistics collected here

% iValid is the row of trials where a response was made; 1 = response made;
%                                                        0 = miss
% logical array

iValid                    = logical(iValid);
totalTrials               = size(y(iValid,1),1);

congruenceBehaviourAdvice = double(y(iValid,1)==input_u(iValid,1));
overall_perf_acc         = sum(congruenceBehaviourAdvice)./totalTrials; % percentage of correct trials, disregarding misses
overall_per_trial_wager            = mean(nonzeros(y(iValid,2)));
take_adv_overall         = sum(y(iValid,1))./totalTrials;
temp1                    = (congruenceBehaviourAdvice).*2;
cScore                   = sum((temp1+(ones(size(y(iValid,1),1),1).*-1)).*y(iValid,2));

AccuracyStableCard    = sum(congruenceBehaviourAdvice.*paths.design.stableCardPhase(iValid))./sum(paths.design.stableCardPhase(iValid));
AccuracyVolatileCard  = sum(congruenceBehaviourAdvice.*paths.design.volatileCardPhase(iValid))./sum(paths.design.volatileCardPhase(iValid));
AccuracyStableAdvice  = sum(congruenceBehaviourAdvice.*paths.design.stableAdvicePhase(iValid))./sum(paths.design.stableAdvicePhase(iValid));
AccuracyVolatileAdvice= sum(congruenceBehaviourAdvice.*paths.design.volatileAdvicePhase(iValid))./sum(paths.design.volatileAdvicePhase(iValid));

AdviceStableCard    = sum(y(iValid,1).*paths.design.stableCardPhase(iValid))./sum(paths.design.stableCardPhase(iValid));
AdviceVolatileCard  = sum(y(iValid,1).*paths.design.volatileCardPhase(iValid))./sum(paths.design.volatileCardPhase(iValid));
AdviceStableAdvice  = sum(y(iValid,1).*paths.design.stableAdvicePhase(iValid))./sum(paths.design.stableAdvicePhase(iValid));
AdviceVolatileAdvice= sum(y(iValid,1).*paths.design.volatileAdvicePhase(iValid))./sum(paths.design.volatileAdvicePhase(iValid));

WagerStableCard    = mean(nonzeros(y(iValid,2).*paths.design.stableCardPhase(iValid)));
WagerVolatileCard  = mean(nonzeros(y(iValid,2).*paths.design.volatileCardPhase(iValid)));
WagerStableAdvice  = mean(nonzeros(y(iValid,2).*paths.design.stableAdvicePhase(iValid)));
WagerVolatileAdvice= mean(nonzeros(y(iValid,2).*paths.design.volatileAdvicePhase(iValid)));

behaviour_variables = [];
behaviour_variables.overall_perf_acc = overall_perf_acc;
behaviour_variables.overall_wager    = overall_per_trial_wager;
behaviour_variables.cScore           = cScore;
behaviour_variables.take_adv_overall = take_adv_overall;

behaviour_variables.AccuracyStableCard      = AccuracyStableCard;
behaviour_variables.AccuracyVolatileCard    = AccuracyVolatileCard;
behaviour_variables.AccuracyStableAdvice    = AccuracyStableAdvice;
behaviour_variables.AccuracyVolatileAdvice  = AccuracyVolatileAdvice;

behaviour_variables.AdviceStableCard      = AdviceStableCard;
behaviour_variables.AdviceVolatileCard    = AdviceVolatileCard;
behaviour_variables.AdviceStableAdvice    = AdviceStableAdvice;
behaviour_variables.AdviceVolatileAdvice  = AdviceVolatileAdvice;

behaviour_variables.WagerStableCard      = WagerStableCard;
behaviour_variables.WagerVolatileCard    = WagerVolatileCard;
behaviour_variables.WagerStableAdvice    = WagerStableAdvice;
behaviour_variables.WagerVolatileAdvice  = WagerVolatileAdvice;

end