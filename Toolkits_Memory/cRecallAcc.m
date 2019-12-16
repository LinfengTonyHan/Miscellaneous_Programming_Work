function [Accuracy_Vector] = cRecallAcc(recallList, studyList)
%% This function is for coding the accuracy of a recalled list 
%1->Correct recall response, 0->Incorrect recall response 
%[Accuracy_Vector] = crecallacc(recallList,studyList)

%Copyright: Linfeng Han, undergraduate student, Tsinghua University
%Contact: linfenghan98@gmail.com

%recallList, 1 by n cell type
%studyList, 1 by m cell type 
%Accuracy_Vector, binary
length = size(recallList,2);
length_ref = size(studyList,2);
Accuracy_Vector = zeros(1,length);
for ite_scan = 1:length 
    COR = 0;
    for ite_compare = 1:length_ref
        if strcmp(recallList{ite_scan},studyList{ite_compare})
            COR = 1;
            break
        end
    end
    Accuracy_Vector(ite_scan) = COR; 
end
end