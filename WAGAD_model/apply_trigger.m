function [outputmatrix,isValidTrial]=apply_trigger(InputFile1, InputFile2, offsetRunSeconds)

if nargin < 3
    offsetRunSeconds = 0;
end

% read trigger value
triggervalue = dlmread(InputFile1,'\t',0,0);

%read inputfile1 into a matrix
inmatrix = InputFile2;

[rs cs] =size(inmatrix);

outputmatrix=[];

totalOffsetSeconds = triggervalue(1)/1000 - offsetRunSeconds;

onsets1 = inmatrix(:,5) - totalOffsetSeconds;   % Onset Prediction
onsets2 = onsets1+5;                            % Onset Wager (plus 5 seconds)
onsets3 = inmatrix(:,13) - totalOffsetSeconds;  % Onset Outcome
onsets_resp = inmatrix(:,9) - totalOffsetSeconds;
onsets_resp(onsets_resp<0) = NaN;

isNotValid = inmatrix(:,8)<0;
RT = inmatrix(:,10)-inmatrix(:,10)-1000;
RT(find(isNotValid))=NaN;
RS=(1./RT)';
isValidTrial = inmatrix(:,8)>=0;
adviceBlue=mod(inmatrix(:,4),2);
resp = inmatrix(:,8);
respBlue=mod(resp,2); % blue = 1, green = 2
choice_congr  = (adviceBlue == respBlue);
choice=double(choice_congr);
takeAdv=sum(choice)./160.*100;
correctness=inmatrix(:,14)+ones(size(inmatrix,1),1);
outputmatrix=[onsets1 onsets2 onsets3 choice onsets_resp RS' inmatrix(:,17)];

