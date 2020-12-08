% Loads all EEG files recorded in BrainVision format, converts them to
% FieldTrip format and saves the resulting *.mat files
clear all
close all
clc

pn.fieldtrip = '../Z_Tools/fieldtrip-20190419/';
pn.data = '../B2_Data/';

addpath(pn.fieldtrip);

s = struct2cell(dir(pn.data));
subID = cell(1, size(s,2)-2);
for i = 1:size(subID,2)
    subID{1,i} = s{1,i+2};
end
clear s

sess = {'T0','T1','T2','T3','T4','T5','T6','T7','T8'};

for i = 1:length(subID)
    for j = 1:length(sess)
        if ~exist([pn.data,subID{i},'/',subID{i},'_',sess{j},'.mat'])
            disp(sprintf('Importing session %s for subject %s', sess{j}, subID{i}))
            try
                cfg = [];
                cfg.dataset = [pn.data,subID{i},'/',subID{i},'_',sess{j},'.eeg'];
                if ~exist(cfg.dataset)
                     disp(sprintf('Session %s for subject %s does NOT exist. This might be because it is named differently or you have not copied it in the data folder.', sess{j}, subID{i})) 
                     continue
                end
                data = ft_preprocessing(cfg);
                save([pn.data,subID{i},'/',subID{i},'_',sess{j},'.mat'],'data')
                disp(sprintf('Successfuly imported session %s for subject %s', sess{j}, subID{i}))
                clear data
            catch
                disp(sprintf('Importing session %s for subject %s FAILED!', sess{j}, subID{i}))
            end
        else
            disp(sprintf('Already imported session %s for subject %s', sess{j}, subID{i}))
        end

        if ~exist([pn.data,subID{i},'/',subID{i},'_',sess{j},'b.mat'])
            disp(sprintf('Importing session %sb for subject %s', sess{j}, subID{i}))
            try
                cfg = [];
                cfg.dataset = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b.eeg'];
                if ~exist(cfg.dataset)
                     disp(sprintf('Session %sb for subject %s does NOT exist. This might be because it is named differently or you have not copied it in the data folder.', sess{j}, subID{i})) 
                     continue
                end
                data = ft_preprocessing(cfg);
                save([pn.data,subID{i},'/',subID{i},'_',sess{j},'b.mat'],'data')
                disp(sprintf('Successfuly imported session %sb for subject %s', sess{j}, subID{i}))
                clear data
            catch
                disp(sprintf('Importing session %sb for subject %s FAILED!', sess{j}, subID{i}))
            end
        else
            disp(sprintf('Already imported session %sb for subject %s', sess{j}, subID{i}))
        end

        if ~exist([pn.data,subID{i},'/',subID{i},'_',sess{j},'c.mat'])
            disp(sprintf('Importing session %sc for subject %s', sess{j}, subID{i}))
            try
                cfg = [];
                cfg.dataset = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c.eeg'];
                if ~exist(cfg.dataset)
                     disp(sprintf('Session %sc for subject %s does NOT exist. This might be because it is named differently or you have not copied it in the data folder.', sess{j}, subID{i})) 
                     continue
                end
                data = ft_preprocessing(cfg);
                save([pn.data,subID{i},'/',subID{i},'_',sess{j},'c.mat'],'data')
                disp(sprintf('Successfuly imported session %sc for subject %s', sess{j}, subID{i}))
                clear data
            catch
                disp(sprintf('Importing session %sc for subject %s FAILED!', sess{j}, subID{i}))
            end
            else
            disp(sprintf('Already imported session %sc for subject %s', sess{j}, subID{i}))
        end

        if ~exist([pn.data,subID{i},'/',subID{i},'_',sess{j},'_2.mat'])
            try
                cfg = [];
                cfg.dataset = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2.eeg'];
                if ~exist(cfg.dataset)
                     disp(sprintf('Session %s_2 for subject %s does NOT exist. This might be because it is named differently or you have not copied it in the data folder.', sess{j}, subID{i})) 
                     continue
                end
                data = ft_preprocessing(cfg);
                save([pn.data,subID{i},'/',subID{i},'_',sess{j},'_2.mat'],'data')
                disp(sprintf('Successfuly imported session %s_2 for subject %s', sess{j}, subID{i}))
                clear data
            catch
                disp(sprintf('Importing session %s_2 for subject %s FAILED!', sess{j}, subID{i}))
            end
        else
            disp(sprintf('Already imported session %s_2 for subject %s', sess{j}, subID{i}))
        end
    end
end
