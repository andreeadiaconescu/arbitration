function SOC = MS_fMRI_Wager_Sess1b_final(subject,run,scanner_mode,exp_task,mode_key)
% This program can be run from the command line, specifying the subject's
% name, the scanner mode (0 for behaviour, 1 and 2 for scanner), the exp task
% (0 = practice; 1=task)and the mode of the keys (1 for blue or 2 for green):
%
% e.g.  >> SL_adv('AD', 1, 0, 1, 2)
%
% Alternatively it can be run without parameters, just by hitting F5
% (RUN)
% In this case, data are saved to a default file 'TEST.MAT' and 'TEST.log'.
%
% Andreea Diaconescu, Lilian Weber
% start:13-01-2012
% modified:17-07-2015 Andreea Diaconescu for Pharmacological
% Study (DMPAD-Behaviour)

% When was the script started?
%addpath(genpath('C:\cogent\Cogent2000v1.32\Toolbox'));

disp('This is the social learning experiment');
pathname=fileparts(mfilename('fullpath')); %%% CHANGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters that can be changed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 0                          % 'nargin' returns the number of parameters specified by the user
    subject = 'WAGAD_0038';            % if there were no parameters, just use a default subject name
    scanner_mode = 1 ;                  % For the wagering paradigm, leave default scanner_mode=0
    run = 6;                            % For wagering paradigm, run 1 (Male Default Adviser), run 3  (Male Backup Adviser), run 5 (Female Default
    % Adviser), run 7 (Female Backup Adviser)
    
    
    exp_task = 2;                       % Change for practice: practice = 1; task = 2
    mode_key = 2;                       % This refers to the response button mode mode_key=1 (blue is on the left); mode_key=2 (green is on the left)
elseif exist( subject ,'file')~=0;      % otherwise (if there was a subject specified)...
    % check whether a file with that name exists already
    disp('file for this subject exists already! aborting...')
    clear all; return;                  % abort experiment, rather than overwrite existing data!!!
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define fields in SOC
% save subjects details
SOC.subject.name  = subject;
SOC.mode_key      = mode_key;
SOC.exp_task      = exp_task;

language_inst = 1;

%configure scanner mode,
%0 = keyboard input, behavioural trials
%1 = test serial port input, no scanner trigger
%2 = USB port input, scanner trigger on
%3 = RTBox EEG Lab
SOC.scanner_mode  = scanner_mode;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure display

switch scanner_mode
    case 0
        screenmode      = 0;                % 0 = window / 1 = full screen %%%% CHANGE
    case {1,2}
        screenmode      = 1;                % 0 = window / 1 = full screen %%%% CHANGE
    case 3
        screenmode      = 1;
        config_keyboard;
        config_io;
        handle = PsychRTBox('Open', [], [0]);
        t=GetSecs;
        address = hex2dec('B010');
        your_trigger_code = 3;
        outp(address, your_trigger_code);  wait2(20); outp(address,0);
end

%%%%%%%
screenres       = 3;                % 1 = 640 x 480 / 2 = 800 x 600 / 3 = 1024 x 768 /
fg_black        = [0 0 0];          % set foreground colour to black
bg_white        = [1 1 1];          % set background colour to white
ft_name         = 'Arial';          % Font
ft_size         = 25;               % size of font
n_buffers       = 60;               % # offscreen buffers
n_bits          = 0;                % # of bits per pixel: 0 = selects max. possible

switch screenres
    case 1
        Resolution.screenWidth = 640;
        Resolution.screenHeight = 480;
    case 2
        Resolution.screenWidth = 800;
        Resolution.screenHeight = 600;
    case 3
        Resolution.screenWidth = 1024;
        Resolution.screenHeight = 768;
    case 4
        Resolution.screenWidth = 1152;
        Resolution.screenHeight = 864;
    case 5
        Resolution.screenWidth = 1280;
        Resolution.screenHeight = 1024;
    case 6
        Resolution.screenWidth = 1600;
        Resolution.screenHeight = 1200;
    otherwise
        error('Resolution not supported');
end
spriteWidth = Resolution.screenWidth/3.85;
spriteHeight = Resolution.screenHeight/3.2;
spriteWidthv = 664/2.5;
spriteHeightv = 600/2.5;
config_display(screenmode, screenres, fg_black, bg_white, ft_name, ft_size, n_buffers, n_bits);
sprWidth = Resolution.screenWidth;
sprHeight = Resolution.screenHeight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%configure keyboard (qlength (max. number of key events recorded between each keyboard read), resolution, mode)
switch scanner_mode
    case 0
        config_keyboard (5,1,'nonexclusive');
    case {1,2}
        config_keyboard (5,1,'nonexclusive');
        %port = 4;
        
        %config_serial ( port , 19200);
        %config_serial ( port , 9600);
    case 3
        [ ~, lkeyRTB ] = PsychRTBox('GetSecs'); % clean buffer
end

switch scanner_mode
    case 0 %behaviour
        if SOC.mode_key == 1
            SOC.key_blue    = 14; %N key to indicate blue
            SOC.key_green   = 13; %M key to indicate green
            SOC.key_info    = 15; %O
            
            SOC.key_right    = 13; %M key to increase wager by 1
            SOC.key_left   = 14; %N key to decrease wager by 1
            SOC.key_wager   = 71; %SPACE key to enter wager
            
            SOC.key_choiceA = 14; %N key - Block-wise probe, random
            SOC.key_choiceB = 13; %M key - Block-wise probe, misleading
            SOC.key_choiceC = 15; %O key - Block-wise probe, helpful
            SOC.key_Escape  = 52; %Escape
            
        else
            SOC.key_blue    = 13; %M key to indicate blue
            SOC.key_green   = 14; %N key to indicate green
            SOC.key_info    = 15; %O
            SOC.key_right    = 13; %M key to increase wager by 1
            SOC.key_left   = 14; %N key to decrease wager by 1
            SOC.key_choiceA = 14; %N key - Block-wise probe, random
            SOC.key_choiceB = 13; %M key - Block-wise probe, misleading
            SOC.key_choiceC = 15; %O key - Block-wise probe, helpful
            SOC.key_Escape  = 52; %Escape
            
            SOC.key_wager   = 71; %SPACE key to enter wager
        end
        
    case {1,2} %scanner
        if SOC.mode_key == 1
            SOC.key_blue     = 18; %blue is red key
            SOC.key_green   = 25; %green is yellow key
            SOC.key_info   = 7;
            
            SOC.key_right    = 25; %yellow key to increase wager by 1
            SOC.key_left   = 18; %red key to decrease wager by 1
            SOC.key_wager   = 2; %blue key to enter wager
            SOC.key_trigger = 20;
            SOC.key_Escape  = 71; %Escape
        else
            SOC.key_green   = 18; %green is red key
            SOC.key_blue     = 25; %blue is yellow key
            SOC.key_info   = 7;
            
            SOC.key_right    = 25; %yellow key to increase wager by 1
            SOC.key_left   = 18; %red key to decrease wager by 1
            SOC.key_wager   = 2; %blue key to enter wager
            SOC.key_trigger = 20;
            SOC.key_Escape  = 71; %Escape
            
        end
        
        SOC.key_choiceA = 18; %Block-wise probe, helpful
        SOC.key_choiceB = 2; %Block-wise probe, misleading
        SOC.key_choiceC = 25; %Block-wise probe, random
        
        
        
        
