%homework for NDA2, by Shuchen Liu 2019-03-18
clear; 
close all;
warning off;
filename_list = dir(sprintf('NDA3_Data/*.cnt'));

%Initializing parameters
preStim = 0.2;
postStim = 1;
lowFilter = 40;
highFilter = 1;
channel = 1:9;

for ite = 1:10
filename = ['NDA3_Data/',filename_list(ite).name];

Exp = 2;  %1 for P300, 2 for N200
switch Exp
    case 1
        EV = [11:16,21:26];
        expName='P300';  
    case 2
        EV = [31:36,41:46];
        expName='N200';
end


    %% preprocess data
    cfg = [];
    cfg.channel = channel;
    cfg.dataset = filename;
    cfg.continuous = 'yes';
    data = ft_preprocessing(cfg);
    %cfg = [];
    %cfg.resamplefs = 250;
    %data = ft_resampledata(cfg,data);
    %% filter data
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [lowFilter,highFilter];
    data = ft_preprocessing(cfg,data);

% ICA is not necessary
%% Rejecting Artifacts by ICA    
cfg = [];
cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
comp = ft_componentanalysis(cfg, data);

%% plot the components for visual inspection
cfg = [];
cfg.component = 1:20;  % specify the component(s) that should be plotted
cfg.layout = 'biosemi32.lay'; % specify the layout file that should be used for plotting
cfg.comment = 'no';
cfg.viewmode = 'component';
ft_databrowser(cfg, comp);
%% REMOVE COMPONENTS
cfg = [];
cfg.component = 12; % to be removed component(s)
data = ft_rejectcomponent(cfg, comp, data);

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
    
    cfg =[];
    cfg.method = 'summary';
    data_final = ft_rejectvisual(cfg,data);
    %% extract ERP
    cfg = [];
    ERP = ft_timelockanalysis(cfg,data_final);
    filesave = ['ERP_data_',num2str(ite)];
    varsave = 'ERP';
    cd('Processed_Data');
    save(filesave,varsave);
    cd .. 
    
end

cd('Processed_Data_N200');
for sp = 1:10
    load(['ERP_data_',num2str(sp)]);
    All_Subject{sp} = ERP;
end

cfg = [];
data_integrated = ft_timelockgrandaverage(cfg,All_Subject{1},All_Subject{2},...
    All_Subject{3},All_Subject{4},All_Subject{5},All_Subject{6},All_Subject{7},...
    All_Subject{8},All_Subject{9},All_Subject{10});

cfg = [];
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
cfg.baseline = [-0.2 0];
for chan = 1:9
    cfg.channel = chan;
    figure;
ft_singleplotER(cfg, data_integrated);
end

cd ..

cfg = [];
cfg.layout = 'biosemi32.lay';
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
ft_multiplotER(cfg,data_integrated);