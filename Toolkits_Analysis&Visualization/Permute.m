function [pval,olddata,newdata] = Permute(approach,Obsdata,numite)
if strcmp(approach,'within')
    %% If this is within-subject design, the matrix should be arranged in this pattern:
    %each row: one subject; each column: a variable of interest (that is
    %going to be permuted
    datatype = '2-dimension-matrix';
    numsub = size(Obsdata,1);
    numiv = size(Obsdata,2);
    
    MEAN_Ori = mean(Obsdata);
    STD_Ori = std(Obsdata);
    olddata = [MEAN_Ori; STD_Ori];
    [~,oldslope,~] = regression(MEAN_Ori,1:numiv);
    for I = 1:numite 
    for ite = 1:numsub
       newrow(ite,:) = Shuffle(Obsdata(ite,:));
    end
    
    M_newrow = mean(newrow);
    [~,newslope,~] = regression(M_newrow,1:numiv);
    NewK(I) = newslope;
    Newdis(I,:) = M_newrow;
    end
    pval = sum(NewK < oldslope) / numite;
    
    newdata = mean(Newdis);   
end
   