end

complete=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure logfile
config_log; %('subject_sl_fix_log');

% SL behavioural experiment consists of 9 blocks. Each block contains approximately 24 trials trials, each trial is defined through:
% 1. fixation cross, inter-trial interval
% 2. video 2000ms
% 3. button press with time pressure, declining bars, 6000ms
% 4. wager bar,
% 5. visual outcome, 1000ms


%Set times and intervals for experiment - CHECK TO SEE IF CHANGES NEEDED
SOC.Times.Initial_Int    = 2500;
SOC.Times.Dur_Stim       = 2000;    % duration of the video
SOC.Times.Dur_Wager      = 6000;   % duration of wager bar
SOC.Times.Dur_Outcome    = 1000;    % duration of the outcome
SOC.Times.Instruction    = 5000;    % duration of the instruction screen
SOC.Times.PractITI       = 1900;
SOC.Times.Dur_Score      = 1000; % duration of cummulative score screen
SOC.Times.Probe          = 9000;    % duration of the block-wise behavioural probe/rating
SOC.Times.EmotionalRating= 3000;
SOC.Times.Dur_TargetStim = 1000;    % duration of the target

SOC.exp_data_columns = {'block_number','trial_number','iti','type_video','when_advice','probe',...
    'type_key_press','key_press','time_response','reaction_time','emotion_rating',...
    'outcome','target_duration', 'correctness','score','rt_wager', 'wager'};

% define the trials
% config_data(file);
% input textfile containing the investments, paybacks and ITIs

% numbers for adjustment training
numbers = [0 40 80 120 160 200 240 280 320 360];

% colours for wager bar
col_line = [1 0 0]; % red

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Instructions
% start cogent
start_cogent;

% Fixation Crosses

switch language_inst
    case 1
        % load fixation points
        loadpict('fix_b.bmp',1);        % black fixation point; indicates end/start of trial
        cgloadbmp(16,'fix_b.bmp'); %  fixation cross
        
        cgfont('Arial', 130);
        preparestring('START',0,0,0);
        cgfont('Arial', 32);
        preparestring('Drücken Sie eine beliebige Taste, um die Instruktion zu starten.',0,0,-100);
        
        % display instruction for practice
        cgfont('Arial', 64);
        preparestring('Übung',3,0,250);
        cgfont('Arial', 24);
        preparestring('Bitte sagen Sie vorher, welche Karte (Blau oder Grün)',3,0,180);
        preparestring('gewählt wird.',3,0,140);
        preparestring('Drücken Sie die linke Taste mit',3,-250,60);
        preparestring('dem rechten Zeigefinger, falls Sie',3,-250,20);
        preparestring ('"BLAU" vorhersagen.',3,-250,-20);   % blue=dominant finger
        preparestring('Drücken Sie die rechte Taste mit',3,250,60);
        preparestring('dem rechten Ringfinger, falls Sie',3,250,20);
        preparestring('"GRÜN" vorhersagen.',3,250,-20);      % green=middle finger
        preparestring('Antworten Sie so schnell und so fehlerfrei wie möglich.',3,0,-80);
        preparestring('- Fixieren Sie Ihren Blick stets auf das zentrale Kreuz. -',3,0,-120);
        cgfont('Arial', 40);
        preparestring('+',3,0,0);
        
        
        % Instruction for the task
        cgfont('Arial', 64);
        preparestring('Entscheidungsaufgabe 1',7,0,250);
        cgfont('Arial', 24);
        preparestring('Bitte sagen Sie vorher, welche Karte (Blau oder Grün)',7,0,180);
        preparestring('gewählt wird.',7,0,140);
        preparestring('Drücken Sie die linke Taste mit',7,-250,60);
        preparestring('dem rechten Zeigefinger, falls Sie',7,-250,20);
        preparestring ('"BLAU" vorhersagen.',7,-250,-20);   % blue=dominant finger
        preparestring('Drücken Sie die rechte Taste mit',7,250,60);
        preparestring('dem rechten Ringfinger, falls Sie',7,250,20);
        preparestring('"GRÜN" vorhersagen.',7,250,-20);      % green=middle finger
        preparestring('Antworten Sie so schnell und so fehlerfrei wie möglich.',7,0,-80);
        preparestring('- Fixieren Sie Ihren Blick stets auf das zentrale Kreuz. -',7,0,-120);
        cgfont('Arial', 40);
        preparestring('+',7,0,0);
        
        % buffer 4 (instructions for the task)
        cgfont('Arial', 64);
        preparestring('Entscheidungsaufgabe 2',4,0,250);
        cgfont('Arial', 32);
        preparestring('Bitte sagen Sie vorher, wieviel Punkte',4,0,180);
        preparestring('Sie bereit sind, um zu verlieren/gewinnen.',4,0,140);
        preparestring('Mit der rechten Taste verschieben Sie den Balken rechts,',4,0,80);
        preparestring('mit der linken Taste verschieben Sie ihn links.',4,0,40);
        
        preparestring('Mit der mittleren Taste treffen Sie Ihre Auswahl.',4,0,-230);
        preparestring('- Fixieren Sie Ihren Blick stets auf das zentrale Kreuz. -',4,0,-270);
        cgfont('Arial', 40);
        preparestring('+',4,0,0);
        
        
        cgfont('Arial', 48);
        preparestring('Entscheidungsaufgabe 1',8,0,250);
        cgfont('Arial', 24);
        preparestring('Bitte sagen Sie vorher, welche Karte (Blau oder Grün)',8,0,180);
        preparestring('gewählt wird.',8,0,140);
        preparestring('Drücken Sie die linke Taste mit',8,-250,60);
        preparestring('dem rechten Zeigefinger, falls Sie',8,-250,20);
        preparestring ('"GRÜN" vorhersagen.',8,-250,-20);   %% green=dominant finger
        preparestring('Drücken Sie die rechte Taste mit',8,250,60);
        preparestring('dem rechten Ringfinger, falls Sie',8,250,20);
        preparestring('"BLAU" vorhersagen.',8,250,-20);      % blue=middle finger
        preparestring('Antworten Sie so schnell und so fehlerfrei wie möglich.',8,0,-80);
        preparestring('- Fixieren Sie Ihren Blick stets auf das zentrale Kreuz. -',8,0,-120);
        cgfont('Arial', 40);
        preparestring('+',8,0,0);
        preparestring('Bitte warten, gleich geht es los ... ',6);
        preparestring('ENDE',15); %end of the experiment
    case 2
        cgfont('Arial', 40);
        preparestring('+',1,0,0);
        cgfont('Arial', 40);
        preparestring('+',16,0,0);
        
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Target Images
% prepare visual stimuli (2) - 9 blue card; 10 green card
cgloadlib(); % load all needed libraries, every other cogent call is executed faster, as it doesn't have to load all libraries
cgloadbmp(9,'blue_card.bmp',spriteWidth,spriteHeight); % the last two numbers denote the resolution
cgloadbmp(10,'green_card.bmp',spriteWidth,spriteHeight);
cgloadbmp(17,'wager_bar.bmp');
cgmakesprite(65,sprWidth,sprHeight); % total wager
cgmakesprite(66,sprWidth,sprHeight); % adjustment
cgmakesprite(68,sprWidth,sprHeight); % payback screen



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Instructions: Evaluation of the Advice

