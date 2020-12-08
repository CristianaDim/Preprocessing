% Loads all EEG files, segments them in 10 sec epochs, and saves the resulting *.mat files
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
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec.mat'];
        
        
        fnHDR = [pn.data,subID{i},'/',subID{i},'_',sess{j},'.vhdr'];
        fnHDRb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b.vhdr'];
        fnHDRc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c.vhdr'];
        fnHDR_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2.vhdr'];
        
        fs = 500; %Sampling rate
        epochLength = 30; %seconds (for sleep staging)

        if ~exist(fnOUT)
            if exist(sprintf('%s/%s/%s_%s.txt',pn.data,subID{i},subID{i},sess{j}))
                try
                    disp(sprintf('Loading data for subject %s, session %s',subID{i}, sess{j}))
                    load(fnIN)
                    
                    disp('Removing EMG channels')
                    %Remove EMG channels (not needed)
                    cfg = [];
                    cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                    data = ft_selectdata(cfg,data);
                    
                    disp('Loading markers and setting up marker structure')
                    cfg = [];
                    cfg.dataset             = fnHDR;
                    cfg.trialdef.eventtype = 'Stage';
                    cfg.trialdef.eventvalue = {' N1', ' N2', ' N3', ' N4', ' REM', ' Wa', ' Mov'};
                    cfg_stages.minlength = 0;
                    cfg_stages          = ft_definetrial(cfg);
                    
                    
                    for eventInd = 1:length(cfg_stages.event)
                        comInd(eventInd) = strcmp(cfg_stages.event(eventInd).type,'Comment');
                    end
                    cfg_stages.event(find(comInd==1)) = [];
                    cfg_stages.event(1) = [];
                    
                    for sample = 1:length(cfg_stages.event)
                        cfg_stages.event(sample).duration = fs * epochLength;
                    end
                    
                    for trl = 1:length(cfg_stages.event)
                        cfg_stages.trl(trl,1) = cfg_stages.event(trl).sample;
                        cfg_stages.trl(trl,2) = cfg_stages.event(trl).sample + cfg_stages.event(trl).duration;
                        cfg_stages.trl(trl,3) = 0;
                    end
                    data = ft_redefinetrial(cfg_stages,data);
                    
                    disp('Segmenting data')
                    cfg = [];
                    cfg.dataset              = fnHDR;
                    cfg.trialfun             = 'ft_trialfun_general';
                    cfg.trialdef.triallength = 10;                      % duration in seconds
                    cfg.trialdef.ntrials     = inf;                    % number of trials, inf results in as many as possible
                    clear cfg.event
                    cfg.event = cfg_stages.event;
                    cfg                      = ft_definetrial(cfg);
                    
                    % read the data from disk and segment it into 10-second pieces
                    data           = ft_redefinetrial(cfg, data);
                    
                    disp(sprintf('Saving data for subject %s, session %s', subID{i}, sess{j}))
                    save(fnOUT,'data')
                    disp('Done')
                catch
                    disp(sprintf('Something went wrong. Segmentation for subject %s, session %s failed',...
                        subID{i}, sess{j}))
                end
            else
                disp(sprintf('Sleep staging has not been completed for subject %s, session %s yet,',...
                    'so this step cannot be performed', subID{i}, sess{j}))
            end
        else
            disp(sprintf('Segmentation has already been done for subject %s, session %s',...
                subID{i}, sess{j}))
        end
        
        if ~exist(fnOUTb)
            if exist(sprintf('%s/%s/%s_%sb.txt',pn.data,subID{i},subID{i},sess{j}))
                try
                    disp(sprintf('Loading data for subject %s, session %sb',subID{i}, sess{j}))
                    load(fnINb)
                    
                    disp('Removing EMG channels')
                    %Remove EMG channels (not needed)
                    cfg = [];
                    cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                    data = ft_selectdata(cfg,data);
                    
                    disp('Loading markers and setting up marker structure')
                    cfg = [];
                    cfg.dataset             = fnHDRb;
                    cfg.trialdef.eventtype = 'Stage';
                    cfg.trialdef.eventvalue = {' N1', ' N2', ' N3', ' N4', ' REM', ' Wa', ' Mov'};
                    cfg_stages.minlength = 0;
                    cfg_stages          = ft_definetrial(cfg);
                    
                    for eventInd = 1:length(cfg_stages.event)
                        comInd(eventInd) = strcmp(cfg_stages.event(eventInd).type,'Comment');
                    end
                    cfg_stages.event(find(comInd==1)) = [];
                    cfg_stages.event(1) = [];
                    
                    for sample = 1:length(cfg_stages.event)
                        cfg_stages.event(sample).duration = fs * epochLength;
                    end
                    
                    for trl = 1:length(cfg_stages.event)
                        cfg_stages.trl(trl,1) = cfg_stages.event(trl).sample;
                        cfg_stages.trl(trl,2) = cfg_stages.event(trl).sample + cfg_stages.event(trl).duration;
                        cfg_stages.trl(trl,3) = 0;
                    end
                    data = ft_redefinetrial(cfg_stages,data);
                    
                    disp('Segmenting data')
                    cfg = [];
                    cfg.dataset              = fnHDRb;
                    cfg.trialfun             = 'ft_trialfun_general';
                    cfg.trialdef.triallength = 10;                      % duration in seconds
                    cfg.trialdef.ntrials     = inf;                    % number of trials, inf results in as many as possible
                    clear cfg.event
                    cfg.event = cfg_stages.event;
                    cfg                      = ft_definetrial(cfg);
                    
                    % read the data from disk and segment it into 10-second pieces
                    data           = ft_redefinetrial(cfg, data);
                    
                    disp(sprintf('Saving data for subject %s, session %sb', subID{i}, sess{j}))
                    save(fnOUTb,'data')
                    disp('Done')
                catch
                    disp(sprintf('Something went wrong. Segmentation for subject %s, session %sb failed',...
                        subID{i}, sess{j}))
                end
            else
                disp(sprintf('Sleep staging has not been completed for subject %s, session %sb yet,',...
                    'so this step cannot be performed', subID{i}, sess{j}))
            end
        else
            disp(sprintf('Segmentation has already been done for subject %s, session %sb',...
                subID{i}, sess{j}))
        end
        
        if ~exist(fnOUTc)
            if exist(sprintf('%s/%s/%s_%sc.txt',pn.data,subID{i},subID{i},sess{j}))
                try
                    disp(sprintf('Loading data for subject %s, session %sc',subID{i}, sess{j}))
                    load(fnINc)
                    
                    disp('Removing EMG channels')
                    %Remove EMG channels (not needed)
                    cfg = [];
                    cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                    data = ft_selectdata(cfg,data);
                    
                    disp('Loading markers and setting up marker structure')
                    cfg = [];
                    cfg.dataset             = fnHDRc;
                    cfg.trialdef.eventtype = 'Stage';
                    cfg.trialdef.eventvalue = {' N1', ' N2', ' N3', ' N4', ' REM', ' Wa', ' Mov'};
                    cfg_stages.minlength = 0;
                    cfg_stages          = ft_definetrial(cfg);
                    
                    for eventInd = 1:length(cfg_stages.event)
                        comInd(eventInd) = strcmp(cfg_stages.event(eventInd).type,'Comment');
                    end
                    cfg_stages.event(find(comInd==1)) = [];
                    cfg_stages.event(1) = [];
                    
                    for sample = 1:length(cfg_stages.event)
                        cfg_stages.event(sample).duration = fs * epochLength;
                    end
                    
                    for trl = 1:length(cfg_stages.event)
                        cfg_stages.trl(trl,1) = cfg_stages.event(trl).sample;
                        cfg_stages.trl(trl,2) = cfg_stages.event(trl).sample + cfg_stages.event(trl).duration;
                        cfg_stages.trl(trl,3) = 0;
                    end
                    data = ft_redefinetrial(cfg_stages,data);
                    
                    disp('Segmenting data')
                    cfg = [];
                    cfg.dataset              = fnHDRc;
                    cfg.trialfun             = 'ft_trialfun_general';
                    cfg.trialdef.triallength = 10;                      % duration in seconds
                    cfg.trialdef.ntrials     = inf;                    % number of trials, inf results in as many as possible
                    clear cfg.event
                    cfg.event = cfg_stages.event;
                    cfg                      = ft_definetrial(cfg);
                    
                    % read the data from disk and segment it into 10-second pieces
                    data           = ft_redefinetrial(cfg, data);
                    
                    disp(sprintf('Saving data for subject %s, session %sc', subID{i}, sess{j}))
                    save(fnOUTc,'data')
                    disp('Done')
                catch
                    disp(sprintf('Something went wrong. Segmentation for subject %s, session %sc failed',...
                        subID{i}, sess{j}))
                end
            else
                disp(sprintf('Sleep staging has not been completed for subject %s, session %sc yet,',...
                    'so this step cannot be performed', subID{i}, sess{j}))
            end
        else
            disp(sprintf('Segmentation has already been done for subject %s, session %sc',...
                subID{i}, sess{j}))
        end
        
        if ~exist(fnOUT_2)
            if exist(sprintf('%s/%s/%s_%s_2.txt',pn.data,subID{i},subID{i},sess{j}))
                try
                    disp(sprintf('Loading data for subject %s, session %s_2',subID{i}, sess{j}))
                    load(fnIN_2)
                    
                    disp('Removing EMG channels')
                    %Remove EMG channels (not needed)
                    cfg = [];
                    cfg.channel = ft_channelselection({'all' '-MovLi','-MovRe'}, data.label);
                    data = ft_selectdata(cfg,data);
                    
                    disp('Loading markers and setting up marker structure')
                    cfg = [];
                    cfg.dataset             = fnHDR_2;
                    cfg.trialdef.eventtype = 'Stage';
                    cfg.trialdef.eventvalue = {' N1', ' N2', ' N3', ' N4', ' REM', ' Wa', ' Mov'};
                    cfg_stages.minlength = 0;
                    cfg_stages          = ft_definetrial(cfg);
                    
                    for eventInd = 1:length(cfg_stages.event)
                        comInd(eventInd) = strcmp(cfg_stages.event(eventInd).type,'Comment');
                    end
                    cfg_stages.event(find(comInd==1)) = [];
                    cfg_stages.event(1) = [];
                    
                    for sample = 1:length(cfg_stages.event)
                        cfg_stages.event(sample).duration = fs * epochLength;
                    end
                    
                    for trl = 1:length(cfg_stages.event)
                        cfg_stages.trl(trl,1) = cfg_stages.event(trl).sample;
                        cfg_stages.trl(trl,2) = cfg_stages.event(trl).sample + cfg_stages.event(trl).duration;
                        cfg_stages.trl(trl,3) = 0;
                    end
                    data = ft_redefinetrial(cfg_stages,data);
                    
                    disp('Segmenting data')
                    cfg = [];
                    cfg.dataset              = fnHDR_2;
                    cfg.trialfun             = 'ft_trialfun_general';
                    cfg.trialdef.triallength = 10;                      % duration in seconds
                    cfg.trialdef.ntrials     = inf;                    % number of trials, inf results in as many as possible
                    clear cfg.event
                    cfg.event = cfg_stages.event;
                    cfg                      = ft_definetrial(cfg);
                    
                    % read the data from disk and segment it into 10-second pieces
                    data           = ft_redefinetrial(cfg, data);
                    
                    disp(sprintf('Saving data for subject %s, session %s_2', subID{i}, sess{j}))
                    save(fnOUT_2,'data')
                    disp('Done')
                catch
                    disp(sprintf('Something went wrong. Segmentation for subject %s, session %s_2 failed',...
                        subID{i}, sess{j}))
                end
            else
                disp(sprintf('Sleep staging has not been completed for subject %s, session %s_2 yet,',...
                    'so this step cannot be performed', subID{i}, sess{j}))
            end
        else
            disp(sprintf('Segmentation has already been done for subject %s, session %s_2',...
                subID{i}, sess{j}))
        end
    end
end
