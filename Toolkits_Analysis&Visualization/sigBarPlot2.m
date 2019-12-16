function [pval1,pval2] = sigBarPlot2(Data1,Data2,testtype,group1name,group2name,xlab,ylab,legend1,legend2,compare_type,yrange)
%% Format of Data1 & Data2
% [pval1,pval2] = SigBarPlot2(Data1,Data2,testtype,group1name,group2name,xlab,ylab,legend1,legend2,compare_type,yrange)
% Data1: m*2 matrix, with one row representing 1 subject
% Data2: n*2 matrix, with one row representing 1 subject
% testType: choose from "paired" or "independent"
% group1name: label of the 1st condition
% group2name: label of the 2nd condition
% When plotting out the bar graphs, this function is calling the "sigstar"
% function, which exists in another package
%% Paired sample test or independent sample test
if strcmp(testType,'paired') + strcmp(testType,'independent') ~= 1
    error('Input incorrect: testType should be "paired" or "independent"');
end

if strcmp(testtype,'paired')
    [~,p1,~,~] = ttest(Data1(:,1),Data1(:,2));
    [~,p2,~,~] = ttest(Data2(:,1),Data2(:,2));
elseif strcmp(testtype,'independent')
    [~,p1,~,~] = ttest2(Data1(:,1),Data1(:,2));
    [~,p2,~,~] = ttest2(Data2(:,1),Data2(:,2));
end

[~,p3,~,~] = ttest2(Data1(:,1),Data2(:,1));
[~,p4,~,~] = ttest2(Data1(:,2),Data2(:,2));

%% Calculating Mean and SEM
M1 = mean(Data1);
SD1 = std(Data1);
N1 = size(Data1,1);
SEM1 = SD1 / sqrt(N1);

M2 = mean(Data2);
SD2 = std(Data2);
N2 = size(Data2,1);
SEM2 = SD2 / sqrt(N2);

M = [M1;M2];
SEM = [SEM1;SEM2];

Group = [1,2];
bar(M);
ylim(yrange);
hold on
numgroups = size(M,1);  numbars = size(M, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
x_errorbar=zeros(numgroups,numbars);
for i = 1:numbars
    x_errorbar(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
    errorbar(x_errorbar(:,i), M(:,i), SEM(:,i), 'k', 'LineStyle', 'none','LineWidth',1.5,'Color',[0.5 0.5 0.5],'CapSize',8);
end
Xlab = {group1name,group2name};
xlabel(xlab);
ylabel(ylab);
set(gca,'FontSize',16);
set(gca,'XTick',Group,'XTickLabel',Xlab);
%errorbar(Group,M,SEM,'LineStyle', 'none','LineWidth',2,'Color','r');
if compare_type == 1
    sigstar({[x_errorbar(1,1),x_errorbar(1,2)]},p1);
    sigstar({[x_errorbar(2,1),x_errorbar(2,2)]},p2);
elseif compare_type == 2
    sigstar({[x_errorbar(1,1),x_errorbar(2,1)]},p3);
    sigstar({[x_errorbar(1,2),x_errorbar(2,2)]},p4);
elseif compare_type == 3
    sigstar({[x_errorbar(1,1),x_errorbar(1,2)]},p1);
    sigstar({[x_errorbar(2,1),x_errorbar(2,2)]},p2);
    sigstar({[x_errorbar(1,1),x_errorbar(2,1)]},p3);
    sigstar({[x_errorbar(1,2),x_errorbar(2,2)]},p4);
end
legend(legend1,legend2);
%sigstar({[2,2]},p2);
pval1 = p1;
pval2 = p2;