switch language_inst
    case 1
      % behavioural probe: first time displayed
        cgfont('Arial', 35);
        
        preparestring('Was denken Sie, wie die Ratschläge,',2,0,120);
        preparestring('die Sie gleich erhalten, sein werden?',2,0,80);
        preparestring('Bitte wählen Sie eine der folgenden 3 Optionen,',2,0,40);
        preparestring('indem Sie die korrespondierende Taste drücken:',2,0,0);
        
        cgfont('Arial', 32);
        preparestring('Mittelfinger: zufällig',2,-115,-50);
        preparestring('Zeigefinger: hilfreich',2,-110,-90);
        preparestring('Ringfinger: irreführend',2,-95,-130);
        
        % behavioural probe
        cgfont('Arial', 35);
        preparestring('Wie empfinden Sie die Ratschläge, die Sie gerade erhalten?',5,0,120);
        preparestring('Bitte wählen Sie eine der folgenden 3 Optionen,',5,0,80);
        preparestring('indem Sie die korrespondierende Taste drücken:',5,0,40);
        
        cgfont('Arial', 32);
        preparestring('Mittelfinger: zufällig',5,-115,-50);
        preparestring('Zeigefinger: hilfreich',5,-110,-90);
        preparestring('Ringfinger: irreführend',5,-95,-130);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% instructions for wager bar
    case 2
        % behavioural probe: first time displayed
        
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set number of blocks and trials


SOC.nr_blocksPerSession  = [1 4] ;

SOC.nr_sessions          = length(SOC.nr_blocksPerSession);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Go through all sessions
SOC.Session(exp_task).when_session = datestr(now,30);

disp(' ');
disp(['SESSION ', num2str(exp_task), ' OUT OF ', num2str(SOC.nr_sessions)]); %length(SOC.nr_blocksPerSession)
disp('-----------------------------------------');

