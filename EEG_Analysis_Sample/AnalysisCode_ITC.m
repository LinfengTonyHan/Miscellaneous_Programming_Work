clear;
close all;
warning off;
filename_list = dir(sprintf('NDA3_Data/*.cnt'));
foldername = 'ITC_N200';
method = 'wavelet';
%Initializing parameters
preStim = 0.5;
postStim = 1.2;
lowFilter = 65;
highFilter = 1;
channel = 1:9;
range = 1;

for ite = range
    filename = ['NDA3_Data/',filename_list(ite).name];
    
    Exp = 2;  %1 for P300, 2 for N200
    switch Exp
        case 1
            EV = [11:16,21:26];
            expName='P300';
            filename_list_trial = dir(sprintf('Trial_Info/P3_trial_info/*.mat'));
            triallist = ['Trial_Info/P3_trial_info/',filename_list_trial(ite).name];
            
        case 2
            EV = [31:36,41:46];
            expName='N200';
            filename_list_trial = dir(sprintf('Trial_Info/N2_trial_info/*.mat'));
            triallist = ['Trial_Info/N2_trial_info/',filename_list_trial(ite).name];
    end
    
    Trial_Data = load(triallist);
    %% preprocess data
    cfg = [];
    cfg.channel = channel;
    cfg.dataset = filename;
    cfg.continuous = 'yes';
    data = ft_preprocessing(cfg);
    
    %% filter data
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [lowFilter,highFilter];
    cfg.demean = 'yes';
    cfg.baselinewindow = [-0.2 0];
    data = ft_preprocessing(cfg,data);
    
    %% Extract trial information of event 1
    cfg = [];
    cfg.dataset = filename;
    cfg.trialdef.eventtype = 'trigger';
    cfg.trialdef.eventvalue = EV; % the value of the stimulus trigger for event 1
    
    cfg.trialdef.prestim = preStim; % in seconds
    cfg.trialdef.poststim = postStim; % in seconds
    cfg = ft_definetrial(cfg);
    %trial extraction from the filtered data (and raw for comparison)
    data = ft_redefinetrial(cfg,data);
    
    cfg = [];
    cfg.trials = Trial_Data.trial_tar;
    data_tar = ft_preprocessing(cfg, data);
    
    cfg = [];
    cfg.trials = randsample(Trial_Data.trial_nontar,360);
    data_nontar = ft_preprocessing(cfg, data);
    %% Here let's go with the time frequency analysis
    % Part 1, target trials
    
    %% An alternative option of mtmconvol method
    %note this time the t-f resolution varies as a function of frequency
    cfg = [];
    cfg.output = 'fourier';
    cfg.channel = channel;
    cfg.method = 'wavelet';
    cfg.toi = 0:0.02:1;
    ITC_tar = ft_freqanalysis(cfg, data_tar);
    ITC_nontar =  ft_freqanalysis(cfg, data_nontar);
    filesave1 = ['ITC_tar_',num2str(ite)];
    varsave1 = 'ITC_tar';
    filesave2 = ['ITC_nontar_',num2str(ite)];
    varsave2 = 'ITC_nontar';
    cd(foldername);
    save(filesave1,varsave1);
    save(filesave2,varsave2);
    cd ..
end

%% This part is for loading the existing data
% turn these into scripts when necessary.
% cd(foldername);
% for sp = range
%     if strcmp(method,'wavelet')
%     load(['TFR_data_tar_wavelet_',num2str(sp)]);
%     load(['TFR_data_nontar_wavelet_',num2str(sp)]);
%     elseif strcmp(method,'mtmconvol_static')
%     load(['TFR_data_tar_mtmconvol_',num2str(sp)]);
%     load(['TFR_data_nontar_mtmconvol_',num2str(sp)]);
%     elseif strcmp(method,'mtmconvol_dynamic')
%     load(['TFR_data_tar_mtmconvol_dynamic',num2str(sp)]);
%     load(['TFR_data_nontar_mtmconvol_dynamic',num2str(sp)]);
%     end
%     All_Subject{sp} = TFR_tar;
%     All_Subject_NT{sp} =TFR_nontar;
% end
% cd ..
%
% cfg = [];
% GRAND_TAR = ft_freqgrandaverage(cfg,All_Subject{1},All_Subject{2},...
%     All_Subject{3},All_Subject{4},All_Subject{5},All_Subject{6},All_Subject{7},...
%     All_Subject{8},All_Subject{9},All_Subject{10});
%
% GRAND_NONTAR = ft_freqgrandaverage(cfg,All_Subject_NT{1},All_Subject_NT{2},...
%     All_Subject_NT{3},All_Subject_NT{4},All_Subject_NT{5},All_Subject_NT{6},All_Subject_NT{7},...
%     All_Subject_NT{8},All_Subject_NT{9},All_Subject_NT{10});
%
% cfg = [];
% cfg.parameter = 'pow';
% %cfg.operation = 'add';
% GRAND_DIFF = GRAND_TAR;
% GRAND_DIFF.powspctrm = GRAND_TAR.powspctrm - GRAND_NONTAR.powspctrm;
% cfg = [];
% cfg.baseline     = [-0.5 -0.1];
% cfg.baselinetype = 'absolute';
% if strcmp(method,'wavelet')
% cfg.zlim = [-80 80];
% elseif strcmp(method,'mtmconvol')
% cfg.zlim = [-5, 10];
% end
% cfg.showlabels = 'yes';
% cfg.layout = 'biosemi32.lay';
% figure;
% ft_multiplotTFR(cfg, GRAND_TAR);
% figure;
% ft_multiplotTFR(cfg, GRAND_NONTAR);
% figure;
% ft_multiplotTFR(cfg, GRAND_DIFF);


%% load and visualize the data
close all;
LAB = 2;
if LAB == 1
    itc = [];
    itc.label = ITC_tar.label;
    itc.freq = ITC_tar.freq;
    itc.time = ITC_tar.time;
    itc.dimord = 'chan_freq_time';
    
    F = ITC_tar.fourierspctrm;   % copy the Fourier spectrum
    
elseif LAB == 2
    itc = [];
    itc.label = ITC_nontar.label;
    itc.freq = ITC_nontar.freq;
    itc.time = ITC_nontar.time;
    itc.dimord = 'chan_freq_time';
    
    F = ITC_nontar.fourierspctrm;   % copy the Fourier spectrum
end
N = size(F,1); % number of trials

% compute inter-trial phase coherence (itpc)
itc.itpc = F./abs(F); % divide by amplitude
itc.itpc = sum(itc.itpc,1); % sum angles
itc.itpc = abs(itc.itpc)/N; % take the absolute value and normalize
itc.itpc = squeeze(itc.itpc); % remove the first singleton dimension

% compute inter-trial linear coherence (itlc)
itc.itlc = sum(F) ./ (sqrt(N*sum(abs(F).^2)));
itc.itlc = abs(itc.itlc);     % take the absolute value, i.e. ignore phase
itc.itlc = squeeze(itc.itlc); % remove the first singleton dimension

% plots
figure
subplot(2, 1, 1);
imagesc(itc.time, itc.freq, squeeze(itc.itpc(1,:,:)));
axis xy
title('inter-trial phase coherence');
subplot(2, 1, 2);
imagesc(itc.time, itc.freq, squeeze(itc.itlc(1,:,:)));
axis xy
title('inter-trial linear coherence');
