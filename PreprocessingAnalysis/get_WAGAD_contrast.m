function [iContrast] = get_WAGAD_contrast(dir1stLevel,regressor)

switch dir1stLevel
    case {'wagad_reversed','wagad_reanalysis','wagad_revision_eLife','wagad_revision','wagad_zscore','wagad_zscore_all'}
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
    case 'wagad_reversed_revised'
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
        
    case 'factorial_cosyne'
        switch regressor
            case 'volatility>stability'
                iContrast = 1;
        end
        
    case {'factorial_advice','factorial_reanalysis'}
        switch regressor
            case 'interaction_advice'
                iContrast = 4;
            case 'interaction_reward'
                iContrast = 3;
        end
end

end
