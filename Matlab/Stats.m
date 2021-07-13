%% Prep subject avgs 


subjectlist = dir('K:\MEGdata\allsubjects\*.m');
%remove unneeded fields from structure; rename variable to avg 
for k=1:length(subjectlist)
    
    %set up the subject info 
    x = subjectlist(k).name;
    run(x)
    subject = ['sub' subjectdata.subjectnr];
    fdir = 'K:\MEGdata\finaldata';
    
    message = 'Now loading %s ... \n';
    fprintf(message,subject)
    
    load ([fdir filesep subject filesep subject '_early'])
    load ([fdir filesep subject filesep subject '_late'])
     
    %Fischer Z-transform the correlations 
    early.sem = atanh(early.sem);
    early.phon = atanh(early.phon);
    late.sem = atanh(late.sem);
    late.phon = atanh(late.phon);
   
    disp('Done transforming correlations!') 
    
   %select timewindow
    time = early.time{1,1};
    timewindow = time < 1.005 & time > -0.2020; %for some reason 0.2 doesn't work
    
    %loop to clean the time dimension for the stats 
%     for j=1:length(early.time)
%         early.time{1,j} = early.time{1,j}(timewindow);
%     end
%    clear j
%    
%     for j=1:length(late.time)
%         late.time{1,j} = late.time{1,j}(timewindow);
%     end
%     
    disp ('Finished selecting timewindow')
    
    %save as a structure 
    subj.Ephon.avg = early.phon(timewindow);
    subj.Ephon.time = early.time{1,1}(timewindow);
    subj.Ephon.dimord = 'chan_time';
    subj.Ephon.label = {'1'};
    subj.Ephon.subj = subject;
    subj.Esem.avg = early.sem(timewindow);
    subj.Esem.time = early.time{1,1}(timewindow);
    subj.Esem.dimord = 'chan_time';
    subj.Esem.label = {'1'};
    subj.Esem.subj = subject;
    subj.Lphon.avg = late.phon(timewindow);
    subj.Lphon.time = late.time{1,1}(timewindow);
    subj.Lphon.label = {'1'};
    subj.Lphon.dimord = 'chan_time';
    subj.Lphon.subj = subject;
    subj.Lsem.avg = late.sem(timewindow);
    subj.Lsem.time = late.time{1,1}(timewindow);
    subj.Lsem.dimord = 'chan_time';
    subj.Lsem.label = {'1'};
    subj.Lsem.subj = subject;
    
    disp('Saving correlations to final output structure :D')
    
    avg_Ephon{k} = subj.Ephon;
    avg_Esem{k} = subj.Esem;
    avg_Lphon{k} = subj.Lphon;
    avg_Lsem{k} = subj.Lsem;
    
    clear subj early late 
end

% Save the compiled data structures
save([fdir filesep 'avg_Esem'], 'avg_Esem');
save([fdir filesep 'avg_Ephon'], 'avg_Ephon');
save([fdir filesep 'avg_Lsem'], 'avg_Lsem');
save([fdir filesep 'avg_Lphon'], 'avg_Lphon');

%% Attempting grand avg 

cfg = [];
cfg.keepindividual = 'yes'; 
cfg.parameter = 'avg';
grandavg_Ephon = ft_timelockgrandaverage(cfg, avg_Ephon{:});
grandavg_Esem = ft_timelockgrandaverage(cfg, avg_Esem{:});
grandavg_Lphon = ft_timelockgrandaverage(cfg, avg_Lphon{:});
grandavg_Lsem = ft_timelockgrandaverage(cfg, avg_Lsem{:});

%create H0 variable 

H0 = grandavg_Ephon;
H0.individual(:,:,:) = zeros(14, 1, length(H0.time));

%% smooth data before stats 

