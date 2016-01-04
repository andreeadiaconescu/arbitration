function outputmatrix=apply_trigger(InputFile1, InputFile2)

% read trigger value
triggervalue = dlmread(InputFile1,'\t',0,0);

%read inputfile1 into a matrix
inmatrix = InputFile2;

[rs cs] =size(inmatrix);

outputmatrix=[];


onsets1=inmatrix(:,5)-triggervalue(1)/1000;   % Onset Prediction
onsets2=onsets1+2;                            % Onset Wager (plus 2 seconds)
onsets3=inmatrix(:,13)-triggervalue(1)/1000;  % Onset Outcome
onsets_resp=(inmatrix(:,9)-triggervalue(1)/1000);
onsets_resp(onsets_resp<0) = NaN;

isNotValid = inmatrix(:,10)<0;
RT = inmatrix(:,10)-inmatrix(:,10)-1000;
RT(find(isNotValid))=NaN;
RS=(1./RT)';
isValidTrial = inmatrix(:,10)>=0;
    adviceBlue=mod(inmatrix(:,4),2);
    resp = inmatrix(:,8);
    respBlue=mod(resp,2); % blue = 1, green = 2
    choice_congr  = (adviceBlue == respBlue);
    choice=double(choice_congr);
    takeAdv=sum(choice)./160.*100;
    correctness=inmatrix(:,14)+ones(size(inmatrix,1),1);
    outputmatrix=[onsets1 onsets2 onsets3 choice onsets_resp RS' inmatrix(:,17)];
    