% Initialize counters
currentBlockIndex   = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define the codes and the probabilities from file
switch exp_task
    case 1 % practice
        % Inputlist fixed cues, targets, ITIs, and blocks
        SOC.Inputlist_S = 'Task_volatility_Practice.txt';
        [SOC.Block_codes,SOC.ITI_codes,SOC.Video_codes,SOC.displaystim,SOC.Outcome_codes,SOC.displaytarget] = textread(SOC.Inputlist_S, '%d%d%d%s%d%s');
        SOC.param(exp_task).block_length=3; % 1 block of 3 trials
        %end
    case 2 % main
        switch run
            case {2,4,6,8}
                
                % Inputlist fixed cues, targets, ITIs, and blocks
                SOC.Inputlist_S = 'Task_volatility_fMRIb.txt';
                [SOC.Block_codes,SOC.ITI_codes,SOC.Video_codes,SOC.displaystim,SOC.Outcome_codes,SOC.displaytarget] = textread(SOC.Inputlist_S, '%d%d%d%s%d%s');
                SOC.param(exp_task).block_length = [25 25 15 25]; %specify the total number of trials in the 3 blocks
        end
        %% START presentation: Practice then Task
        switch exp_task
            case 1 % Practice
                if complete == 0
                    drawpict(0); %START
                end
                
                switch scanner_mode
                    case 0
                        waitkeydown(inf);
                    case {1,2} % fMRI Practice
                        waitkeydown(inf);%convert to usb
                    case 3
                        waitButtonPress();
                end
                if SOC.mode_key == 1
                    drawpict(3); % Practice with blue=dominant finger
                else
                    drawpict(4); % Practice with green=dominant finger
                end
                switch scanner_mode
                    case 0
                        waitkeydown(inf);
                        % clear keyboard buffer to avoid garbage from previous keypresses
                        clearkeys;  % cogent will store all keypresses from now on until 'readkeys' below
                    case 1
                        wait2(SOC.Times.Instruction);
                        drawpict(6); % wait for scanner trigger
                        [k,t]=waitkeydown(inf,20);
                        SOC.param(exp_task).scanstart = t(1);
                        logstring(['response ' num2str(k(1)) ', at ' num2str(t(1)) ', scan start']);
                    case 2
                        wait2(SOC.Times.Instruction);
                        drawpict(6); % wait for scanner trigger
                        waitkeydown(inf,20);
                        [k,t]=waitkeydown(inf,20);
                        SOC.param(exp_task).scanstart = t(1);
                        logstring(['response ' num2str(k(1)) ', at ' num2str(t(1)) ', scan start']);
                    case 3
                        waitButtonPress();
                end
                
            case 2 % Main Task
                % display stimuli
                if complete == 0
                    drawpict(0);  % START
                end
                switch scanner_mode
                    case 0
                        waitkeydown(inf);
                        % clear keyboard buffer to avoid garbage from previous keypresses
                        clearkeys;  % cogent will store all keypresses from now on until 'readkeys' below
                    case 1
                        wait2(SOC.Times.Instruction);
                        drawpict(6); % wait for scanner trigger
                        [k,t]=waitkeydown(inf,20);
                        SOC.param(exp_task).scanstart = t(1);
                        logstring(['response ' num2str(k(1)) ', at ' num2str(t(1)) ', scan start']);
                    case 2
                        wait2(SOC.Times.Instruction);
                        drawpict(6); % wait for scanner trigger
                        waitkeydown(inf,20);
                        [k,t]=waitkeydown(inf,20);
                        SOC.param(exp_task).scanstart = t(1);
                        logstring(['response ' num2str(k(1)) ', at ' num2str(t(1)) ', scan start']);
                    case 3
                        waitButtonPress();
                end
                %%%%% Instruction
                if SOC.mode_key == 1
                    drawpict(7); % Task with blue=dominant finger
                else
                    drawpict(8); % Task with green=dominant finger
                end
                wait2(SOC.Times.Instruction); %~10000
                
                %%%%% Instruction 2
                
                cgflip(0,0,0);
                cgdrawsprite(4,0,0); % Practice with blue=dominant finger
                cgdrawsprite(17,0,-80);
                cgflip;
                
                wait2(13000); %~10000
        end
        SOC.when_start = datestr(now,30);
        white = [1 1 1];
        width_constant=7.2; % constant with which the rect increases after each trial;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Go through all blocks
        for block = 1 : SOC.nr_blocksPerSession(exp_task) % given in script
            currentBlockIndex = currentBlockIndex + (SOC.param(exp_task).block_length(block));
            SOC.Block_codes(currentBlockIndex); % block index from txt file
            %diplay for the experimenter
            disp(' ');
            disp(['BLOCK ',num2str(block), ' OUT OF ', num2str(SOC.nr_blocksPerSession(2))]);
            disp(['SOC.param(exp_task).block_length = ',num2str(SOC.param(exp_task).block_length(block))]);
            
            % -------------------------------------------------------------
            % Display first multiple choice question
            if block ==1
                % display behavioural probe
                drawpict(2);  % Behavioural Probe
                switch scanner_mode
                    case 0
                        wait2(SOC.Times.Probe);
                        readkeys;
                        [key,time] = lastkeydown;
                        if isempty(key)    % if there was no key response record dummy values
                            logstring('No response ...');   % cogent log
                        else             % if there was a key response record data
                            disp(['advice intentionality ', num2str(key)]);
                            disp(['time of decision ', num2str(time)]);
                        end
                        % store probe response
                        if key == SOC.key_choiceA
                            subj_selection =3;
                        elseif key == SOC.key_choiceB
                            subj_selection =2;
                        elseif key == SOC.key_choiceC
                            subj_selection = 1;
                        else subj_selection = 0;
                        end
                        SOC.BehaviourProbe1(block)=subj_selection;
                        clearkeys;
                    case {1,2}
                        wait2(SOC.Times.Probe);
                        readkeys;
                        [key,time] = lastkeydown;
                        if isempty(key)    % if there was no key response record dummy values
                            logstring('No response ...');   % cogent log
                        else             % if there was a key response record data
                            disp(['advice intentionality ', num2str(key)]);
                            disp(['time of decision ', num2str(time)]);
                        end
                        % store probe response
                        if key == SOC.key_choiceA
                            subj_selection =1;
                        elseif key == SOC.key_choiceB
                            subj_selection =2;
                        elseif key == SOC.key_choiceC
                            subj_selection = 3;
                        else subj_selection = 0;
                        end
                        SOC.BehaviourProbe1(block)=subj_selection;
                    case 3
                        clear key;
                        clear time;
                        wait2(SOC.Times.Probe);
                        [time, key] = getFirstKey();
                        
                        % store probe response
                        if key == SOC.key_choiceA
                            subj_selection =1;
                        elseif key == SOC.key_choiceB
                            subj_selection =2;
                        elseif key == SOC.key_choiceC
                            subj_selection = 3;
                        else subj_selection = 0;
                        end
                        SOC.BehaviourProbe1(block)=subj_selection;
                end
            end
            cgflip(0,0,0);
            cgflip(0,0,0);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Go through all trials
            nBlockArray = SOC.param(exp_task).block_length;
            if block == 1
                startTrialBlock = 1;
            else
                startTrialBlock = 1 + sum(nBlockArray(1:block-1));
            end
            for trial = startTrialBlock + (0:nBlockArray(block)-1) %number of trials provided in script
                disp(['Trial ',num2str(trial), ' out of ', num2str(((block-1)*SOC.param(exp_task).block_length(block))+(SOC.param(exp_task).block_length(block)))]);
                SOC.ITI_codes(trial); %length of intertrial interval from txt file
                if scanner_mode == 3;
                    outp(address, SOC.ITI_codes(trial));  wait2(20); outp(address,0);
                end
                SOC.Times.Iti = SOC.ITI_codes(trial);
                % subject's initial score
                if trial ==1
                    if mod(run,2) == 1
                        SOC.cscore=0;
                        SOC.wager=0;
                    else
                        oldSOC = load(fullfile(pathname,[subject 'perblock_IOIO_run' int2str(run-1)]), 'SOC');
                        SOC.cscore = oldSOC.SOC.cscore;
                        SOC.wager=0;
                    end
                end
                %probe
                if trial==14 || trial ==49 || trial==73 || trial == 110 %probe is presented in a jitter fashion
                    drawpict(5);  % Behavioural Probe
                    switch scanner_mode
                        case 0
                            wait2(SOC.Times.Probe);
                            readkeys;
                            [key,time] = lastkeydown;
                            if isempty(key)    % if there was no key response record dummy values
                                logstring('No response ...');   % cogent log
                            else             % if there was a key response record data
                                disp(['advice intentionality ', num2str(key)]);
                                disp(['time of decision ', num2str(time)]);
                            end
                            % store probe response
                            if key == SOC.key_choiceA
                                subj_selection =3; %Helpful
                            elseif key == SOC.key_choiceB
                                subj_selection =2; %Misleading
                            elseif key == SOC.key_choiceC
                                subj_selection = 1; %Random
                            else subj_selection = 0;
                            end
                            clearkeys;
                        case {1,2}
                            wait2(SOC.Times.Probe);
                            readkeys;
                            [key,time] = lastkeydown;  % this command outputs all keydown events for the specified key
                            if isempty(key)    % if there was no key response record dummy values
                                logstring('No response ...');   % cogent log
                            else             % if there was a key response record data
                                disp(['advice intentionality ', num2str(key)]);
                                disp(['time of decision ', num2str(time)]);
                            end
                            % store probe response
                            if key == SOC.key_choiceA
                                subj_selection =1; % helpful
                            elseif key == SOC.key_choiceB
                                subj_selection =2; % misleading
                            elseif key == SOC.key_choiceC
                                subj_selection = 3; % random
                            else subj_selection = 0;
                            end
                        case 3
                            clear key;
                            clear time;
                            wait2(SOC.Times.Probe);
                            [time, key] = getFirstKey();
                            % store probe response
                            if key == SOC.key_choiceA
                                subj_selection =1; %helpful
                            elseif key == SOC.key_choiceB
                                subj_selection =2; %misleading
                            elseif key == SOC.key_choiceC
                                subj_selection = 3; %random
                            else subj_selection = 0;
                            end
                            SOC.BehaviourProbe1(block)=subj_selection;
                    end
                    cgflip(0,0,0);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%Load Videos
                switch run
                    case 2 % Adviser 1
                        %prepare videos
                        cgopenmovie(41,'80_1_4_blue.avi');  % pick blue
                        cgopenmovie(42,'80_1_5_green.avi');
                        cgopenmovie(43,'80_1_6_blue.avi');  % pick blue
                        cgopenmovie(44,'80_1_7_green.avi');
                        
                        cgopenmovie(45,'80_1_9_blue.avi');  % pick blue
                        cgopenmovie(46,'80_1_15_green.avi');
                        cgopenmovie(47,'80_1_13_blue.avi');  % pick blue
                        cgopenmovie(48,'80_1_22_green.avi');
                        
                        cgopenmovie(49,'80_1_16_blue.avi');  % pick blue
                        cgopenmovie(50,'80_1_31_green.avi');
                        cgopenmovie(51,'80_1_20_blue.avi');  % pick blue
                        cgopenmovie(52,'80_1_33_green.avi');
                        
                        cgopenmovie(53,'80_1_23_blue.avi');  % pick blue
                        cgopenmovie(54,'80_1_34_green.avi');
                        cgopenmovie(55,'80_1_24_blue.avi');  % pick blue
                        cgopenmovie(56,'80_1_37_green.avi');
                        
                        cgopenmovie(57,'80_1_26_blue.avi');  % pick blue
                        cgopenmovie(58,'80_1_17_green.avi');
                        cgopenmovie(59,'80_1_28_blue.avi');  % pick blue
                        cgopenmovie(60,'80_1_27_green.avi');
                        
                        cgopenmovie(61,'80_1_30_blue.avi');  % pick blue
                        cgopenmovie(62,'80_1_29_green.avi');
                        cgopenmovie(63,'80_1_35_blue.avi');  % pick blue
                        cgopenmovie(64,'80_1_11_green.avi');
                        
                    case 4 % Male Backup Adviser
                        cgopenmovie(41,'adv3_blue_1.avi');  % pick blue
                        cgopenmovie(42,'adv3_green_1.avi');
                        cgopenmovie(43,'adv3_blue_2.avi');  % pick blue
                        cgopenmovie(44,'adv3_green_2.avi');
                        
                        cgopenmovie(45,'adv3_blue_3.avi');  % pick blue
                        cgopenmovie(46,'adv3_green_3.avi');
                        cgopenmovie(47,'adv3_blue_4.avi');  % pick blue
                        cgopenmovie(48,'adv3_green_4.avi');
                        
                        cgopenmovie(49,'adv3_blue_5.avi');  % pick blue
                        cgopenmovie(50,'adv3_green_5.avi');
                        cgopenmovie(51,'adv3_blue_6.avi');  % pick blue
                        cgopenmovie(52,'adv3_green_6.avi');
                        
                        cgopenmovie(53,'adv3_blue_7.avi');  % pick blue
                        cgopenmovie(54,'adv3_green_7.avi');
                        cgopenmovie(55,'adv3_blue_8.avi');  % pick blue
                        cgopenmovie(56,'adv3_green_8.avi');
                        
                        cgopenmovie(57,'adv3_blue_9.avi');  % pick blue
                        cgopenmovie(58,'adv3_green_9.avi');
                        cgopenmovie(59,'adv3_blue_10.avi');  % pick blue
                        cgopenmovie(60,'adv3_green_10.avi');
                        
                        cgopenmovie(61,'adv3_blue_11.avi');  % pick blue
                        cgopenmovie(62,'adv3_green_11.avi');
                        cgopenmovie(63,'adv3_blue_12.avi');  % pick blue
                        cgopenmovie(64,'adv3_green_12.avi');
                        
                    case 6 % Female Adviser
                        cgopenmovie(41,'mod2_female_80_1_4_blue.avi');  % pick blue
                        cgopenmovie(42,'mod2_female_80_1_5_green.avi');
                        cgopenmovie(43,'mod2_female_80_1_6_blue.avi');  % pick blue
                        cgopenmovie(44,'mod2_female_80_1_7_green.avi');
                        
                        
                        cgopenmovie(45,'mod2_female_80_1_9_blue.avi');  % pick blue
                        cgopenmovie(46,'mod2_female_80_1_15_green.avi');
                        cgopenmovie(47,'mod2_female_80_1_26_blue.avi');  % pick blue
                        cgopenmovie(48,'mod2_female_80_1_22_green.avi');
                        
                        
                        cgopenmovie(49,'mod2_female_80_1_16_blue.avi');  % pick blue
                        cgopenmovie(50,'mod2_female_80_1_31_green.avi');
                        cgopenmovie(51,'mod2_female_80_1_20_blue.avi');  % pick blue
                        cgopenmovie(52,'mod2_female_80_1_33_green.avi');
                        
                        
                        cgopenmovie(53,'mod2_female_80_1_23_blue.avi');  % pick blue
                        cgopenmovie(54,'mod2_female_80_1_34_green.avi');
                        cgopenmovie(55,'mod2_female_80_1_26_blue.avi');  % pick blue
                        cgopenmovie(56,'mod2_female_80_1_37_green.avi');
                        
                        
                        cgopenmovie(57,'mod2_female_80_1_26_blue.avi');  % pick blue
                        cgopenmovie(58,'mod2_female_80_1_17_green.avi');
                        cgopenmovie(59,'mod2_female_80_1_28_blue.avi');  % pick blue
                        cgopenmovie(60,'mod2_female_80_1_27_green.avi');
                        
                        
                        cgopenmovie(61,'mod2_female_80_1_30_blue.avi');  % pick blue
                        cgopenmovie(62,'mod2_female_80_1_29_green.avi');
                        cgopenmovie(63,'mod2_female_80_1_26_blue.avi');  % pick blue
                        cgopenmovie(64,'mod2_female_80_1_11_green.avi');
                        
                    case 8 % Female Backup Adviser
                        cgopenmovie(41,'f2_80_1_4_blue.avi');  % pick blue
                        cgopenmovie(42,'f2_80_1_5_green.avi');
                        cgopenmovie(43,'f2_80_1_6_blue.avi');  % pick blue
                        cgopenmovie(44,'f2_80_1_7_green.avi');
                        
                        
                        cgopenmovie(45,'f2_80_1_9_blue.avi');  % pick blue
                        cgopenmovie(46,'f2_80_1_15_green.avi');
                        cgopenmovie(47,'f2_80_1_13_blue.avi');  % pick blue
                        cgopenmovie(48,'f2_80_1_22_green.avi');
                        
                        
                        cgopenmovie(49,'f2_80_1_16_blue.avi');  % pick blue
                        cgopenmovie(50,'f2_80_1_31_green.avi');
                        cgopenmovie(51,'f2_80_1_20_blue.avi');  % pick blue
                        cgopenmovie(52,'f2_80_1_33_green.avi');
                        
                        
                        cgopenmovie(53,'f2_80_1_23_blue.avi');  % pick blue
                        cgopenmovie(54,'f2_80_1_34_green.avi');
                        cgopenmovie(55,'f2_80_1_24_blue.avi');  % pick blue
                        cgopenmovie(56,'f2_80_1_37_green.avi');
                        
                        
                        cgopenmovie(57,'f2_80_1_26_blue.avi');  % pick blue
                        cgopenmovie(58,'f2_80_1_17_green.avi');
                        cgopenmovie(59,'f2_80_1_28_blue.avi');  % pick blue
                        cgopenmovie(60,'f2_80_1_27_green.avi');
                        
                        
                        cgopenmovie(61,'f2_80_1_30_blue.avi');  % pick blue
                        cgopenmovie(62,'f2_80_1_29_green.avi');
                        cgopenmovie(63,'f2_80_1_35_blue.avi');  % pick blue
                        cgopenmovie(64,'f2_80_1_11_green.avi');
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% start with fixation
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cgflip(0,0,0);
                cgdrawsprite(16,0,0);
                mycolour=white;
                cgflip;
                wait2(SOC.Times.Iti);
                disp(['ITI ',num2str(SOC.Times.Iti)]); % display ITI for experimenter
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                rect_height_feedback=20;
                rect_width_feedback=30;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% present video
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% present video in the middle
                
                time_present_c=cgflip;
                if scanner_mode == 3;
                    outp(address, SOC.Video_codes(trial));  wait2(20); outp(address,0);
                end
                cgplaymovie(SOC.Video_codes(trial),0,130,spriteWidthv,spriteHeightv);cgshutmovie(SOC.Video_codes(trial)); %play and shut movie
                typeVideo=SOC.Video_codes(trial);
                wait2(SOC.Times.Dur_Stim);
                disp([SOC.displaystim(trial),num2str(trial),' which is image no ',num2str(SOC.Video_codes(trial))]);
                disp(['time at which the stimulus was presented: ', num2str(time_present_c)]); %check how long this was displayed
                cgflip(0,0,0);
                
                
                switch scanner_mode
                    case 0
                        clearkeys;
                    case {1,2}
                        clearkeys;
                    case 3
                        clear key;
                        clear a;
                        clear t;
                        clear k;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% Decision Window: declining bars
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cgdrawsprite(16,0,0);                
                time_present_decision=cgflip;
                if scanner_mode == 3;
                    init_time = GetSecs;
                end
                disp(['time at which the decision window was presented: ', num2str(time_present_decision)]);
                %%% CONSTANTS %%%
                % number of refresh time steps and duration in seconds:
                N_STEPS = 10;                      % the higher this, the smoother
                N_DURATION = 2;                     % seconds
                DELTA_T = N_DURATION/N_STEPS;       % seconds for pause() command
                % coordinates of sprite center:
                SPRITE_POSITION_LEFT = [-107, 0];    % left bar
                SPRITE_POSITION_RIGHT = [80, 0];    % right bar
                % number of the sprite for the left and right rectangle:
                n_rect_left = 2;
                n_rect_right = 3;
                % rectangle colors:
                BLUE = [0 0 1];
                GREEN = [0 1 0];
                % rectangle width and height. these are equal to the sprite width and
                % height (the sprite is not bigger than necessary):
                rect_height = 200;
                rect_width = 50;
                % initialize geometry:
                rect_y_center = 0;                              % start value
                rect_x_center = rect_width/2;
                rect_delta_height = rect_height / N_STEPS;
                rect_current_height = rect_height;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% SPRITES %%%
                % create sprites:
                if SOC.mode_key == 1
                    cgmakesprite(n_rect_left, rect_width, rect_height);
                    cgmakesprite(n_rect_right, rect_width, rect_height);
                    cgpencol(mycolour);
                    %cgrect(rect_centerx_prog,rect_centery_prog,rect_width_prog,rect_height_prog);
                    %%% LOOP: depends on response mode
                    while(rect_current_height >= rect_height_feedback)
                        cgsetsprite(n_rect_left);
                        %%% black rectangle to overdraw old left rectangle:
                        cgpencol(0, 0, 0);
                        cgrect(rect_x_center, 0, rect_width, rect_height);
                        %%% left (blue) rectangle:
                        cgpencol(BLUE);
                        cgrect(rect_x_center, rect_y_center, rect_width, rect_current_height);
                        cgsetsprite(0);
                        cgdrawsprite(16,0,0);
                        cgdrawsprite(n_rect_left, SPRITE_POSITION_LEFT(1), SPRITE_POSITION_LEFT(2));
                        cgsetsprite(n_rect_right);
                        %%% black rectangle to overdraw old right rectangle:
                        cgpencol(0, 0, 0);
                        cgrect(rect_x_center, 0, rect_width, rect_height);
                        %%% right (green) rectangle:
                        cgpencol(GREEN);
                        cgrect(rect_x_center, rect_y_center, rect_width, rect_current_height);
                        cgsetsprite(0);
                        cgdrawsprite(n_rect_right, SPRITE_POSITION_RIGHT(1), SPRITE_POSITION_RIGHT(2));
                        cgpencol(mycolour);                                                                                                                                   1031;
                        %cgrect(rect_centerx_prog,rect_centery_prog,rect_width_prog,rect_height_prog);
                        % clear background
                        cgflip(0, 0, 0);
                        % declining the bars
                        rect_current_height = rect_current_height - rect_delta_height;
                        rect_y_center = -rect_height/2 + rect_current_height/2;
                        pause(DELTA_T);
                    end
                    
                    switch scanner_mode
                        case 0
                            readkeys;    % this command retrieves all keyboard events
                            [k,t,n] = getkeydown([SOC.key_blue SOC.key_green SOC.key_Escape]);   % this command outputs all keydown events for the specified key
                            [i,z] = getkeydown([SOC.key_info]);
                        case {1,2}
                            readkeys;    % this command retrieves all keyboard events
                            [k,t,n] = getkeydown([SOC.key_blue SOC.key_green SOC.key_Escape]);   % this command outputs all keydown events for the specified key
                            [i,z] = getkeydown([SOC.key_info]);
                        case 3
                            readkeys;    % this command retrieves all keyboard events
                            [k,t,n] = getkeydown([SOC.key_blue SOC.key_green SOC.key_Escape]);   % this command outputs all keydown events for the specified key
                            [i,z] = getkeydown([SOC.key_info]);
                            [t, k, n, i, z] = getFirstKey();
                    end
                    %% Read all keyboard events
                    if isempty(k)    % if there was no key response record dummy values
                        t_press     = -99;  % no response
                        k_press     = -99;
                        t_reaction  = -99;
                        logstring('No response ...');   % cogent log
                        
                    else             % if there was a key response record data
                        t_press     = t(1);                                  % time of first key onset
                        k_press     = k(1);                                  % key code of first keypress, time_present_c is the time of the stimulus + cue
                        n_press     = n(1);
                        disp(['time of decision key press ', num2str(t_press/1000)]);
                        disp(['type of decision ', num2str(k_press)]);
                        
                        if scanner_mode == 3;
                            t_reaction  = (t(1) - init_time);
                        else
                            t_reaction  = (t(1)/1000 - time_present_decision)*1000;
                        end
                    
                        % display feedback
                        cgdrawsprite(16,0,0);
                        if k_press == SOC.key_blue
                            cgpencol(BLUE);
                            cgrect(-95, (-1*rect_height/2+10),rect_x_center, rect_height_feedback);
                        elseif k_press == SOC.key_green
                            cgpencol(GREEN);
                            cgrect(92, (-1*rect_height/2+10),rect_x_center, rect_height_feedback);
                        else
                            key_press = -99;
                        end
                        cgflip;
                        wait2(SOC.Times.Dur_TargetStim);
                    end
                    else
                        cgmakesprite(n_rect_left, rect_width, rect_height);
                        cgmakesprite(n_rect_right, rect_width, rect_height);
                        cgpencol(mycolour);
                        %cgrect(rect_centerx_prog,rect_centery_prog,rect_width_prog,rect_height_prog);
                        %%% LOOP: depends on response mode
                        while(rect_current_height >= rect_height_feedback)
                            cgsetsprite(n_rect_left);
                            %%% black rectangle to overdraw old left rectangle:
                            cgpencol(0, 0, 0);
                            cgrect(rect_x_center, 0, rect_width, rect_height);
                            %%% left (green) rectangle:
                            cgpencol(GREEN);
                            cgrect(rect_x_center, rect_y_center, rect_width, rect_current_height);
                            cgsetsprite(0);
                            cgdrawsprite(16,0,0);
                            cgdrawsprite(n_rect_left, SPRITE_POSITION_LEFT(1), SPRITE_POSITION_LEFT(2));
                            cgsetsprite(n_rect_right);
                            %%% black rectangle to overdraw old right rectangle:
                            cgpencol(0, 0, 0);
                            cgrect(rect_x_center, 0, rect_width, rect_height);
                            %%% right (blue) rectangle:
                            cgpencol(BLUE);
                            cgrect(rect_x_center, rect_y_center, rect_width, rect_current_height);
                            cgsetsprite(0);
                            cgdrawsprite(n_rect_right, SPRITE_POSITION_RIGHT(1), SPRITE_POSITION_RIGHT(2));
                            cgpencol(mycolour);                                                                                                                                   1031
                            
                            cgflip(0, 0, 0);
                            % declining the bars
                            rect_current_height = rect_current_height - rect_delta_height;
                            rect_y_center = -rect_height/2 + rect_current_height/2;
                            pause(DELTA_T);
                        end
                        
                        %% Read all keyboard events
                        switch scanner_mode
                            case 0
                                readkeys;    % this command retrieves all keyboard events
                                [k,t,n] = getkeydown([SOC.key_blue SOC.key_green SOC.key_Escape]);   % this command outputs all keydown events for the specified key
                                [i,z] = getkeydown([SOC.key_info]);                                                              
                            case {1,2}
                                readkeys;    % this command retrieves all keyboard events
                                [k,t,n] = getkeydown([SOC.key_blue SOC.key_green SOC.key_Escape]);   % this command outputs all keydown events for the specified key
                                [i,z] = getkeydown([SOC.key_info]);
                            case 3
                                [t, k] = getFirstKey();
                                i = [];
                                z = [];
                                n = str2num(k);
                        end
 
                        %% Read all keyboard events
                        if isempty(k)    % if there was no key response record dummy values
                            t_press     = -99;  % no response
                            k_press     = -99;
                            t_reaction  = -99;
                            logstring('No response ...');   % cogent log
                            
                        else             % if there was a key response record data
                            t_press     = t(1);                                  % time of first key onset
                            k_press     = k(1);                                  % key code of first keypress, time_present_c is the time of the stimulus + cue
                            n_press     = n(1);
                            disp(['time of decision key press ', num2str(t_press/1000)]);
                            disp(['type of decision ', num2str(k_press)]);
                            if scanner_mode == 3;
                                t_reaction  = (t(1) - init_time);
                            else
                                t_reaction  = (t(1)/1000 - time_present_decision)*1000;
                            end
                            % Response Time= time_response-time_cue_presented
                            %e.g. t(1) instead of t in case subjects press multipe times.
                            % write out response values to cogent log and also command window
                            logstring(['response ' num2str(k_press) ', RT ' num2str(t_reaction)]);
                            % display feedback
                        cgdrawsprite(16,0,0);
                        if k_press == SOC.key_blue
                            cgpencol(BLUE);
                            cgrect(92, (-1*rect_height/2+10),rect_x_center, rect_height_feedback);
                        elseif k_press == SOC.key_green
                            cgpencol(GREEN);
                            cgrect(-95, (-1*rect_height/2+10),rect_x_center, rect_height_feedback);
                        else
                            key_press = -99;
                        end
                        cgflip;
                        wait2(SOC.Times.Dur_TargetStim);
                        end
                end          
                    %%% WAGER screen - take difference between maximum wait time and
                    %%% toc (for duation of the loop)
                    cgdrawsprite(16,0,0);
                    
                    
                    cgsetsprite(65);                     % sprite for showing only wager
                    
                    % box for investment
                    cgpencol(1,1,1);
                    cgrect(0,200,200,50);
                    cgsetsprite(0);
                    
                    cgsetsprite(66);                    % sprite for investment plus adjustment bar
                    cgdrawsprite(65,0,0);
                    
                    % draw the adjustment bar
                    cgpencol(1,1,1);
                    cgrect(0,-250,400,50);
                    cgtext('0',-220,-250);
                    cgtext('400',240,-250);
                    cgsetsprite(0);
                    
                    % box for investment
                    cgrect(0,200,200,50);
                    cgsetsprite(0);
                    
                    cgsetsprite(68);            % sprite for adjustment training
                    cgpencol(1,1,1);
                    
                    % draw the adjustment bar
                    cgpencol(1,1,1);
                    cgrect(-20,-250,360,50);%%test2%%
                    cgtext('1',-220,-250);
                    cgtext('10',200,-250);
                    cgsetsprite(0);
                    SOC.nr_trials = countdatarows;
                    
                    max = 360;
                    start = randi([0,9]) * 40;      % random starting point

                    cgdrawsprite(68,0,0);
                    cgpencol(0,0,0);
                    
                    % starting position of adjustment line
                    cgpenwid(5);
                    cgpencol(col_line);
                    cgdraw(start-400,-225,start-200,-275);
                    cgtext(num2str(start),start-200,-200);
                    cgflip(0,0,0);
                    tic;
                    
                    % loop for reading keys and adjusting bar
                    current = start;
                    done = 0;
                    done1 = 0;
                    while done1 == 0
                        readkeys;
                        [key, time] = lastkeydown;                       
                        if key ~= SOC.key_wager
                            if key == SOC.key_left %OR WAIT 6 SEC
                                move = -40;
                            elseif key == SOC.key_right
                                move = 40;
                            else
                                move = 0;
                            end
                            done = 0;
                        elseif key == SOC.key_wager %WAIT FOR DIFFERENCE BETWEEN 6 SEC GO
                            move = 0;
                            done = 1;
                            rt_wager=toc;
                            bid = current / 40 + 1;
                        else
                            move = 0;
                            done = 0;
                        end
                        
                        % check whether move is possible
                        if current + move >= 0 && current + move <= max
                            % update current line position, current prediction
                            current = current + move;
                        end
                        
                        % adjustment screen
                        cgdrawsprite(68,0,0);
                        cgpencol(0,0,0);
                        cgpenwid(5);
                        cgpencol(col_line);
                        cgdraw(current-200,-225,current-200,-275);
                        cgtext(num2str(current / 40 + 1),current-200,-200);
                        cgflip(0,0,0);
                        
                        if toc >= 6
                            rt_wager = -99;
                            done1 = 1;
                            
                        end
                        bid = current / 40 + 1;
                    end
                    
                    wager = bid;

                    
                    disp(['Time of Wager: ', num2str(rt_wager)]);
                    disp(['Wager Amount: ', num2str(wager)]);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %OUTCOME screen %change 16 to 1 or 2 based on
                    typeDisplayed= SOC.Outcome_codes(trial);
                    cgflip(0,0,0);
                    cgdrawsprite(SOC.Outcome_codes(trial),0,0);
                    time_present_t = cgflip;
                    wait2(SOC.Times.Dur_TargetStim);
              
                    
                    
                    % check for abort
                    if any( k==52 )                          % "are any of the key-codes recorded in k equal to 52 (escape key)?"
                        logstring('... aborted');            % write error to log
                        stop_cogent; clear all;              % if so, abort
                        return;                              % exit this program
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % store correctness of responses
                    switch typeDisplayed
                        case 9  % blue
                            if k_press == SOC.key_blue
                                correctness = 1; % correct response
                                key_press = 1;
                            elseif k_press == SOC.key_green
                                correctness = -1; % wrong response
                                key_press = 2;
                            else
                                correctness = -1; % miss
                                key_press = -99;
                            end
                        case 10  % green
                            if k_press == SOC.key_green
                                correctness = 1; % correct response
                                key_press = 2;
                            elseif k_press == SOC.key_blue
                                correctness = -1; % wrong response
                                key_press = 1;
                            else
                                correctness = -1; % miss
                                key_press = -99;
                            end
                    end
                    
                    %SOC.cscore
                    if trial ~= 1
                        cgflip(0,0,0);
                        %cgdrawsprite(16,0,0);
                        mycolour=white;
                        cgpencol(mycolour);
                        cgpencol(1,1,1);
                        cgfont('Arial', 120);
                        cgdrawsprite(-20,-250,50,50);
                        test = SOC.cscore + correctness * wager;
                        cgtext(num2str(test),0,0);          
                        % end
                        cgflip;
                        wait(SOC.Times.Dur_Score);
                    else
                        cgflip(0,0,0);
                        cgpencol(1,1,1);
                        cgfont('Arial', 120);
                        cgdrawsprite(-20,-250,360,100);
                        test = SOC.cscore;
  
                        cgtext(num2str(test),0,0);
                        
                        % end
                       
                        mycolour=white;
                        cgpencol(mycolour);
                        cgflip;
                        wait(SOC.Times.Dur_Score);
                        
                        
                    end
                    cgfont('Arial', 32);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %% Save data in the corresponding fields
                    SOC.Session(exp_task).exp_data(trial,1) = block;
                    SOC.Session(exp_task).exp_data(trial,2) = trial;
                    SOC.Session(exp_task).exp_data(trial,3) = SOC.Times.Iti;
                    SOC.Session(exp_task).exp_data(trial,4) = typeVideo;
                    SOC.Session(exp_task).exp_data(trial,5) = time_present_c; % time at which stimulus was presented
                    SOC.Session(exp_task).exp_data(trial,6) = subj_selection;  % adviser rating
                    SOC.Session(exp_task).exp_data(trial,7)=  k_press;        % type of key press
                    SOC.Session(exp_task).exp_data(trial,8) = key_press;      % ID of keypress
                    SOC.Session(exp_task).exp_data(trial,9) = t_press/1000;   % time at which response was given
                    SOC.Session(exp_task).exp_data(trial,10) = t_reaction;    % reaction time
                    SOC.Session(exp_task).exp_data(trial,11)= subj_selection; % emotion rating
                    SOC.Session(exp_task).exp_data(trial,12)= typeDisplayed;  % target: green or blue
                    SOC.Session(exp_task).exp_data(trial,13) = time_present_t;
                    SOC.Session(exp_task).exp_data(trial,14) = correctness;
                    SOC.Session(exp_task).exp_data(trial,15) = SOC.cscore;    % cumulative score
                    SOC.Session(exp_task).exp_data(trial,16) = rt_wager;
                    SOC.Session(exp_task).exp_data(trial,17) = wager;
                    SOC.Session(exp_task).exp_data(trial,18) = start; % random starting point of wager bar
                    
                    % calculate cumulative score %random selection of 5 trials
                    SOC.cscore = SOC.cscore + SOC.Session(exp_task).exp_data(trial,14) * SOC.Session(exp_task).exp_data(trial,17);
                    
                    disp(['Cumulative score: ', num2str(SOC.cscore)]);
                    
                    
                    %save save the whole structure to the subject's data file at the end of every trial loop
                    % this makes sure you do not lose data if the session is aborted or stops due to a technical problem
                    save(fullfile(pathname, [subject 'pertrial_IOIO_run' int2str(run) '.mat']),'SOC');
                    
                    readkeys; key = lastkeydown;
                    if key == 52;
                        cd('C:\trash');
                        stop_cogent;
                        PsychRTBox('Close', []);
                        return;
                    end;
                end %for (trial)%to know how much to pay subject
                if run == 2 || run == 4
                    if SOC.cscore>=380
                        payment=1;
                    elseif SOC.cscore>=500
                        payment=2;
                    else  payment=0;
                    end
                    display(['The subject has reached target number ', num2str(payment) '!']);
                    save(fullfile(pathname, [subject 'perblock_IOIO_run' int2str(run) '.mat']),'SOC');
                    
                end
            end %for (block)
            SOC.when_stop = datestr(now,30);
            save(fullfile(pathname, [subject 'perblock_IOIO_run' int2str(run) '.mat']),'SOC');
            
            % Randomly select a winning wager from the sample
            
            
            
            drawpict(15); %goodbye
            wait2(3000);
            
            
            
            % monitor key presses
            switch scanner_mode
                case 0
                    readkeys;    % this command retrieves all keyboard events
                    logkeys;
                case {1,2}
                    readkeys;    % this command retrieves all keyboard events
                    logkeys;
                    %readserialbytes(port);
                    %logserialbytes(port);
                case 3
                    PsychRTBox('Close', []);
            end
            stop_cogent;
            
        end
        
        
