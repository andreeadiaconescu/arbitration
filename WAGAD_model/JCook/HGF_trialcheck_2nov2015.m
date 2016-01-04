%% Clear workspace
close all
clear all
clc

save ('Estimates_nov6_round8')

% Inputs
% schedule 1:
% inputs_reward = [1	0	1	1	1	1	1	0	1	1	1	1	1	1	1	1	1	1	1	0	0	1	1	0	0	1	1	1	1	1	0	1	1	1	0	1	1	1	1	1	0	1	1	1	1	1	1	0	0	1	0	1	1	1	0	1	0	1	1	0	1	0	0	0	0	0	0	0	0	0	0	0	1	0	1	0	0	0	0	1	1	0	1	1	0	1	1	1	1	1	1	1	1	1	1	1	1	0	1	0	0	1	0	0	0	0	1	0	0	1	0	0	0	0	1	0	0	0	0	0]';
% inputs_advice = [1	0	0	0	1	1	0	0	1	1	1	0	1	1	1	1	1	1	0	0	0	1	1	1	0	1	1	0	1	1	1	0	0	0	1	0	1	0	0	1	0	1	0	0	1	1	1	0	0	1	1	1	0	0	1	0	0	0	0	1	1	0	0	1	0	1	0	0	0	0	1	1	0	1	0	1	1	1	1	0	0	1	0	0	1	1	0	0	1	1	0	0	0	0	0	0	0	1	1	1	1	0	0	1	1	0	0	0	1	0	1	1	1	1	0	1	1	1	1	1]';

% schedule 2:
% inputs_reward = [1	1	0	0	1	1	0	1	1	1	1	0	1	1	1	1	1	1	0	1	1	1	1	0	1	1	1	0	1	1	0	0	0	0	0	0	1	0	0	1	1	1	0	0	1	1	1	1	1	1	0	1	0	0	0	0	1	0	0	0	1	1	1	0	1	0	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0]';
% inputs_advice = [1	0	0	0	1	1	0	0	1	1	1	0	1	1	1	1	1	1	0	0	0	1	1	1	0	1	1	0	1	1	1	0	0	0	1	0	1	0	0	1	0	1	0	0	1	1	1	0	0	1	1	1	0	0	1	0	0	0	0	1	1	0	0	1	0	1	0	0	0	0	1	1	0	1	0	1	1	1	1	0	0	1	0	0	1	1	0	0	1	1	0	0	0	0	0	0	0	1	1	1	1	0	0	1	1	0	0	0	1	0	1	1	1	1	0	1	1	1	1	1]';

% schedule 3:
inputs_reward = [1	0	1	1	1	1	1	0	1	1	1	1	1	1	1	1	1	1	1	0	0	1	1	0	0	1	1	1	1	1	0	1	1	1	0	1	1	1	1	1	0	1	1	1	1	1	1	0	0	1	0	1	1	1	0	1	0	1	1	0	1	0	0	0	0	0	0	0	0	0	0	0	1	0	1	0	0	0	0	1	1	0	1	1	0	1	1	1	1	1	1	1	1	1	1	1	1	0	1	0	0	1	0	0	0	0	1	0	0	1	0	0	0	0	1	0	0	0	0	0]';
inputs_advice = [0	1	1	1	0	0	1	1	0	0	0	1	0	0	0	0	0	0	1	1	1	0	0	0	1	0	0	1	0	0	0	1	1	1	0	1	0	1	1	0	1	0	1	1	0	0	0	1	1	0	0	0	1	1	0	1	1	1	1	0	0	1	1	0	1	0	1	1	1	1	0	0	1	0	1	0	0	0	0	1	1	0	1	1	0	0	1	1	0	0	1	1	1	1	1	1	1	0	0	0	0	1	1	0	0	1	1	1	0	1	0	0	0	0	1	0	0	0	0	0]';

