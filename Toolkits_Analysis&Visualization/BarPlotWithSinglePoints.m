function BarPlotWithSinglePoints(M,SEM,rawData,segments,markerSize)
%% M is the matrix for mean values, SEM is the matrix for standard errors
% To enhance the robustness of this script, Mean and SEM values should be
% input manually
if nargin == 4
    markerSize = 5; %default marker size
end

bar(M);
hold on;

numgroups = size(M, 1);  numbars = size(M, 2);
if numbars ~= length(segments)-1
    error('segment size does not match with number of groups.');
end

if numgroups ~= size(rawData,2)
    error('The number of columns does not match with number of bar groups.');
end

for iteGroup = 1:numbars
    %rawDataGroups{iteGroup} = rawData;
    rangeStart = segments(iteGroup);
    rangeEnd = segments(iteGroup + 1) - 1;
    rawDataGroups{iteGroup} = rawData(rangeStart:rangeEnd, :);
end

groupwidth = min(0.8, numbars/(numbars+1.5));
x_errorbar = zeros(numgroups,numbars);
for i = 1:numbars
    x_errorbar(:,i) = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
    errorbar(x_errorbar(:,i), M(:,i), SEM(:,i), 'k', 'LineStyle', 'none','LineWidth',1.5,'Color',[0.5 0.5 0.5],'CapSize',8);
    scatterDataPoints = rawDataGroups{i};
    numSub = size(scatterDataPoints,1);
    for iteGroup = 1:numgroups
        hold on
        scatter(ones(1,numSub)*x_errorbar(iteGroup,i),scatterDataPoints(:,iteGroup),markerSize,'m');
    end
    hold on
end

end