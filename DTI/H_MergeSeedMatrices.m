% This script takes as input the SC and LEN matrices resulting from each
% seed run of FSL probtrackX (probabilistic tractography), merges them and
% saves the results
% Written by Cristiana Dimulescu on 06.09.2019

clear all
close all
clc

pn.subj = '../../B_Data/C_FSLPreproc/';

subjDirTemp = dir(pn.subj);
[subjDir(1:numel(subjDirTemp(3:end))).name] = subjDirTemp(3:end).name;
clear subjDirTemp


nregion = 94;

for i = 25:numel(subjDir)
    
    pn.seed = sprintf('%s%s/DTI/G_ProbtrackX',pn.subj,subjDir(i).name);
    seedDirTemp = dir(pn.seed);
    [seedDir(1:numel(seedDirTemp(3:end))).name] = seedDirTemp(3:end).name;
    clear seedDirTemp
    
    sc = zeros(nregion, nregion);
    len = zeros(nregion, nregion);
    for j = 1:numel(seedDir)
        tempSC = load(sprintf('%s/%s/fdt_network_matrix', ...
            pn.seed, seedDir(j).name));
        tempLEN = load(sprintf('%s/%s/fdt_network_matrix_lengths', pn.seed, ...
            seedDir(j).name));
        
        sc = sc + tempSC;
        clear tempSC
        
        len = len + tempLEN;
        clear tempLEN
    end
    len = len / numel(seedDir);
    
    save(sprintf('%s/fdt_network_matrix_full.mat', pn.seed), 'sc')
    save(sprintf('%s/fdt_network_matrix_lengths_full.mat', pn.seed), 'len')
end
