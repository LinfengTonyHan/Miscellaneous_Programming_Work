function [Click,RT] = Morph_Response(Gender,Age,Emotion)
%% [Click,RT] = Morph_Response(Gender,Age,Emotion)
% This is the function for getting the morph value (response phase)
global window CursorSpeed Waiting_Time Rect_Center FACE
Clicking_Time = NaN; %Generating NaN as the initial clicking time
Stimuli = FACE{Gender,Age,Emotion};
[mouse_x,mouse_y,clicks] = GetMouse; %Getting the mouse coordianates

Starting_Time = GetSecs();
while ~any(clicks) % if the participant is NOT pressing the key, wait for mouse-click release
        [mouse_x, mouse_y, clicks] = GetMouse;
        MouseCoor  = mod((mouse_x + mouse_y)*CursorSpeed,200);
        FV = ceil(min(MouseCoor,200-MouseCoor));
        %FV: Face Value, this variable should range from 1~100
        Screen('DrawTexture',window,Stimuli(FV),[],Rect_Center) %Display the morphing target on the center
        Screen('Flip',window);

if any(clicks) %When the participant presses the mouse key, recording the values at that moment  
Clicking_Time = GetSecs();
         Click = FV;
         Screen('DrawTexture',window,Stimuli(FV),[],Rect_Center) 
         Screen('Flip',window);
         WaitSecs(Waiting_Time);
         break
end
end
         
RT = Clicking_Time - Starting_Time; %Recording the reaction time of each trial 

Screen('Flip', window);
WaitSecs(Waiting_Time);

end
