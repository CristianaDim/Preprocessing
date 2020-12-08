% Loads all EEG files, removes any remaining artifactual epochs and saves the resulting *.mat files
clear all
close all
clc

pn.fieldtrip = '../Z_Tools/fieldtrip-20190419/';
pn.data = '../B2_Data/';
pn.helper = './helper';

addpath(pn.fieldtrip);
addpath(genpath(pn.helper));
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
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec_ICAsubtr_artfRem.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec_ICAsubtr_artfRem.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec_ICAsubtr_artfRem.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec_ICAsubtr_artfRem.mat'];
        
        if ~exist(fnOUT)
            try
                load(fnIN);
                disp(sprintf('Artifact rejection for subject %s, session %s',subID{i},sess{j}))
                
                data_length = length(data.trial);
                events = data.cfg.event;
                
                %Remove EOG channels (not needed)
                cfg = [];
                
                try
                    cfg.channel = ft_channelselection({'all', '-Vu', '-Vo', '-Re','-Li'}, data.label);
                catch
                    cfg.channel = ft_channelselection({'all' '-Re','-Li'}, data.label);
                end
                data = ft_selectdata(cfg,data);
                
                cfg = [];
                cfg.criterion = 4;
                cfg.recursive = 'no';
                [index parm zval] = ChxEpochArtf(cfg,data);

                
                [index2 parm2 zval2] = FASTER1Ch(cfg,data);
                
                badchan = unique([index.c; index2]);
                
                cfg = [];
                cfg.method = 'spline';
                cfg.badchannel = data.label(badchan);
                cfg.trials = 'all';
                cfg.lambda = 1e-5;
                cfg.order = 4;
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                data = ft_channelrepair(cfg,data);
                
                [data index] = AutoCorrTrials(data);
                
                [index3 parm3 zval3] = FASTER4ChxEpoch(cfg,data);
                
                data.ArtDect.channels = badchan;
                
                tmp = zeros(data_length,1); tmp(index,1) = 1;
                badtrl = find(tmp==0);
                data.ArtDect.trials = badtrl;
                clear tmp
                
                data.ArtDect.channels_x_trials = index3;
                
                ind = [1:data_length];
                ind(badtrl) = [];
                tmp = ones(length(data.label),data_length);
                tmp(:,ind) = index3;
                tmp(badchan,:) = 1;
                data.ArtDect.channels_x_trials_all = tmp;
                clear tmp
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'complete';
                data = ft_rejectartifact(cfg,data);
                
                data.cfg.event = events;
                
                disp('Saving data...')
                
                save(fnOUT,'data')
            end
        end
        
        if ~exist(fnOUTb)
            try
                load(fnINb);
                disp(sprintf('Artifact rejection for subject %s, session %sb',subID{i},sess{j}))
                
                data_length = length(data.trial);
                events = data.cfg.event;
                
                %Remove EOG channels (not needed)
                cfg = [];
                
                try
                    cfg.channel = ft_channelselection({'all', '-Vu', '-Vo', '-Re','-Li'}, data.label);
                catch
                    cfg.channel = ft_channelselection({'all' '-Re','-Li'}, data.label);
                end
                data = ft_selectdata(cfg,data);
                
                cfg = [];
                cfg.criterion = 4;
                cfg.recursive = 'no';
                [index parm zval] = ChxEpochArtf(cfg,data);

                
                [index2 parm2 zval2] = FASTER1Ch(cfg,data);
                
                badchan = unique([index.c; index2]);
                
                cfg = [];
                cfg.method = 'spline';
                cfg.badchannel = data.label(badchan);
                cfg.trials = 'all';
                cfg.lambda = 1e-5;
                cfg.order = 4;
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                data = ft_channelrepair(cfg,data);
                
                [data index] = AutoCorrTrials(data);
                
                [index3 parm3 zval3] = FASTER4ChxEpoch(cfg,data);
                
                data.ArtDect.channels = badchan;
                
                tmp = zeros(data_length,1); tmp(index,1) = 1;
                badtrl = find(tmp==0);
                data.ArtDect.trials = badtrl;
                clear tmp
                
                data.ArtDect.channels_x_trials = index3;
                
                ind = [1:data_length];
                ind(badtrl) = [];
                tmp = ones(length(data.label),data_length);
                tmp(:,ind) = index3;
                tmp(badchan,:) = 1;
                data.ArtDect.channels_x_trials_all = tmp;
                clear tmp
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'complete';
                data = ft_rejectartifact(cfg,data);
                
                data.cfg.event = events;
                
                disp('Saving data...')
                
                save(fnOUTb,'data')
            end
        end
        
        if ~exist(fnOUTc)
            try
                load(fnINc);
                disp(sprintf('Artifact rejection for subject %s, session %sc',subID{i},sess{j}))
                
                data_length = length(data.trial);
                events = data.cfg.event;
                
                %Remove EOG channels (not needed)
                cfg = [];
                
                try
                    cfg.channel = ft_channelselection({'all', '-Vu', '-Vo', '-Re','-Li'}, data.label);
                catch
                    cfg.channel = ft_channelselection({'all' '-Re','-Li'}, data.label);
                end
                data = ft_selectdata(cfg,data);
                
                cfg = [];
                cfg.criterion = 4;
                cfg.recursive = 'no';
                [index parm zval] = ChxEpochArtf(cfg,data);

                
                [index2 parm2 zval2] = FASTER1Ch(cfg,data);
                
                badchan = unique([index.c; index2]);
                
                cfg = [];
                cfg.method = 'spline';
                cfg.badchannel = data.label(badchan);
                cfg.trials = 'all';
                cfg.lambda = 1e-5;
                cfg.order = 4;
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                data = ft_channelrepair(cfg,data);
                
                [data index] = AutoCorrTrials(data);
                
                [index3 parm3 zval3] = FASTER4ChxEpoch(cfg,data);
                
                data.ArtDect.channels = badchan;
                
                tmp = zeros(data_length,1); tmp(index,1) = 1;
                badtrl = find(tmp==0);
                data.ArtDect.trials = badtrl;
                clear tmp
                
                data.ArtDect.channels_x_trials = index3;
                
                ind = [1:data_length];
                ind(badtrl) = [];
                tmp = ones(length(data.label),data_length);
                tmp(:,ind) = index3;
                tmp(badchan,:) = 1;
                data.ArtDect.channels_x_trials_all = tmp;
                clear tmp
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'complete';
                data = ft_rejectartifact(cfg,data);
                
                data.cfg.event = events;
                
                disp('Saving data...')
                
                save(fnOUTc,'data')
            end
        end
        
        if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                disp(sprintf('Artifact rejection for subject %s, session %s_2',subID{i},sess{j}))
                
                data_length = length(data.trial);
                events = data.cfg.event;
                
                %Remove EOG channels (not needed)
                cfg = [];
                
                try
                    cfg.channel = ft_channelselection({'all', '-Vu', '-Vo', '-Re','-Li'}, data.label);
                catch
                    cfg.channel = ft_channelselection({'all' '-Re','-Li'}, data.label);
                end
                data = ft_selectdata(cfg,data);
                
                cfg = [];
                cfg.criterion = 4;
                cfg.recursive = 'no';
                [index parm zval] = ChxEpochArtf(cfg,data);
                
                [index2 parm2 zval2] = FASTER1Ch(cfg,data);
                
                badchan = unique([index.c; index2]);
                
                cfg = [];
                cfg.method = 'spline';
                cfg.badchannel = data.label(badchan);
                cfg.trials = 'all';
                cfg.lambda = 1e-5;
                cfg.order = 4;
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                data = ft_channelrepair(cfg,data);
                
                [data index] = AutoCorrTrials(data);
                
                [index3 parm3 zval3] = FASTER4ChxEpoch(cfg,data);
                
                data.ArtDect.channels = badchan;
                
                tmp = zeros(data_length,1); tmp(index,1) = 1;
                badtrl = find(tmp==0);
                data.ArtDect.trials = badtrl;
                clear tmp
                
                data.ArtDect.channels_x_trials = index3;
                
                ind = [1:data_length];
                ind(badtrl) = [];
                tmp = ones(length(data.label),data_length);
                tmp(:,ind) = index3;
                tmp(badchan,:) = 1;
                data.ArtDect.channels_x_trials_all = tmp;
                clear tmp
                
                cfg = [];
                cfg.viewmode = 'vertical';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                cfg = ft_databrowser(cfg, data);
                
                cfg.artfctdef.reject  = 'complete';
                data = ft_rejectartifact(cfg,data);
                
                data.cfg.event = events;
                
                disp('Saving data...')
                
                save(fnOUT_2,'data')
            end
        end
    end
end
