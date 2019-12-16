function [recallTimes, recallPosition] = cRecallProb(studyList, recallList)
%% This function calculates the number of times and positions that words in a list get recalled
% studyList 
size_s = size(studyList,2);
size_r = size(recallList,2);

recallTimes = zeros(1, size_s);
recallPosition = {};

for ite_s = 1:size_s
    COUNT = 0;
    POSITION = [];
    for ite_r = 1:size_r 
        if strcmp(studyList{ite_s},recallList{ite_r})
            COUNT = COUNT+1;
            POSITION(COUNT)  = ite_r;
        end
    end 
    
    recallTimes(ite_s) = COUNT;
    recallPosition{ite_s} = POSITION;
   
end

end