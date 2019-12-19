function [Face_Local,Face_Global] = Display_Image(Gender,Age,Emotion,Variance,Size)
%%  [Face_Local,Face_Global] = Display_Image(Gender,Age,Emotion,Variance,Size)
% This function is for displaying the target images on the screen
% The five variables correspond to the 5 IVs in the experiment: 
% Face gender, age, emotion, crowd variance (low / high), set size
global FACE x_center y_center img_height img_width blank window Duration Cross_Delay
Face_Stimuli = FACE{Gender,Age,Emotion};

Mean_Type = randi(3); %Creating a randomized mean type, low, middle, or high
% This is to prevent that the final results will correlate towards the mean
% of the whole set 

%% Choosing the target faces, recording local (displayed) and global (displayed and masked) faces
switch Mean_Type %Mean type, 1: <35; 2: 35< <65, 3: >65
    case 1 
MEAN = 1000; VAR = 1000; %setting an impossible value
        switch Variance %Variance, 1 corresponds to low variance, smaller than 20, 2 for high variance, higher than 20 
            case 1
                while MEAN > 35 || VAR > 20
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
            case 2
                while MEAN > 35 || (VAR < 30 && Size~=1)
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
        end
         
    case 2
        MEAN = 1000; VAR = 1000;
        switch Variance
            case 1
                while MEAN < 35 || MEAN > 65 || VAR > 20
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
            case 2
                while MEAN < 35 || MEAN > 65 || (VAR < 30 && Size~=1)
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
        end
         
   case 3
        MEAN = -500; VAR = 1000;
        switch Variance
            case 1
                while MEAN < 65 || VAR > 20
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
            case 2
                while MEAN < 65 || (VAR < 30 && Size~=1)
            Face_Global = randsample(1:100,16);
            Face_Local = randsample(Face_Global,Size);
            MEAN = mean(Face_Local);
            VAR = std(Face_Local);
                end
        end
end

%% The following portion is for displaying the images on the screen
nsize = sqrt(Size);
xStart = x_center - (nsize-1) * (img_width + blank) / 2;
xEnd = x_center + (nsize-1) * (img_width + blank) / 2;
yStart = y_center - (nsize-1) * (img_height + blank) / 2;
yEnd = y_center + (nsize-1) * (img_height + blank) / 2;
xGridLines = linspace(xStart, xEnd, nsize);
yGridLines = linspace(yStart, yEnd, nsize);
[xPoints, yPoints] = meshgrid(xGridLines, yGridLines);
RECT = [xPoints(:)'-img_width/2; yPoints(:)'-img_height/2; ...
xPoints(:)'+img_width/2; yPoints(:)'+img_height/2];
DrawFormattedText(window,'+','center','center');
Screen('Flip',window);
WaitSecs(Cross_Delay);
Screen('DrawTextures',window,Face_Stimuli(Face_Local),[],RECT); %Display the images on the target locations;
Screen('Flip',window);
WaitSecs(Duration);

