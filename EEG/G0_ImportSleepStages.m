% Load sleepstaging *.txt files created with SchlafAus and write the
% markers into each subject's and session's *.vmrk file. This is necessary
% in order to be able to import the sleepstaging markers into FieldTrip

clear all
close all
clc

pn.data = '../B2_Data';

s = struct2cell(dir(pn.data));
subID = cell(1, size(s,2)-2);
for i = 1:size(subID,2)
    subID{1,i} = s{1,i+2};
end
clear s

sess = {'T0','T1','T2','T3','T4','T5','T6','T7','T8'};

for i = 1:length(subID)
    for j = 1:length(sess)
        if exist(sprintf('%s/%s/%s_%s.vmrk',pn.data,subID{i},subID{i},sess{j})) % Check whether 
                                                                                % subject has a valid marker file
                                                                                
            % Import subject marker file                                                                    
            bva = importfile(sprintf('%s/%s/%s_%s.vmrk',pn.data,subID{i},subID{i},sess{j}));
                 
            if ~isempty(bva)
                str2compare = table2cell(bva(1,'Mk2Comment')); % Get first marker in file
            else
                str2compare = "Empty";
            end
            
            % Check whether sleepstaging markers have already been added,
            % if not, add them
            if ~strcmp(str2compare{1},"Mk3=Stage")
                
                % Check whether sleepstaging file exists for this subject
                % and session
                if exist(sprintf('%s/%s/%s_%s.txt',pn.data,subID{i},subID{i},sess{j}))
                    
                    disp(sprintf('Loading text sleep markers for subject %s, session %s',subID{i},sess{j}))
                    markers = load(sprintf('%s/%s/%s_%s.txt',pn.data,subID{i},subID{i},sess{j}));
                    
                    sampleInd = 1; %Starting index in data points
                    fs = 500; %Sampling rate
                    epochLength = 30; %Sleepstaging epoch length in seconds
                    for ind = 1:size(markers,1)
                        markerCode = markers(ind,1);
                        switch markerCode
                            case 0
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Wa, %i, 1, O2',ind + 2, sampleInd);
                            case 1
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N1, %i, 1, O2',ind + 2, sampleInd);
                            case 2
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N2, %i, 1, O2',ind + 2, sampleInd);
                            case 3
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N3, %i, 1, O2',ind + 2, sampleInd);
                            case 4
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N4, %i, 1, O2',ind + 2, sampleInd);
                            case 5
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, REM, %i, 1, O2',ind + 2, sampleInd);
                            case 8
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Mov, %i, 1, O2',ind + 2, sampleInd);
                        end
                        sampleInd = sampleInd + fs * epochLength;
                    end
                    
                    % Delete response markers
                    % Read the file
                    fid = fopen(sprintf('%s/%s/%s_%s.vmrk',pn.data,subID{i},subID{i},sess{j}), 'r');
                    str = textscan(fid,'%s','Delimiter','\n');
                    fclose(fid);
                    % Extract first 13 lines
                    str2 = str{1}(1:13);
                    % Save as a text file
                    fid2 = fopen(sprintf('%s/%s/%s_%s.vmrk',pn.data,subID{i},subID{i},sess{j}),'w');
                    fprintf(fid2,'%s\n', str2{:});
                    fclose(fid2);
                    clear str str2


                    fid = fopen(sprintf('%s/%s/%s_%s.vmrk',pn.data,subID{i},subID{i},sess{j}), 'a+');
                    for ind = 1:size(bvaMarkers,1)
                        fprintf(fid, '%s\n', bvaMarkers{ind});
                    end
                    fclose(fid);
                else
                    disp(sprintf('Sleep markers for subject %s, session %s do not exist',subID{i},sess{j}))
                    
                end
            end

        elseif exist(sprintf('%s/%s/%s_%sb.vmrk',pn.data,subID{i},subID{i},sess{j})) % Check whether 
                                                                                % subject has a valid marker file
                                                                                
            % Import subject marker file                                                                    
            bva = importfile(sprintf('%s/%s/%s_%sb.vmrk',pn.data,subID{i},subID{i},sess{j}));
                 
            if ~isempty(bva)
                str2compare = table2cell(bva(1,'Mk2Comment')); % Get first marker in file
            else
                str2compare = "Empty";
            end
            
            % Check whether sleepstaging markers have already been added,
            % if not, add them
            if ~strcmp(str2compare{1},"Mk3=Stage")
                
                % Check whether sleepstaging file exists for this subject
                % and session
                if exist(sprintf('%s/%s/%s_%sb.txt',pn.data,subID{i},subID{i},sess{j}))
                    
                    disp(sprintf('Loading text sleep markers for subject %s, session %sb',subID{i},sess{j}))
                    markers = load(sprintf('%s/%s/%s_%sb.txt',pn.data,subID{i},subID{i},sess{j}));
                    
                    sampleInd = 1; %Starting index in data points
                    fs = 500; %Sampling rate
                    epochLength = 30; %Sleepstaging epoch length in seconds
                    for ind = 1:size(markers,1)
                        markerCode = markers(ind,1);
                        switch markerCode
                            case 0
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Wa, %i, 1, O2',ind + 2, sampleInd);
                            case 1
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N1, %i, 1, O2',ind + 2, sampleInd);
                            case 2
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N2, %i, 1, O2',ind + 2, sampleInd);
                            case 3
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N3, %i, 1, O2',ind + 2, sampleInd);
                            case 4
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N4, %i, 1, O2',ind + 2, sampleInd);
                            case 5
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, REM, %i, 1, O2',ind + 2, sampleInd);
                            case 8
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Mov, %i, 1, O2',ind + 2, sampleInd);
                        end
                        sampleInd = sampleInd + fs * epochLength;
                    end
                    
                    % Delete response markers
                    % Read the file
                    fid = fopen(sprintf('%s/%s/%s_%sb.vmrk',pn.data,subID{i},subID{i},sess{j}), 'r');
                    str = textscan(fid,'%s','Delimiter','\n');
                    fclose(fid);
                    % Extract first 13 lines
                    str2 = str{1}(1:13);
                    % Save as a text file
                    fid2 = fopen(sprintf('%s/%s/%s_%sb.vmrk',pn.data,subID{i},subID{i},sess{j}),'w');
                    fprintf(fid2,'%s\n', str2{:});
                    fclose(fid2);
                    clear str str2


                    fid = fopen(sprintf('%s/%s/%s_%sb.vmrk',pn.data,subID{i},subID{i},sess{j}), 'a+');
                    for ind = 1:size(bvaMarkers,1)
                        fprintf(fid, '%s\n', bvaMarkers{ind});
                    end
                    fclose(fid);
                end
            end   

        elseif exist(sprintf('%s/%s/%s_%sc.vmrk',pn.data,subID{i},subID{i},sess{j})) % Check whether 
                                                                                % subject has a valid marker file
                                                                                
            % Import subject marker file                                                                    
            bva = importfile(sprintf('%s/%s/%s_%sc.vmrk',pn.data,subID{i},subID{i},sess{j}));
                 
            if ~isempty(bva)
                str2compare = table2cell(bva(1,'Mk2Comment')); % Get first marker in file
            else
                str2compare = "Empty";
            end
            
            % Check whether sleepstaging markers have already been added,
            % if not, add them
            if ~strcmp(str2compare{1},"Mk3=Stage")
                
                % Check whether sleepstaging file exists for this subject
                % and session
                if exist(sprintf('%s/%s/%s_%sc.txt',pn.data,subID{i},subID{i},sess{j}))
                    
                    disp(sprintf('Loading text sleep markers for subject %s, session %sc',subID{i},sess{j}))
                    markers = load(sprintf('%s/%s/%s_%sc.txt',pn.data,subID{i},subID{i},sess{j}));
                    
                    sampleInd = 1; %Starting index in data points
                    fs = 500; %Sampling rate
                    epochLength = 30; %Sleepstaging epoch length in seconds
                    for ind = 1:size(markers,1)
                        markerCode = markers(ind,1);
                        switch markerCode
                            case 0
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Wa, %i, 1, O2',ind + 2, sampleInd);
                            case 1
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N1, %i, 1, O2',ind + 2, sampleInd);
                            case 2
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N2, %i, 1, O2',ind + 2, sampleInd);
                            case 3
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N3, %i, 1, O2',ind + 2, sampleInd);
                            case 4
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, N4, %i, 1, O2',ind + 2, sampleInd);
                            case 5
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, REM, %i, 1, O2',ind + 2, sampleInd);
                            case 8
                                bvaMarkers{ind,1} = sprintf('Mk%i=Stage, Mov, %i, 1, O2',ind + 2, sampleInd);
                        end
                        sampleInd = sampleInd + fs * epochLength;
                    end
                    
                    % Delete response markers
                    % Read the file
                    fid = fopen(sprintf('%s/%s/%s_%sc.vmrk',pn.data,subID{i},subID{i},sess{j}), 'r');
                    str = textscan(fid,'%s','Delimiter','\n');
                    fclose(fid);
                    % Extract first 13 lines
                    str2 = str{1}(1:13);
                    % Save as a text file
                    fid2 = fopen(sprintf('%s/%s/%s_%sc.vmrk',pn.data,subID{i},subID{i},sess{j}),'w');
                    fprintf(fid2,'%s\n', str2{:});
                    fclose(fid2);
                    clear str str2


                    fid = fopen(sprintf('%s/%s/%s_%sc.vmrk',pn.data,subID{i},subID{i},sess{j}), 'a+');
                    for ind = 1:size(bvaMarkers,1)
                        fprintf(fid, '%s\n', bvaMarkers{ind});
                    end
                    fclose(fid);
                end
            end
        end
        clear bvaMarkers fid fid2 markers
    end
end