% schedule 4:
% inputs_reward = [1	1	0	0	1	1	0	1	1	1	1	0	1	1	1	1	1	1	0	1	1	1	1	0	1	1	1	0	1	1	0	0	0	0	0	0	1	0	0	1	1	1	0	0	1	1	1	1	1	1	0	1	0	0	0	0	1	0	0	0	1	1	1	0	1	0	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0]';
% inputs_advice = [0	1	1	1	0	0	1	1	0	0	0	1	0	0	0	0	0	0	1	1	1	0	0	0	1	0	0	1	0	0	0	1	1	1	0	1	0	1	1	0	1	0	1	1	0	0	0	1	1	0	0	0	1	1	0	1	1	1	1	0	0	1	1	0	1	0	1	1	1	1	0	0	1	0	1	0	0	0	0	1	1	0	1	1	0	0	1	1	0	0	1	1	1	1	1	1	1	0	0	0	0	1	1	0	0	1	1	1	0	1	0	0	0	0	1	0	0	0	0	0]';

inputs_groupcorrectness = 1-abs(inputs_reward - inputs_advice);

plot(mysmooth(inputs_groupcorrectness',6),'r');
hold on
plot(mysmooth(inputs_reward',6),'b');
title({'Schedule 3'})

%% Create text file that you will write results to
header1 = ['est'];
header2 = ['mu2r_0mu'];
header3 = ['logsa2r_0mu'];
header4 = ['mu3r_0mu'];
header5 = ['logsa3r_0mu'];
header6 = ['logitkamu_r'];
header7 = ['ommu_r'];
header8 = ['logitthmu_r'];
header9 = ['mu2a_0mu'];
header10 = ['logsa2a_0mu'];
header11 = ['mu3a_0mu'];
header12 = ['logsa3a_0mu'];
header13 = ['logitkamu_a'];
header14 = ['ommu_a'];
header15 = ['logitthmu_a'];
header16 = ['logze1mu'];
header17 = ['logbetamu'];


fid = fopen(['Estimates_nov6_round8.txt'],'at');
for header = [1:17];
    v = genvarname(['header' num2str(header)]);
    eval(['header =' v ]);
    for i = [1:length(header)];
        printout = header(:,i);
        fwrite(fid,printout);
    end
    fprintf(fid,'\t');
end

fid = fopen(['Estimates_nov6_round8.txt'],'at');
fprintf(fid,'\n');
fprintf(fid,'%6.2f',0); %pnum
fprintf(fid,'\t');
fprintf(fid,'%6.2f',[0 0 1 -0.2231 0.25000 -4 0.25 0 0 1 -0.2231 0.25000 -4 0.25]);
fprintf(fid,'\t');
fprintf(fid,'%6.2f',[0 48]);
fclose(fid);

j = 1;
%% =========================================================================
for  i = [1:10];
    fprintf('\nFinding the Bayes optimal perceptual parameters for\nthis dataset under the HGF (Diaconescu) model:\n')
    fprintf('\n>> sim = simResponses(inputs_reward, inputs_groupcorrectness, ''hgf_binary3l_reward_social'', [0  0 1.0000 log(0.8) 0.5000 -6 0.2500  0  0 1.0000 log(0.8) 0.5000 -6 0.25], ''softmax_reward_social'', [0 log(48)]);\n')
    sim = simResponses(inputs_reward, inputs_groupcorrectness, 'hgf_binary3l_reward_social', [0 0 1 -0.2231 0.25000 -4 0.25 0 0 1 -0.2231 0.25000 -4 0.25], 'softmax_reward_social', [0 log(48)]);
%     inputs_correctness = 1-abs(inputs_groupcorrectness - sim.y);
    est = fitModel([sim.y], [inputs_reward inputs_groupcorrectness])
    
    v = genvarname(['Est' num2str(i)]);
    eval([v '= est;']);
    save ('Estimates_nov6_round8', ['Est' num2str(i)],'-append')
    v = genvarname(['Sim' num2str(i)]);
    eval([v '= sim;']);
    save ('Estimates_nov6_round8', ['Sim' num2str(i)],'-append')
    
    fit_plotCorr(est)
%     hgf_plotTraj_reward_social(est)
%     hgf_plotLearningRate_reward_social(est)
    
    %% Write results to text file
    fid = fopen(['Estimates_nov6_round8.txt'],'at');
    fprintf(fid,'\n');
    fprintf(fid,'%6.2f',j); %pnum
    fprintf(fid,'\t');
    fprintf(fid,'%6.2f',est.p_prc.p);
    fprintf(fid,'\t');
    fprintf(fid,'%6.2f',est.p_obs.p);
    fclose(fid);
    
    j = j+1;
end





%