%store old values 
grandavg_Ephon.old = grandavg_Ephon.individual;
grandavg_Esem.old = grandavg_Esem.individual;
grandavg_Lphon.old = grandavg_Lphon.individual;
grandavg_Lsem.old = grandavg_Lsem.individual; 

%smooth values

grandavg_Ephon.individual = smoothdata(grandavg_Ephon.individual,3, 'movmean', [2 2]);
grandavg_Esem.individual = smoothdata(grandavg_Esem.individual,3, 'movmean', [2 2]);
grandavg_Lphon.individual = smoothdata(grandavg_Lphon.individual,3, 'movmean', [2 2]);
grandavg_Lsem.individual = smoothdata(grandavg_Lsem.individual,3, 'movmean', [2 2]); 

save([fdir filesep 'grandavg_Esem'], 'grandavg_Esem');
save([fdir filesep 'grandavg_Ephon'], 'grandavg_Ephon');
save([fdir filesep 'grandavg_Lsem'], 'grandavg_Lsem');
save([fdir filesep 'grandavg_Lphon'], 'grandavg_Lphon');
%% cluster-based permutation 

cfg = [];
cfg.parameter        = 'individual'; 
cfg.method           = 'montecarlo';
cfg.statistic        = 'depsamplesT'; %comparing chosen pairs 
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum'; 
cfg.tail             = 0; %means two-sided 
cfg.clustertail      = 0; 
cfg.alpha            = 0.025;
cfg.numrandomization = 10000;  %maybe up to 10000? 
cfg.neighbours = []; %clustering only over time


Nsubj  = length(subjectlist);
design = zeros(2, Nsubj*2);
design(1,:) = [1:Nsubj 1:Nsubj]; %two 'conditions' at a time
design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];

cfg.design = design;
cfg.uvar   = 1;
cfg.ivar   = 2;

Cphon = ft_timelockstatistics(cfg, grandavg_Ephon, grandavg_Lphon);
Csem = ft_timelockstatistics(cfg, grandavg_Esem, grandavg_Lsem);
Clate = ft_timelockstatistics(cfg, grandavg_Lphon, grandavg_Lsem);
Cearly = ft_timelockstatistics(cfg, grandavg_Ephon, grandavg_Esem);

nullEphon = ft_timelockstatistics(cfg, grandavg_Ephon, H0);
nullEsem = ft_timelockstatistics(cfg, grandavg_Esem, H0);
nullLphon = ft_timelockstatistics(cfg, grandavg_Lphon, H0);
nullLsem = ft_timelockstatistics(cfg, grandavg_Lsem, H0);

% save([fdir filesep 'Cphon'], 'Cphon');
% save([fdir filesep 'Csem'], 'Csem');
% save([fdir filesep 'Clate'], 'Clate');
% save([fdir filesep 'Cearly'], 'Cearly');
% save([fdir filesep 'nullEphon'], 'nullEphon');
% save([fdir filesep 'nullEsem'], 'nullEsem');
% save([fdir filesep 'nullLphon'], 'nullLphon');
% save([fdir filesep 'nullLsem'], 'nullLsem');
%% gen window stats: mean correlation 

