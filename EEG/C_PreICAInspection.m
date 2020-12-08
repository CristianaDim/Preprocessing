% Loads all EEG files, opens the data browser, allowing
% for marking the gross noise periods prior to the ICA and saves the resulting *.mat files

clear all
close all
clc

pn.fieldtrip = '../Z_Tools/fieldtrip-20190419/';
pn.data = '../B2_Data/';

addpath(pn.fieldtrip);
ft_defaults

s = struct2cell(dir(pn.data));
subID = cell(1, size(s,2)-2);
for i = 1:size(subID,2)
    subID{1,i} = s{1,i+2};
end
clear s

sess = {'T0','T1','T2','T3','T4','T5','T6','T7','T8'};

for i = 1:length(subID)
    for j = 1:length(sess)
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt_insp.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt_insp.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt_insp.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt_insp.mat'];
        
        if ~exist(fnOUT)
            try
                load(fnIN);
                
                %Remove EMG channels (not needed)
                disp('Removing EMG channels')
                cfg = [];
                cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                data = ft_selectdata(cfg,data);
                
                disp(sprintf('Inspecting data for subject %s, session %s',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.blocksize = 20;
                cfg.continuous = 'yes';
                cfg.plotlabels = 'yes';
                cfg.viewmode = 'vertical';
                cfg.colorgroups = 'allblack';
                cfg.position = [0 0 1000 1000];
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'nan';
                data = ft_rejectartifact(cfg,data);
                
                disp('Saving data...')
                save(fnOUT,'data')
            end
        else
            disp(sprintf('Subject %s, session %s has already been inspected',subID{i},sess{j}))
        end
        
        if ~exist(fnOUTb)
            try
                load(fnINb);
                %Remove EMG channels (not needed)
                disp('Removing EMG channels')
                cfg = [];
                cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                data = ft_selectdata(cfg,data);
                
                disp(sprintf('Inspecting data for subject %s, session %sb',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.blocksize = 20;
                cfg.continuous = 'yes';
                cfg.plotlabels = 'yes';
                cfg.viewmode = 'vertical';
                cfg.colorgroups = 'allblack';
                cfg.position = [0 0 1000 1000];
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'nan';
                data = ft_rejectartifact(cfg,data);
                
                disp('Saving data...')
                save(fnOUTb,'data')
            end
        else
            disp(sprintf('Subject %s, session %sb has already been inspected',subID{i},sess{j}))
        end
        
        if ~exist(fnOUTc)
            try
                load(fnINc);
                %Remove EMG channels (not needed)
                disp('Removing EMG channels')
                cfg = [];
                cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                data = ft_selectdata(cfg,data);
                
                disp(sprintf('Inspecting data for subject %s, session %sc',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.blocksize = 20;
                cfg.continuous = 'yes';
                cfg.plotlabels = 'yes';
                cfg.viewmode = 'vertical';
                cfg.colorgroups = 'allblack';
                cfg.position = [0 0 1000 1000];
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'nan';
                data = ft_rejectartifact(cfg,data);
                
                disp('Saving data...')
                save(fnOUTc,'data')
            end
        else
            disp(sprintf('Subject %s, session %sc has already been inspected',subID{i},sess{j}))
        end
        
        if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                
                %Remove EMG channels (not needed)
                disp('Removing EMG channels')
                cfg = [];
                cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                data = ft_selectdata(cfg,data);
                
                disp(sprintf('Inspecting data for subject %s, session %s_2',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.blocksize = 20;
                cfg.continuous = 'yes';
                cfg.plotlabels = 'yes';
                cfg.viewmode = 'vertical';
                cfg.colorgroups = 'allblack';
                cfg.position = [0 0 1000 1000];
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'nan';
                data = ft_rejectartifact(cfg,data);
                
                disp('Saving data...')
                save(fnOUT_2,'data')
            end
        else
            disp(sprintf('Subject %s, session %s_2 has already been inspected',subID{i},sess{j}))
        end
    end
end
