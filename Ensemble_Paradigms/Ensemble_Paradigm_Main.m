%% This script is the main function for the group project 
%% Clearing all existing variables and defining global variables
clear;
close all;
clc;

%global variables which will be applied to all functions
%please see the following parts for detailed comments 
global window window_w window_h x_center y_center Word_Size Word_Font img_width img_height
global CursorSpeed Waiting_Time Rect_Center Cross_Delay Duration F_Sc P_Sc CondMat FACE blank 
global MACHINE 
%% Initializing Parameters 
Version = 'Experiment1'; %Experiment version
KbName('UnifyKeyNames'); %Unifying keyboard settings 
rng('shuffle'); 
ntrialtotal = 640;  %640
nprac = 4; %4
MACHINE = 0.7; 
%This an important variable, by changing this value, you can adjust the
%overall size of the stimuli display (the viewing angle)
%% Creating the condition variables
%First row: Gender, 1 for male, 2 for female 
%Second row: Age, 1 for young, 2 for old 
%Third row: Emotion -- 1 for happy, 2 for angry
%Fourth row: Variance, 1 for low var, 2 for high var
%Fifth row: set size, 1, 4, 9, 16
CondMat = GenerateCondMat([2,2,2,2,4]); 
CondMat = CondMat + 1;
CondMat(5,:) = CondMat(5,:).*CondMat(5,:);
CondMat = repmat(CondMat,1,ntrialtotal/64);
CondMat = CondMat(:,randperm(size(CondMat,2)));

%% Experimental settings 
Waiting_Time = 0.5; %Intervals (Blank Screen), 0.5
Cross_Delay = 0.6; %Fixation Cross Duration, 0.6
Duration = 1.5;  %Time for duration of display, 1
Rest = 30;  %Duration of each resting phase
F_Sc = []; %Full Screen
P_Sc = [0,0,900,650]; %Partial Screen
Word_Size = 35; %The size of the characters
Word_Font = 'Arial';  %Font of the characters
DPI = 200; 
CursorSpeed = DPI / 1000; %The speed of the cursor, in the morphing phase
img_width = 200 * MACHINE; %Width of the image displayed, it can also be controlled by MACHINE
img_height = 270 * MACHINE; %ditto
blank = 35 * MACHINE; %blank space between each two images 
%% Input Subject Information 
Info = {'Number','Initials','Gender [1=Male,2=Female,3=Other]','Age','Ethnicity','Education'};
dlg_title = 'Subject Information';
num_lines = 1;
subject_info = inputdlg(Info,dlg_title,num_lines);


%% Defining the filename
num=subject_info(1);
num=cell2mat(num);
name=subject_info(2);
name=cell2mat(name);
filename=['Result(',num2str(num),')_',name,'.mat'];

%% Opening the Screen
ListenChar(-1);
Screen('Preference','SkipSyncTests',1);
rng('shuffle');

