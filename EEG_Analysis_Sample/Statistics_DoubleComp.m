% Comparing ERP signals. Statistical tests: t-test

clear;
close all;
warning off;
foldername = 'BaselineCor_N200';
preStim = 0.5;
postStim = 1;
channel = 'all';
range = 1:10;
cd(foldername);
load All_Subject_tar.mat;
load All_Subject_nontar.mat;
cd ..
Tval = zeros(1,1000);
H = zeros(1,1000);
for ichan = 1:18
    disp('Proceeding...')
    for itrial = 1:1000
        PT = [All_Subject_tar{1}.avg(ichan,500+itrial),All_Subject_tar{2}.avg(ichan,500+itrial),All_Subject_tar{3}.avg(ichan,500+itrial),All_Subject_tar{4}.avg(ichan,500+itrial),All_Subject_tar{5}.avg(ichan,500+itrial),All_Subject_tar{6}.avg(ichan,500+itrial),All_Subject_tar{7}.avg(ichan,500+itrial),All_Subject_tar{8}.avg(ichan,500+itrial),All_Subject_tar{9}.avg(ichan,500+itrial),All_Subject_tar{10}.avg(ichan,500+itrial)];
        PN = [All_Subject_nontar{1}.avg(ichan,500+itrial),All_Subject_nontar{2}.avg(ichan,500+itrial),All_Subject_nontar{3}.avg(ichan,500+itrial),All_Subject_nontar{4}.avg(ichan,500+itrial),All_Subject_nontar{5}.avg(ichan,500+itrial),All_Subject_nontar{6}.avg(ichan,500+itrial),All_Subject_nontar{7}.avg(ichan,500+itrial),All_Subject_nontar{8}.avg(ichan,500+itrial),All_Subject_nontar{9}.avg(ichan,500+itrial),All_Subject_nontar{10}.avg(ichan,500+itrial)];
        [hypo,pval,~,STAT] = ttest(PT,PN,0.005); %Bonferonni Test
        Tval(ichan,itrial) = STAT.tstat; %Generating the T value
        H(ichan,itrial) = hypo;
    end
end

Direc(Tval < 0) = -1; %target < nontarget
Direc(Tval > 0) = 1; %target > nontarget
Direc = reshape(Direc,18,1000);
H_New = Direc.*H;

%%
for ICH = 1:18
    for ICH_C = 1:1500
        mean_tar(ICH,ICH_C) = mean([All_Subject_tar{1}.avg(ICH,ICH_C),All_Subject_tar{2}.avg(ICH,ICH_C),...
            All_Subject_tar{3}.avg(ICH,ICH_C),All_Subject_tar{4}.avg(ICH,ICH_C),...
            All_Subject_tar{5}.avg(ICH,ICH_C),All_Subject_tar{6}.avg(ICH,ICH_C),...
            All_Subject_tar{7}.avg(ICH,ICH_C),All_Subject_tar{8}.avg(ICH,ICH_C),...
            All_Subject_tar{9}.avg(ICH,ICH_C),All_Subject_tar{10}.avg(ICH,ICH_C)]);
        mean_nontar(ICH,ICH_C) = mean([All_Subject_nontar{1}.avg(ICH,ICH_C),All_Subject_nontar{2}.avg(ICH,ICH_C),...
            All_Subject_nontar{3}.avg(ICH,ICH_C),All_Subject_nontar{4}.avg(ICH,ICH_C),...
            All_Subject_nontar{5}.avg(ICH,ICH_C),All_Subject_nontar{6}.avg(ICH,ICH_C),...
            All_Subject_nontar{7}.avg(ICH,ICH_C),All_Subject_nontar{8}.avg(ICH,ICH_C),...
            All_Subject_nontar{9}.avg(ICH,ICH_C),All_Subject_nontar{10}.avg(ICH,ICH_C)]);
    end
end

%%
% Scaling of the vertical axis for the plots below
%% To plot the figure
close all;
figure;

FaceColor_Pos = [0.9,0.8,0.9];
FaceColor_Neg = [0.9,0.9,0.8];

for Channel = 10:18
    subplot(3,3,Channel-9);
    H_Channel = H_New(Channel,:);
    tarC = mean_tar(Channel,:);
    nontarC = mean_nontar(Channel,:);
    [RecPos,RecNeg] = findrec2(H_Channel);
    X = -0.499:0.001:1;
    try
        for ipos = 1:size(RecPos,2)
            hold on;
            rectangle('Position',[(((RecPos{ipos}(1)+500)/1000) - 0.5),-2.5,((RecPos{ipos}(2)-RecPos{ipos}(1))/1000),4.5],'FaceColor',FaceColor_Pos);
            % plot the lines in front of the rectangle
        end
        
    catch
        
    end
    
    try
        for ipos = 1:size(RecNeg,2)
            %subplot(3,4,ipos)
            %use the rectangle to indicate the time range used later
            hold on;
            rectangle('Position',[(((RecNeg{ipos}(1)+500)/1000) - 0.5),-2.5,((RecNeg{ipos}(2)-RecNeg{ipos}(1))/1000),4.5],'FaceColor',FaceColor_Neg);
            % plot the lines in front of the rectangle
        end
    catch
    end
    hold on;
    plot(X,tarC);
    hold on
    plot(X,nontarC);
    ylim([-2.5,2]);
end

%% These are for the next step

