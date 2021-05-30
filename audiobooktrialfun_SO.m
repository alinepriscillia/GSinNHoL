function [trl, event] = audiobooktrialfun_SO(cfg)  

%Opening the MEG file and reading events into memory

baseloc = 'K:\audiobook\';
%dataloc = 'C:\Users\alimes\Desktop\MEGdata\sub001\';

cfg2 = []; %had to make a second one to have it run for batch
%cfg.dataset = [dataloc '\sub001.ds']; 
cfg2.dataset = cfg.dataset;
hdr = ft_read_header(cfg2.dataset);  
event = ft_read_event(cfg2.dataset); 

% read in the MEG audio file
cfg2.channel = 'UADC003';
cfg2.continuous = 'yes';
audch = ft_preprocessing(cfg2);

%Creation of event with small e = cleaned up dataset that can be modified 
sel = find(strcmp({event.type}, 'UPPT001')); %find the story triggers
event = event(sel);

TimingInfo = readtable([baseloc 'wordinfo.csv']);
%load([baseloc 'sub001_info.mat'])

% read in the original .wav files
allwavs = dir([baseloc '*.wav']);
stotype = [1 1 1 1 3 3 2 2 2; 1 2 3 4 1 2 1 2 3]';
for cntwav = 1:length(allwavs)
   [wf1, fs] = audioread([allwavs(cntwav).folder '/' allwavs(cntwav).name]);
   wf{cntwav} = resample(wf1, hdr.Fs, fs);
end

fs = hdr.Fs;

%%
trl = [];
pre = 1;
post = 2.5;
for cntword = 1:height(TimingInfo)
   story = TimingInfo.story(cntword);
   story_part = TimingInfo.story_part(cntword);
   TIS = TimingInfo.start(cntword);
   wordcode = TimingInfo.abswordcode(cntword);
   condition = TimingInfo.condition(cntword);
   
   eppre = 0.5;
   epw = 0.5;
   % epoch the wav file:
   wavcnt = find(stotype(:,1) == story & stotype(:,2) == story_part);
   wavep = wf{wavcnt}(round(TIS*fs-eppre*fs):round(TIS*fs+epw*fs));
   
   % epoch the meg file (audio):
   trinx = find([event.value] == story);
   trinx = event(trinx(story_part)+1).sample;   
   MEGep = audch.trial{1}(round(trinx+TIS*fs-eppre*fs):round(trinx+TIS*fs+epw*fs));
         
   %close all
   %plot(wavep./max(wavep));
   %hold on
   %plot(MEGep./max(MEGep)+1);

   % crosscorrelation to correct
   [xc, lags] = xcorr(wavep, MEGep,'normalized');   
   [mv minx] = max(xc);
   cor = lags(minx);
   
   samfin = trinx+TIS*fs-cor;
   MEGep = audch.trial{1}(round(samfin-eppre*fs):round(samfin+epw*fs));
   
   % crosscorrelation check that now at 0
   [xc, lags] = xcorr(wavep, MEGep,'normalized');   
   [mv minx] = max(xc);
   if abs(lags(minx)) > 5
       error('wrong lag')
   end   
   if mv < 0.5
       warning('low correlation')
   end 
   strl =[round(samfin-pre*fs); round(samfin+post*fs); -pre*fs; wordcode; story; story_part; condition; cor];
   trl = [trl; strl']; %removed cntword but can be reinstalled 
end

