function [pval, analysisOutput] = sigBarPlot1(Data,testType,group1name,group2name)
%% This function is written for group comparisons (in 2 conditions)
% Data: should be organzed in 2 columns, each column containing one group's data
% testType: choose from "paired" or "independent"
% group1name: label of the 1st condition
% group2name: label of the 2nd condition
% When plotting out the bar graphs, this function is calling the "sigstar"
% function, which exists in another package
if strcmp(testType,'paired') + strcmp(testType,'independent') ~= 1
    error('Input incorrect: testType should be "paired" or "independent"');
end

if strcmp(testType,'paired')
    [h,p,CI,stats] = ttest(Data(:,1),Data(:,2));
elseif strcmp(testType,'independent')
    [h,p,CI,stats] = ttest2(Data(:,1),Data(:,2));
end

M = mean(Data);
SD = std(Data);
N = size(Data,1);
SEM = SD / sqrt(N);

Group = 1:2;
bar(Group,M);
hold on
Xlab = {group1name,group2name};
xlabel('Group');
ylabel('Accuracy');
set(gca,'FontSize',16);
set(gca,'XTick',Group,'XTickLabel',Xlab);
errorbar(Group,M,SEM,'LineStyle', 'none','LineWidth',2,'Color','r');
H = sigstar(Group,p);
pval = p;
analysisOutput.hval = h;
analysisOutput.pval = p;
analysisOutput.CI = CI;
analysisOutput.Details = stats;