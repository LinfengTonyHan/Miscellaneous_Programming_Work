function CondMat = GenerateCondMat(level)
%% This function is for generating the condition matrix
%CondMat = GenerateCondMat(level)
%If you are conducting a 2*2*2 experimental design, do [2,2,2]
trials = prod(level);
for i = 1:length(level)
    block = 0:(level(i)-1);
    lenBlock = prod(level(1:i))/level(i);
    sequence(i,:) = repmat(sort(repmat(block,1,lenBlock)),1,trials/(prod(level(1:i))));
end

CondMat = sequence;