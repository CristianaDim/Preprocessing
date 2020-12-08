% Loads specific EEG files and plots individual IC time
% courses and power spectra
clear all
close all
clc

pn.fieldtrip = '../Z_Tools/fieldtrip-20190419/';
pn.data = '../B2_Data/';
pn.figures = '../C_Figures/ICAComponents';

addpath(pn.fieldtrip);  

s = struct2cell(dir(pn.data));
subID = cell(1, size(s,2)-2);
for i = 1:size(subID,2)
    subID{1,i} = s{1,i+2};
end
clear s

sess = {'T0','T1','T2','T3','T4','T5','T6','T7','T8'};
ncomp = 30;

sID = 10; % subject number
sesID = 6; % session number

for i = sID
    for j = sesID
        fnIN = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_preICAfilt_insp_ICA.mat'];
        fnINb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_preICAfilt_insp_ICA.mat'];
        fnINc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_preICAfilt_insp_ICA.mat'];
        fnIN_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_preICAfilt_insp_ICA.mat'];
        fnOUT = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUTb = [pn.data,subID{i},'/',subID{i},'_',sess{j},'b_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUTc = [pn.data,subID{i},'/',subID{i},'_',sess{j},'c_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        fnOUT_2 = [pn.data,subID{i},'/',subID{i},'_',sess{j},'_2_postICAfilt_segStage_10sec_ICAsubtr.mat'];
        
        if ~exist(fnOUT)
            try
                load(fnIN); 
                disp(sprintf('Inspecting ICA for subject %s, session %s',subID{i},sess{j}))
      
                cfg = [];
                cfg.method = 'linear';
                cfg.prewindow = 0.01;
                cfg.postwindow = 0.01;
                
                % Used to interpolate when the last second of data was also
                % removed
                try
                    [dum, idx_end_c] = find(diff(isnan(comp.trial{1,1}(:,:)), [], 2)==1);
                    comp_to_interp = comp;
                    comp_to_interp.trial{1,1} = comp.trial{1,1}(:,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.time{1,1} = comp.time{1,1}(1,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.sampleinfo = [1,idx_end_c(size(idx_end_c,1))-500];
                    clear comp
                end
                
                % Interpolate
                outcomp = ft_interpolatenan(cfg, comp_to_interp);
                
                % Get power spectrum for all components
                cfg              = [];
                cfg.output       = 'pow';
                cfg.channel      = 'all'; % compute the power spectrum in all ICs
                cfg.method       = 'mtmfft';
                cfg.taper        = 'hanning';
                cfg.foi          = 1:1:100;
                
                
                freq = ft_freqanalysis(cfg, outcomp);
                
                % Plot time courses for all components
                cfg = [];
                cfg.viewmode = 'component';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, outcomp)
                
                % Plot each component for visual inspection
                for k = 1:ncomp
                    f = figure
                    cfg = [];
                    cfg.component = k;       % specify the component(s) that should be plotted
                    if j < 3
                        cfg.layout = 'eegTemplateNoStim.txt';
                    else
                        cfg.layout = 'eegTemplateStim.txt';
                    end % specify the layout file that should be used for plotting
                    cfg.comment   = 'no';
                    cfg.colormap = 'jet';
                    subplot(1,2,1);
                    ft_topoplotIC(cfg, outcomp) % plot topo for component
                     
                    cfg = [];
                    cfg.channel = k;
                    subplot(1,2,2);
                    
                    ft_singleplotER(cfg,freq);
                    if k < 10
                        savefig(f,sprintf('%s/%s_%s_IC0%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%s_IC0%i.png',pn.figures,subID{i},sess{j},k))
                    else
                        savefig(f,sprintf('%s/%s_%s_IC%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%s_IC%i.png',pn.figures,subID{i},sess{j},k))
                    end
                    pause
                end
                
            end
        end
        
        if ~exist(fnOUTb)
            try
                load(fnINb);
                disp(sprintf('Inspecting ICA for subject %s, session %sb',subID{i},sess{j}))
                
                cfg = [];
                cfg.method = 'linear';
                cfg.prewindow = 0.1;
                cfg.postwindow = 0.1;
                
                % Used to interpolate when the last second of data was also
                % removed
                try
                    [dum, idx_end_c] = find(diff(isnan(comp.trial{1,1}(:,:)), [], 2)==1);
                    comp_to_interp = comp;
                    comp_to_interp.trial{1,1} = comp.trial{1,1}(:,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.time{1,1} = comp.time{1,1}(1,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.sampleinfo = [1,idx_end_c(size(idx_end_c,1))-500];
                    clear comp
                end
                
                outcomp = ft_interpolatenan(cfg, comp_to_interp);
                
                % Get power spectrum for all components
                cfg              = [];
                cfg.output       = 'pow';
                cfg.channel      = 'all';%compute the power spectrum in all ICs
                cfg.method       = 'mtmfft';
                cfg.taper        = 'hanning';
                cfg.foi          = 1:1:100;
                
                freq = ft_freqanalysis(cfg, outcomp);
                
                % Plot time courses for all components
                cfg = [];
                cfg.viewmode = 'component';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, outcomp)
                
                % Plot each component for visual inspection
                for k = 1:ncomp
                    f = figure
                    cfg = [];
                    cfg.component = k;       % specify the component(s) that should be plotted
                    if j < 3
                        cfg.layout = 'eegTemplateNoStim.txt';
                    else
                        cfg.layout = 'eegTemplateStim.txt';
                    end % specify the layout file that should be used for plotting
                    cfg.comment   = 'no';
                    cfg.colormap = 'jet';
                    subplot(1,2,1);
                    ft_topoplotIC(cfg, outcomp) % plot topo for component
                    
                    cfg = [];
                    cfg.channel = k;
                    subplot(1,2,2);
                    
                    ft_singleplotER(cfg,freq);
                    if k < 10
                        savefig(f,sprintf('%s/%s_%sb_IC0%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%sb_IC0%i.png',pn.figures,subID{i},sess{j},k))
                    else
                        savefig(f,sprintf('%s/%s_%sb_IC%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%sb_IC%i.png',pn.figures,subID{i},sess{j},k))
                    end
                    pause
                end
                
            end
        end
        
        if ~exist(fnOUTc)
            try
                load(fnINc);
                disp(sprintf('Inspecting ICA for subject %s, session %sc',subID{i},sess{j}))
                
                cfg = [];
                cfg.method = 'linear';
                cfg.prewindow = 0.1;
                cfg.postwindow = 0.1;
                
                % Used to interpolate when the last second of data was also
                % removed
                try
                    [dum, idx_end_c] = find(diff(isnan(comp.trial{1,1}(:,:)), [], 2)==1);
                    comp_to_interp = comp;
                    comp_to_interp.trial{1,1} = comp.trial{1,1}(:,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.time{1,1} = comp.time{1,1}(1,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.sampleinfo = [1,idx_end_c(size(idx_end_c,1))-500];
                    clear comp
                end
                
                outcomp = ft_interpolatenan(cfg, comp_to_interp);
                
                % Get power spectrum for all components
                cfg              = [];
                cfg.output       = 'pow';
                cfg.channel      = 'all'; % compute the power spectrum in all ICs
                cfg.method       = 'mtmfft';
                cfg.taper        = 'hanning';
                cfg.foi          = 1:1:100;
                
                freq = ft_freqanalysis(cfg, outcomp);
                
                % Plot time courses for all components
                cfg = [];
                cfg.viewmode = 'component';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, outcomp)
                
                % Plot each component for visual inspection
                for k = 1:ncomp
                    f = figure;
                    cfg = [];
                    cfg.component = k;       % specify the component(s) that should be plotted
                    if j < 3
                        cfg.layout = 'eegTemplateNoStim.txt';
                    else
                        cfg.layout = 'eegTemplateStim.txt';
                    end % specify the layout file that should be used for plotting
                    cfg.comment   = 'no';
                    cfg.colormap = 'jet';
                    subplot(1,2,1);
                    ft_topoplotIC(cfg, outcomp) % plot topo for component
                    
                    cfg = [];
                    cfg.channel = k;
                    subplot(1,2,2);
                    
                    ft_singleplotER(cfg,freq);
                    if k < 10
                        savefig(f,sprintf('%s/%s_%sc_IC0%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%sc_IC0%i.png',pn.figures,subID{i},sess{j},k))
                    else
                        savefig(f,sprintf('%s/%s_%sc_IC%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%sc_IC%i.png',pn.figures,subID{i},sess{j},k))
                    end
                    pause
                end
                
            end
        end
        
        if ~exist(fnOUT_2)
            try
                load(fnIN_2);
                disp(sprintf('Inspecting ICA for subject %s, session %s_2',subID{i},sess{j}))
                
                cfg = [];
                cfg.method = 'linear';
                cfg.prewindow = 0.1;
                cfg.postwindow = 0.1;
                
                % Used to interpolate when the last second of data was also
                % removed
                try
                    [dum, idx_end_c] = find(diff(isnan(comp.trial{1,1}(:,:)), [], 2)==1);
                    comp_to_interp = comp;
                    comp_to_interp.trial{1,1} = comp.trial{1,1}(:,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.time{1,1} = comp.time{1,1}(1,1:idx_end_c(size(idx_end_c,1))-500);
                    comp_to_interp.sampleinfo = [1,idx_end_c(size(idx_end_c,1))-500];
                    clear comp
                end
                
                outcomp = ft_interpolatenan(cfg, comp_to_interp);
                
                % Get power spectrum for all components
                cfg              = [];
                cfg.output       = 'pow';
                cfg.channel      = 'all'; % compute the power spectrum in all ICs
                cfg.method       = 'mtmfft';
                cfg.taper        = 'hanning';
                cfg.foi          = 1:1:100;
                
                freq = ft_freqanalysis(cfg, outcomp);
                
                % Plot time courses for all components
                cfg = [];
                cfg.viewmode = 'component';
                if j < 3
                    cfg.layout = 'eegTemplateNoStim.txt';
                else
                    cfg.layout = 'eegTemplateStim.txt';
                end
                ft_databrowser(cfg, outcomp)
                
                % Plot each component for visual inspection
                for k = 1:ncomp
                    f = figure
                    cfg = [];
                    cfg.component = k;       % specify the component(s) that should be plotted
                    if j < 3
                        cfg.layout = 'eegTemplateNoStim.txt';
                    else
                        cfg.layout = 'eegTemplateStim.txt';
                    end % specify the layout file that should be used for plotting
                    cfg.comment   = 'no';
                    cfg.colormap = 'jet';
                    subplot(1,2,1);
                    ft_topoplotIC(cfg, outcomp) % plot topo for component
                    
                    cfg = [];
                    cfg.channel = k;
                    subplot(1,2,2);
                    
                    ft_singleplotER(cfg,freq);
                    if k < 10
                        savefig(f,sprintf('%s/%s_%s_2_IC0%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%s_2_IC0%i.png',pn.figures,subID{i},sess{j},k))
                    else
                        savefig(f,sprintf('%s/%s_%s_2_IC%i',pn.figures,subID{i},sess{j},k))
                        saveas(f,sprintf('%s/%s_%s_2_IC%i.png',pn.figures,subID{i},sess{j},k))
                    end
                    pause
                end
                
            end
        end
    end
end
