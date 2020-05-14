function [iCombPercResp] = wagad_get_model_space

% pairs of perceptual and response model
iCombPercResp = zeros(9,2);
iCombPercResp(1:3,1) = 1;
iCombPercResp(4:6,1) = 2;
iCombPercResp(7:9,1) = 3;

iCombPercResp(1:3,2) = 1:3;
iCombPercResp(4:6,2) = 1:3;
iCombPercResp(7:9,2) = 1:3;

end