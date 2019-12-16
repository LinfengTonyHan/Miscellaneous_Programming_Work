function [condAper,condBper] = dbCondSpr(Condition,Response_Perf)
%% This function is written for analyzing performance in tasks with only 2 conditions
size_c = size(Condition,2);
size_r = size(Response_Perf,2);
if size_c ~= size_r
    error('Sizes of the two vectors do not match.')
end

condA = Response_Perf(Condition == 1);
condB = Response_Perf(Condition == 0);
condAper = mean(condA);
condBper = mean(condB);
end