[window,rect]=Screen('OpenWindow',0,[],F_Sc); %The last variable: input P_Sc if wanting to open a partial screen
Screen('BlendFunction',window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

window_w = rect(3);
window_h = rect(4);
x_center = window_w/2;
y_center = window_h/2;

Screen('TextSize', window, Word_Size);
Screen('TextFont', window, Word_Font);

Rect_Center = [x_center - img_width/2, y_center - img_height/2, ...
    x_center + img_width/2, y_center + img_height/2]; 
%The central location for the image, for the 1-face display as well as the
%morphing phase display 
%% Loading the stimuli
CurDir = pwd();
cd('Primary_Stimuli');

MYH = Loading_Image('M1_HAPPY'); %MYH: Male - Young - Happy
MOH = Loading_Image('M2_HAPPY'); %MOH: Male - Old - Happy
MYA = Loading_Image('M1_ANGRY'); %MYA: Male - Young - Angry
MOA = Loading_Image('M2_ANGRY'); %MOA: Male - Old - Angry
FYH = Loading_Image('F1_HAPPY'); %FYH: Female - Young - Happy
FOH = Loading_Image('F2_HAPPY'); %FOH: Female - Old - Happy
FYA = Loading_Image('F1_ANGRY'); %FYA: Female - Young - Angry 
FOA = Loading_Image('F2_ANGRY'); %FOA: Female - Old - Angry 

% load Chinese instruction images
instruction = imread([CurDir '/Instruction_CHN.jpeg']);
instruction = Screen('MakeTexture',window,instruction); 
prompt_startFormal = imread([CurDir '/startFormal.jpeg']);
prompt_startFormal = Screen('MakeTexture',window,prompt_startFormal); 
prompt_rest = imread([CurDir '/rest.jpeg']);
prompt_rest = Screen('MakeTexture',window,prompt_rest); 

%% Variable 1: Face Gender; Variable 2: Face Age; Variable 3: Face Emotion 
%Gender: 1 for male, 2 for female
%Age: 1 for young, 2 for old
%Emotion: 1 for happy, 2 for angry
FACE{1,1,1} = MYH;
FACE{1,1,2} = MYA;
FACE{1,2,1} = MOH;
FACE{1,2,2} = MOA;
FACE{2,1,1} = FYH;
FACE{2,1,2} = FYA;
FACE{2,2,1} = FOH;
FACE{2,2,2} = FOA;
cd(CurDir);

% show instructions 
Screen('DrawTexture',window,instruction);
Screen('Flip',window);
while 1 
    [~,~,kC] = KbCheck();
    if kC(KbName('space'))
        Start = 1;
        break 
    end
end
Screen('Flip',window);
WaitSecs(Waiting_Time);

pracSize = [1,4,9,16]; %Practice settings 
for iteprac = 1:nprac 
    pracCond = [randi(2),randi(2),randi(2)];
    Display_Image(pracCond(1),pracCond(2),pracCond(3),2,pracSize(iteprac));
    Screen('Flip',window);
    WaitSecs(Waiting_Time);
    Morph_Response(pracCond(1),pracCond(2),pracCond(3));
    Screen('Flip',window);
    WaitSecs(Waiting_Time);
end

%Display the instructions for the formal test trials
Screen('DrawTexture',window,prompt_startFormal);
Screen('Flip',window);
while 1 
    [~,~,kC] = KbCheck();
    if kC(KbName('space'))
        Start = 1;
        break 
    end
end
Screen('Flip',window);
WaitSecs(Waiting_Time);

for ite = 1:ntrialtotal
Condi_DI = CondMat(:,ite)'; %Condition_Display_Image
Condi_MR = CondMat(1:3,ite)'; %Condition_Morphing_Response
Gender = Condi_DI(1); Age = Condi_DI(2); Emotion = Condi_DI(3); Variance = Condi_DI(4); Size = Condi_DI(5);
[Face_Local,Face_Global] = Display_Image(Gender,Age,Emotion,Variance,Size); 
MeanFace.Local(ite) = mean(Face_Local);
MeanFace.Global(ite) = mean(Face_Global);
%Output_Display_Image, representing if the images were displayed correctly
LocalFace{ite} = Face_Local; %Recording all the faces displayed
GlobalFace{ite} = Face_Global; %Recording all the faces displayed and masked
Screen('Flip',window);
WaitSecs(Waiting_Time);
try
    [Output_MR,RT] = Morph_Response(Gender,Age,Emotion); %Output_Morph_Response, representing the value of the chosen morphing face 
    ResponseVL(ite) = Output_MR; %Response Value (Morphing Value) of the Trial
    Reaction_Time(ite) = RT; %Reaction Time
    Err.Local(ite) = Output_MR - MeanFace.Local(ite); %Local Error, for data analysis
    Err.Global(ite) = Output_MR - MeanFace.Global(ite); %Global Error, for data analysis
catch
    
end 
Screen('Flip',window);
WaitSecs(Waiting_Time);

% The data is recorded / saved every loop, in case the computer program
% crashes (due to multiple reasons)
cd Observer_Data
save(filename);
cd ..
%% Taking a break!
if mod(ite,80) == 0 && ite ~= 640 
    %Participants will have an unlimited-time rest after finishing every 80 trials
    %Participants will press the space bar to proceed 
        Screen('DrawTexture',window,prompt_rest);
        Screen('Flip',window);
        while 1 
            [~,~,KC] = KbCheck();
            if KC(KbName('space'))
                break
            end
        end
end

end

%The data will be recorded one last time
Screen('CloseAll');
cd Observer_Data
save(filename);
cd ..




