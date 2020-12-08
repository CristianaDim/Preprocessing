clear all
close all
clc

pn.subj = '../../B_Data/C_FSLPreproc/';

subjDirTemp = dir(pn.subj);
[subjDir(1:numel(subjDirTemp(3:end))).name] = subjDirTemp(3:end).name;
clear subjDirTemp

nregion = 94;

for ind = 13:numel(subjDir)
    fID = fopen('../../../Z_Tools/AALMasks/masks.txt');
    tline = fgetl(fID);
    i = 1;
    while ischar(tline) && (i <= 94)
        regName{i} = tline;
        i = i + 1;
        tline = fgetl(fID);
    end
    fclose(fID);
    
    for i = 1:nregion
        fpart = split(regName{i},'/');
        fpart2 = split(fpart{10},'.');
        
        tc(i,:) = load(sprintf('%s%s/rsfMRI/B_ExtractedTCs/%s.nii.txt',pn.subj,subjDir(ind).name,fpart2{1}));
    end
    
    for i = 1:nregion
        for j = 1:nregion
            c = corrcoef(tc(i,:),tc(j,:));
            fc(i,j) = c(2);
        end
    end
    
    save(sprintf('%s%s/rsfMRI/B_ExtractedTCs/FC.mat',pn.subj,subjDir(ind).name),'fc')
    save(sprintf('%s%s/rsfMRI/B_ExtractedTCs/TC.mat',pn.subj,subjDir(ind).name),'tc')
        
end