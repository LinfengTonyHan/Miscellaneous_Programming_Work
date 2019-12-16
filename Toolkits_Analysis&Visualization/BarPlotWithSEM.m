function BarPlotWithSEM(M,SEM)
%% M is the matrix for mean values, SEM is the matrix for standard errors 
bar(M);

hold on;

numgroups = size(M,1);  numbars = size(M, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
x_errorbar=zeros(numgroups,numbars);
for i = 1:numbars
    x_errorbar(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
    errorbar(x_errorbar(:,i), M(:,i), SEM(:,i), 'k', 'LineStyle', 'none','LineWidth',1.5,'Color',[0.5 0.5 0.5],'CapSize',8);
end

end