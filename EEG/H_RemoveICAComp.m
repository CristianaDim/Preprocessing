% Loads all EEG files and a text file containing
% the manually excluded ICA components, removes the components, and saves
% the resulting *.mat files
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
ncomp = 30;

for i = 1:length(subID)
    for j = 1:length(sess)
        fnINic = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt_insp_ICA.mat'];
        fnINicb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt_insp_ICA.mat'];
        fnINicc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt_insp_ICA.mat'];
        fnINic_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt_insp_ICA.mat'];
        
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec.mat'];
        
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        
        fid = fopen('ComponentsToBeRemoved.txt');
        comps = textscan(fid,'%s%s%s');
        fclose(fid);

        if ~exist(fnOUT)
            try
                load(fnIN);
                load(fnINic);
                disp(sprintf('Removing ICA components for subject %s, session %s',subID{i},sess{j}))
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                cfg = [];
                cfg.component = str2num(cell2mat(comps{1,3}(find(strcmp(comps{1,1},subID{i}) & strcmp(comps{1,2},sess{j}))))); % to be removed component(s)
                data = ft_rejectcomponent(cfg, comp, data);
                
                data.cfg.event = data.cfg.previous{1,2}.event;
                
                figure
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                
                save(fnOUT,'data');
            end
        end
        
        if ~exist(fnOUTb)
            try
                load(fnINb);
                load(fnINicb);
                disp(sprintf('Removing ICA components for subject %s, session %sb',subID{i},sess{j}))
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                cfg = [];
                cfg.component = str2num(cell2mat(comps{1,3}(find(strcmp(comps{1,1},subID{i}) & strcmp(comps{1,2},sess{j}+"b"))))); % to be removed component(s)
                data = ft_rejectcomponent(cfg, comp, data);
                
                data.cfg.event = data.cfg.previous{1,2}.event;
                
                figure
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                
                save(fnOUTb,'data');
            end
        end
        
        if ~exist(fnOUTc)
            try
                load(fnINc);
                load(fnINicc);
                disp(sprintf('Removing ICA components for subject %s, session %sc',subID{i},sess{j}))
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                cfg = [];
                cfg.component = str2num(cell2mat(comps{1,3}(find(strcmp(comps{1,1},subID{i}) & strcmp(comps{1,2},sess{j}+"c"))))); % to be removed component(s)
                data = ft_rejectcomponent(cfg, comp, data);
                
                data.cfg.event = data.cfg.previous{1,2}.event;
                
                figure
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                
                save(fnOUTc,'data');
            end
        end
        
        if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                load(fnINic_2);
                disp(sprintf('Removing ICA components for subject %s, session %s_2',subID{i},sess{j}))
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                cfg = [];
                cfg.component = str2num(cell2mat(comps{1,3}(find(strcmp(comps{1,1},subID{i}) & strcmp(comps{1,2},sess{j}+"_2"))))); % to be removed component(s)
                data = ft_rejectcomponent(cfg, comp, data);
                
                data.cfg.event = data.cfg.previous{1,2}.event;
                
                figure
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, data);
                
                
                save(fnOUT_2,'data');
            end
        end
        
    end
end