subjectlist = dir('K:\MEGdata\allsubjects\*.m');
%Load subject details 
for b=1:length(subjectlist)
    x = subjectlist(b).name;
    run(x)
    subject = ['sub' subjectdata.subjectnr];
    fdir = 'K:\MEGdata\finaldata';
    message = 'Loading %s ... \n';
    fprintf(message, subject)
    
    load([fdir filesep subject filesep subject '_early']);
    load([fdir filesep subject filesep subject '_late']);

    % Fischer Z-transform and smooth the correlations 
    early.sem = atanh(early.sem);
    early.phon = atanh(early.phon);
    late.sem = atanh(late.sem);
    late.phon = atanh(late.phon);
    
    disp('Correlations corrected')
    
    time = early.time{1,1};
    timewindow = time < 1.005 & time >= 0; 
    Esem = early.sem(timewindow);
    Ephon = early.phon(timewindow);
    Lsem = late.sem(timewindow);
    Lphon = late.phon(timewindow);
    
    disp('Time selected')
    
    % create subject mean correlation
    Modelfit.Esem = mean(Esem); 
    Modelfit.Ephon = mean(Ephon);
    Modelfit.Lsem = mean(Lsem);
    Modelfit.Lphon = mean(Lphon);

    save([fdir filesep subject filesep subject '_modelfit'], 'Modelfit');
    
    allsubEsem(b)   = smoothdata(Modelfit.Esem,2, 'movmean', [2 2]);
    allsubEphon(b)  = smoothdata(Modelfit.Ephon,2, 'movmean', [2 2]);
    allsubLsem(b)   = smoothdata(Modelfit.Lsem,2, 'movmean', [2 2]);
    allsubLphon(b)  = smoothdata(Modelfit.Lphon,2, 'movmean', [2 2]);
    
    disp('Finished adding to final structure. Moving onto next subject')
    clear early late
end
save([fdir filesep 'allsubEsem'], 'allsubEsem');
save([fdir filesep 'allsubEphon'], 'allsubEphon');
save([fdir filesep 'allsubEphon'], 'allsubEphon');
save([fdir filesep 'allsubLphon'], 'allsubLphon');
%% make combined clusters 

Cphon.clusters = [Cphon.posclusters, Cphon.negclusters];
Csem.clusters = [Csem.posclusters, Csem.negclusters];
Cearly.clusters = [Cearly.posclusters, Cearly.negclusters];
Clate.clusters = [Clate.posclusters, Clate.negclusters];
nullLphon.clusters = [nullLphon.posclusters, nullLphon.negclusters];
nullLsem.clusters = [nullLsem.posclusters, nullLsem.negclusters];
nullEphon.clusters = [nullEphon.posclusters, nullEphon.negclusters];
nullEsem.clusters = [nullEsem.posclusters, nullEsem.negclusters];


%% make combined clusters 

% var = {nullLphon,nullLsem, nullEphon, nullEsem};
 var = {Cphon,Csem, Cearly, Clate};
% find the times for all the clusters 
for i=1:1
    idx = var{1,i}.posclusterslabelmat > 0;
    idx2 = var{1,i}.negclusterslabelmat > 0;
    var{1,i}.postimes = var{1,i}.time(idx);
    var{1,i}.negtimes = var{1,i}.time(idx2);
    var{1,i}.prob(2,:)= var{1,i}.time;
end
%% test model fit whole window

[Phon, p] = ttest(allsubEphon, allsubLphon);
[Sem, p2] = ttest(allsubEsem, allsubLsem);
[LSemPhon, p3] = ttest(allsubLsem, allsubLphon);
[EPhonSem, p4] = ttest(allsubEsem, allsubEphon);

H0 = zeros(1,length(allsubEphon));

[nullPhon, p5] = ttest(allsubEphon, H0);
[nullSem, p6] = ttest(allsubEsem, H0);
[nullLSemPhon, p7] = ttest(allsubLsem, H0);
[nullEPhonSem, p8] = ttest(allsubLphon, H0);

%% create erps; not used

subjectlist = dir('K:\MEGdata\allsubjects\*.m');
%remove unneeded fields from structure; rename variable to avg 
for k=1:length(subjectlist)
    
    %set up the subject info 
    x = subjectlist(k).name;
    run(x)
    subject = ['sub' subjectdata.subjectnr];
    fdir = 'K:\MEGdata\finaldata';
    
    message = 'Now loading %s ... \n';
    fprintf(message,subject)
    
    load ([fdir filesep subject filesep subject '_early'])
    load ([fdir filesep subject filesep subject '_late'])
    allsubavg_early{k} = early;
    allsubavg_late{k} = late;
    
    disp('Done loading subject... Moving onto next one...')
    clear early late 
end
