function [iContrast] = get_WAGAD_contrast(dir1stLevel,regressor)

switch dir1stLevel
    
    case 'wagad_cosyne'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'card_weighting'
                iContrast = 4;
            case 'precision_advice'
                iContrast = 5;
            case 'precision_card'
                iContrast = 6;
            case 'basic_wager'
                iContrast = 7;
            case 'belief_precision'
                iContrast = 8;
            case 'belief'
                iContrast = 9;
            case 'surprise'
                iContrast = 10;
            case 'wager_magnitude'
                iContrast = 11;
            case 'outcome'
                iContrast = 12;
            case 'advice_epsilon2'
                iContrast = 13;
            case 'reward_epsilon2'
                iContrast = 14;
            case 'advice_epsilon3'
                iContrast = 15;
            case 'reward_epsilon3'
                iContrast = 16;
        end
    case 'revised_model_arbitration1'
       switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'card_weighting'
                iContrast = 4;
            case 'precision_advice'
                iContrast = 5;
            case 'precision_card'
                iContrast = 6;
            case 'basic_wager'
                iContrast = 7;
            case 'belief_precision'
                iContrast = 8;
            case 'belief'
                iContrast = 9;
            case 'alpha'
                iContrast = 10;
            case 'wager_magnitude'
                iContrast = 11;
            case 'outcome'
                iContrast = 12;
            case 'advice_epsilon2'
                iContrast = 13;
            case 'reward_epsilon2'
                iContrast = 14;
            case 'advice_epsilon3'
                iContrast = 15;
            case 'reward_epsilon3'
                iContrast = 16;
        end
       
    case 'factorial_design'
        switch regressor
            case 'stability'
                iContrast = 1;
            case 'volatility'
                iContrast = 2;
            case 'interaction_advice'
                iContrast = 3;
            case 'stabilityvvolatility'
                iContrast = 4;
        end
    case 'revised_model_wagad'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'card_weighting'
                iContrast = 4;
            case 'arbitration1'
                iContrast = 5;
            case 'precision_advice'
                iContrast = 6;
            case 'basic_wager'
                iContrast = 7;
            case 'belief_precision'
                iContrast = 8;
            case 'belief'
                iContrast = 9;
            case 'alpha'
                iContrast = 10;
            case 'wager_magnitude'
                iContrast = 11;
            case 'outcome'
                iContrast = 12;
            case 'advice_epsilon2'
                iContrast = 13;
            case 'reward_epsilon2'
                iContrast = 14;
            case 'advice_epsilon3'
                iContrast = 15;
            case 'reward_epsilon3'
                iContrast = 16;
        end
    case 'newmodel_zeta_socialweighting'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 3;
            case 'precision_advice'
                iContrast = 4;
            case 'precision_card'
                iContrast = 5;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'belief'
                iContrast = 8;
            case 'alpha'
                iContrast = 9;
            case 'wager_magnitude'
                iContrast = 10;
            case 'outcome'
                iContrast = 11;
            case 'advice_epsilon2'
                iContrast = 12;
            case 'reward_epsilon2'
                iContrast = 13;
            case 'advice_epsilon3'
                iContrast = 14;
            case 'reward_epsilon3'
                iContrast = 15;
        end
    case 'newmodel_precision_ortho_off'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'new_arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'precision_advice'
                iContrast = 4;
            case 'precision_card'
                iContrast = 5;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'belief'
                iContrast = 8;
            case 'alpha'
                iContrast = 9;
            case 'wager_magnitude'
                iContrast = 10;
            case 'outcome'
                iContrast = 11;
            case 'advice_epsilon2'
                iContrast = 12;
            case 'reward_epsilon2'
                iContrast = 13;
            case 'advice_epsilon3'
                iContrast = 14;
            case 'reward_epsilon3'
                iContrast = 15;
        end
    case 'newmodel_design_ortho_off'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'new_arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'prediction_advice'
                iContrast = 4;
            case 'prediction_card'
                iContrast = 5;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'belief'
                iContrast = 8;
            case 'alpha'
                iContrast = 9;
            case 'wager_magnitude'
                iContrast = 10;
            case 'outcome'
                iContrast = 11;
            case 'advice_epsilon2'
                iContrast = 12;
            case 'reward_epsilon2'
                iContrast = 13;
            case 'advice_epsilon3'
                iContrast = 14;
            case 'reward_epsilon3'
                iContrast = 15;
        end
        
    case 'new_design'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'new_arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'prediction_advice'
                iContrast = 4;
            case 'prediction_card'
                iContrast = 5;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'belief'
                iContrast = 8;
            case 'alpha'
                iContrast = 9;
            case 'wager_magnitude'
                iContrast = 10;
            case 'outcome'
                iContrast = 11;
            case 'advice_epsilon2'
                iContrast = 12;
            case 'reward_epsilon2'
                iContrast = 13;
            case 'advice_epsilon3'
                iContrast = 14;
            case 'reward_epsilon3'
                iContrast = 15;
        end
    case 'fifth_design'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'new_arbitration'
                iContrast = 2;
            case 'social_weighting'
                iContrast = 3;
            case 'prediction_advice'
                iContrast = 4;
            case 'prediction_card'
                iContrast = 5;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'belief'
                iContrast = 8;
            case 'wager_magnitude'
                iContrast = 9;
            case 'outcome'
                iContrast = 10;
            case 'advice_delta1'
                iContrast = 11;
            case 'reward_delta1'
                iContrast = 12;
            case 'advice_delta2'
                iContrast = 13;
            case 'reward_delta2'
                iContrast = 14;
        end
    case 'first_design'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'basic_wager'
                iContrast = 3;
            case 'belief_precision'
                iContrast = 4;
            case 'basic_outcome'
                iContrast = 5;
            case 'delta1_advice'
                iContrast = 6;
            case 'delta1_cue'
                iContrast = 7;
        end
    case 'ModelBased_ModelFree'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'Arbitration_StableAUnstableR'
                iContrast = 3;
            case 'Arbitration_StableAStableR'
                iContrast = 4;
            case 'Arbitration_UnstableAStableR'
                iContrast = 5;
            case 'Arbitration_UnstableAUnstableR'
                iContrast = 14;
            case 'basic_wager'
                iContrast = 6;
            case 'belief_precision'
                iContrast = 7;
            case 'Wager_StableAUnstableR'
                iContrast = 8;
            case 'Wager_StableAStableR'
                iContrast = 9;
            case 'Wager_UnstableAStableR'
                iContrast = 10;
            case 'Wager_UnstableAUnstableR'
                iContrast = 15;
            case 'basic_outcome'
                iContrast = 11;
            case 'delta1_advice'
                iContrast = 12;
            case 'delta1_cue'
                iContrast = 13;
        end
    case 'forth_design'
        switch regressor
            case 'basic_advice'
                iContrast = 1;
            case 'arbitration'
                iContrast = 2;
            case 'prediction_advice'
                iContrast = 3;
            case 'prediction_cue'
                iContrast = 4;
            case 'basic_wager'
                iContrast = 5;
            case 'belief_precision'
                iContrast = 6;
            case 'belief'
                iContrast = 7;
            case 'outcome'
                iContrast = 8;
            case 'advice_delta1'
                iContrast = 9;
            case 'reward_delta1'
                iContrast = 10;
            case 'advice_delta2'
                iContrast = 11;
            case 'reward_delta2'
                iContrast = 12;
        end
    case 'factorial_design_cue'
        switch regressor
            case 'main_stability'
                iContrast = 1;
            case 'main_volatility'
                iContrast = 2;
            case 'interaction_reward'
                iContrast = 3;
            case 'interaction_advice'
                iContrast = 4;
        end
    case 'factorial_design_wager'
        switch regressor
            case 'main_stability'
                iContrast = 1;
            case 'main_volatility'
                iContrast = 2;
            case 'interaction_reward'
                iContrast = 3;
            case 'interaction_advice'
                iContrast = 4;
        end
end

end
