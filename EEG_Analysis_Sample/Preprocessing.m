%Created by Linfeng Han
%hanlf16@mails.tsinghua.edu.cn
%codes written for advanced course "Neuroimaging Data Analysis"

close all; %It is better to close all windows before generating new ones
clear();
clc;

Dataset_Name = 'NDA2_dataset/P300_N170-gdy_raw.edf'; %Defining Dataset in the first place
cfg = [];
cfg.dataset = Dataset_Name;
cfg.continuous = 'yes';
data_raw = ft_preprocessing(cfg); %Generating raw data
Sample_channel = {data_raw.label{3},data_raw.label{7},data_raw.label{11}}; %Randomly selecting a few channels to take a rough look
sample_rate = data_raw.fsample; %Loading the sampling rate (for use in the filter function)

Pre = 0.1; % 0.1s before stimulus onset
Post = 0.5; % 0.5s after stimulus onset
FLP = 60; %Low-pass filter, eliminating high frequency noise
FHP = 1;  %High-pass filter
EV1 = 1; %Event value 1, 1 for P300 & 11 for N170
EV2 = 2; %Event value 2, 2 for P300 & 12 for N170

%% take a quick look at the data
cfg = [];
cfg.channel = Sample_channel;
cfg.viewmode= 'vertical'; %'vertical', 'component'
data_raw.trial{1} = ft_preproc_bandpassfilter(data_raw.trial{1},sample_rate,[FHP FLP]);
cfg_browsed = ft_databrowser(cfg,data_raw); 

%% Extract trial information for event 1 (P300: High-Frequency object; N170: Face)
cfg = [];
cfg.dataset = Dataset_Name;
cfg.trialdef.eventtype = 'trigger';
cfg.trialdef.eventvalue = EV1; 
cfg.trialdef.prestim = Pre; 
cfg.trialdef.poststim = Post; 
cfg.trialfun = 'trialfun_EDF'; 
cfg.triggerdef.trigger_channel = 25; %In the current experiment, the 25th channel refers to the triggers
cfg = ft_definetrial(cfg);
%% Use the extracted trial information to take out all the ERP segments
cfg.channel    = {'EEG'}; %All channels were EEG 
cfg.continuous = 'yes';
dataEV1 = ft_preprocessing(cfg);

%% Data Filtering, generally it should be processed before defining trials (raw data)
for ite = 1:length(dataEV1.trial)
dataEV1.trial{ite} = ft_preproc_bandpassfilter(dataEV1.trial{ite},sample_rate,[FHP FLP]);
end
%save the processed data to file
save PreprocData dataEV1

%% Repeat the procedures above: Extract trial information for event 2 (P300: Low-Frequency object; N170: House)
cfg  = [];
cfg.dataset = Dataset_Name;
cfg.trialdef.eventtype = 'trigger';
cfg.trialdef.eventvalue = EV2; 
cfg.trialdef.prestim = Pre; 
cfg.trialdef.poststim = Post;
cfg.trialfun = 'trialfun_EDF'; 
cfg.triggerdef.trigger_channel = 25;
cfg = ft_definetrial(cfg);

cfg.channel    = {'EEG'};
cfg.continuous = 'yes';
dataEV2 = ft_preprocessing(cfg);

%% Data Filtering
for ite = 1:length(dataEV2.trial)
dataEV2.trial{ite} = ft_preproc_bandpassfilter(dataEV2.trial{ite},sample_rate,[FHP FLP]);
end
%append the processed data to the same file as above
save PreprocData dataEV2 -append

%% Calculate ERFs
cfg = [];
ERF_EV1 = ft_timelockanalysis(cfg,dataEV1);
ERF_EV2 = ft_timelockanalysis(cfg,dataEV2);

%% Visualize ERF data
cfg = [];
cfg.layout = 'DSI24.lay'; %Channel map
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
% visualizing multiple conditions together
ft_multiplotER(cfg, ERF_EV1,ERF_EV2);

%% End of script