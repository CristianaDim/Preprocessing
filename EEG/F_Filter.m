% Loads all EEG files, applies a bandpass filter
% of 0.1 - 100 Hz and a notch filter of 50 Hz, and saves the resulting *.mat files
clear all
close all
clc

pn.fieldtrip = '../Z_Tools/fieldtrip-20190419/';
pn.data = '../B2_Data/';

addpath(pn.fieldtrip);
ft_defaults;

s = struct2cell(dir(pn.data));
subID = cell(1, size(s,2)-2);
for i = 1:size(subID,2)
    subID{1,i} = s{1,i+2};
end
clear s

sess = {'T0','T1','T2','T3','T4','T5','T6','T7','T8'};

for i = 1:length(subID)
    for j = 1:length(sess)
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt.mat'];
        
        if ~exist(fnOUT)
            try
                load(fnIN);
                disp(sprintf('Filtering data for subject %s, session %s',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.bpfilter = 'yes'; %apply bandpass filter between 0.1 - 100 Hz
                cfg.bpfreq = [0.1 100];
                cfg.bpfilttype = 'fir';
                cfg.bsfilter = 'yes';
                cfg.bsfreq = [48 52; 98 102]; %apply notch filter
                cfg.plotfiltresp = 'yes';
                
                data = ft_preprocessing(cfg,data);
                
                disp('Filtering complete, saving data...')
                save(fnOUT,'data')
            end
        else
            disp(sprintf('Subject %s, session %s has already been filtered',subID{i},sess{j}))
        end
        
        if ~exist(fnOUTb)
            try
                load(fnINb);
                disp(sprintf('Filtering data for subject %s, session %s',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.bpfilter = 'yes'; %apply bandpass filter between 0.1 - 100 Hz
                cfg.bpfreq = [0.1 100];
                cfg.bpfilttype = 'fir';
                cfg.bsfilter = 'yes';
                cfg.bsfreq = [48 52; 98 102]; %apply notch filter
                cfg.plotfiltresp = 'yes';
                
                data = ft_preprocessing(cfg,data);
              
                
                disp('Filtering complete, saving data...')
                save(fnOUTb,'data')
            end
        else
            disp(sprintf('Subject %s, session %s has already been filtered ',subID{i},sess{j}))
        end
        
        if ~exist(fnOUTc)
            try
                load(fnINc);
                disp(sprintf('Filtering data for subject %s, session %sc',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.bpfilter = 'yes'; %apply bandpass filter between 0.1 - 100 Hz
                cfg.bpfreq = [0.1 100];
                cfg.bpfilttype = 'fir';
                cfg.bsfilter = 'yes';
                cfg.bsfreq = [48 52; 98 102]; %apply notch filter
                cfg.plotfiltresp = 'yes';
                
                data = ft_preprocessing(cfg,data);
              
                
                disp('Filtering complete, saving data...')
                save(fnOUTc,'data')
            end
        else
            disp(sprintf('Subject %s, session %sc has already been filtered ',subID{i},sess{j}))
        end
        
        if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                disp(sprintf('Filtering data for subject %s, session %s_2',subID{i},sess{j}))
                
                cfg = [];
                cfg.channel = 'all';
                cfg.bpfilter = 'yes'; %apply bandpass filter between 0.1 - 100 Hz
                cfg.bpfreq = [0.1 100];
                cfg.bpfilttype = 'fir';
                cfg.bsfilter = 'yes';
                cfg.bsfreq = [48 52; 98 102]; %apply notch filter
                cfg.plotfiltresp = 'yes';
                
                data = ft_preprocessing(cfg,data);
                
                disp('Filtering complete, saving data...')
                save(fnOUT_2,'data')
            end
        else
            disp(sprintf('Subject %s, session %s_2 has already been filtered',subID{i},sess{j}))
        end
        
    end
end
