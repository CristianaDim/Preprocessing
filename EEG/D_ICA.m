% Loads all EEG files, runs ICA and saves the resulting *.mat files
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
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt_insp.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt_insp.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt_insp.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt_insp.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt_insp_ICA.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt_insp_ICA.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt_insp_ICA.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt_insp_ICA.mat'];
        
        if ~exist(fnOUT)
            try
                load(fnIN);
                disp(sprintf('Running ICA for subject %s, session %s',subID{i},sess{j}))
                
                cfg = [];                
                cfg.runica.pca = 30;
                cfg.method = 'runica';
                
                comp = ft_componentanalysis(cfg,data);
                
                disp('Saving data...')
                save(fnOUT,'comp')
                
            end
          else
            disp(sprintf('Subject %s, session %s already has ICA',subID{i},sess{j}))            
         end
         
         if ~exist(fnOUTb)
             try
                 load(fnINb);
                 disp(sprintf('Running ICA for subject %s, session %sb',subID{i},sess{j}))
                 
                 cfg = [];                 
                 cfg.runica.pca = 30;
                 cfg.method = 'runica';
                 
                 comp = ft_componentanalysis(cfg,data);
                 
                 disp('Saving data...')
                 save(fnOUTb,'comp')
                 
             end
          else
            disp(sprintf('Subject %s, session %s already has ICA',subID{i},sess{j}))            
         end
        
         if ~exist(fnOUTc)
            try
                load(fnINc);
                disp(sprintf('Running ICA for subject %s, session %sc',subID{i},sess{j}))
                
                cfg = [];                
                cfg.runica.pca = 30;
                cfg.method = 'runica';
                
                comp = ft_componentanalysis(cfg,data);
                
                disp('Saving data...')
                save(fnOUTc,'comp')
                
            end
          else
            disp(sprintf('Subject %s, session %sc already has ICA',subID{i},sess{j}))            
         end
         
         if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                disp(sprintf('Running ICA for subject %s, session %s_2',subID{i},sess{j}))
                
                cfg = [];                
                cfg.runica.pca = 30;
                cfg.method = 'runica';
                
                comp = ft_componentanalysis(cfg,data);
                
                disp('Saving data...')
                save(fnOUT_2,'comp')
                
            end
          else
            disp(sprintf('Subject %s, session %s_2 already has ICA',subID{i},sess{j}))            
         end
    end
end
