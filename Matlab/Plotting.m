% Plot smoothing and ERPs 
run('sub014.m')

% load subject info
subject = ['sub' subjectdata.subjectnr];
fdir = 'K:\MEGdata\finaldata';
load([subjectdata.subjectdir filesep subject '_finaldata']);
load([subjectdata.subjectdir filesep subject '_layout'], 'layout');

%% create erps 
cfg = []; 
cfg.latency = [-0.2 1];
cfg.trials = find(cleandata2.trialinfo(:,4)== 100);
erpearly = ft_timelockanalysis(cfg, cleandata2);

cfg = []; 
cfg.latency = [-0.2 1];
cfg.trials = find(cleandata2.trialinfo(:,4)== 300);
erplate = ft_timelockanalysis(cfg, cleandata2);

save ([fdir filesep subject '_ERPearly'], 'erpearly', '-v7.3')
save ([fdir filesep subject '_ERPlate'], 'erplate', '-v7.3')

clear cleandata2
%% Plot the erps 
cfg = [];
cfg.showlabels = 'yes';
cfg.fontsize = 6;
cfg.layout = layout;
cfg.baseline = [-0.2 0];
cfg.xlim = [-0.2 1.0];
cfg.ylim = [-0.5e-13 0.5e-13];
cfg.channel = {'MLC16', 'MLC24', 'MLC31', 'MLT12', 'MLT14', 'MLT23', 'MRT13'};
cfg.linecolor = 'bg';
%figure; ft_multiplotER(cfg, erpearly, erplate);
figure; ft_singleplotER(cfg, erpearly, erplate);
legend('Early', 'Late')

%axis on 
%% grand correlations plotted over whole time window 

% load the data and average it 

cfg = [];
cfg.parameter = 'avg';
grandavg_Ephon = ft_timelockgrandaverage(cfg, avg_Ephon{:});
grandavg_Esem = ft_timelockgrandaverage(cfg, avg_Esem{:});
grandavg_Lphon = ft_timelockgrandaverage(cfg, avg_Lphon{:});
grandavg_Lsem = ft_timelockgrandaverage(cfg, avg_Lsem{:});

y1 = smoothdata(grandavg_Ephon.avg,2, 'movmean', [2 2]); %do the stats on the smoothed data too and maybe additionally plot the raw in the appendix!
y2 = smoothdata(grandavg_Lphon.avg,2, 'movmean', [2 2]);
y3 = smoothdata(grandavg_Esem.avg,2, 'movmean', [2 2]); 
y4 = smoothdata(grandavg_Lsem.avg,2, 'movmean', [2 2]);

%% plot early late sem/phon

x = grandavg_Ephon.time;
n = sqrt(grandavg_Ephon.dof(1,1));
n1 = (sqrt(grandavg_Ephon.var))/n;
n2 = (sqrt(grandavg_Lphon.var))/n;
n3 = (sqrt(grandavg_Esem.var))/n;
n4 = (sqrt(grandavg_Lsem.var))/n;

%left 
figure
%clf 
%subplot(1,2,1)
shadedErrorBar(x,y1,n1,'lineProps',{'color','#6cbdfc'});
hold on 
shadedErrorBar(x,y2,n2,'lineProps',{'color','#221ea4'});
legend('Early', 'Late')
hold off

%right 
figure
%subplot(1,2,2)
shadedErrorBar(x,y3,n3,'lineProps',{'color','#e6aa68'});
hold on 
shadedErrorBar(x,y4,n4,'lineProps',{'color','#d36135'});
legend('Early', 'Late')
hold off

%export_fig early_late.png
%% topoplot 

cfg = [];
cfg.baseline = [-0.2 0];
cfg.comment = 'xlim';
cfg.commentpos ='title';
cfg.xlim = [-0.2 : 0.1 : 1.0];  % Define 12 time intervals
cfg.zlim = [-0.5e-13 0.5e-13];      % Set the 'color' limits.
cfg.layout = layout;
cfg.colormap = winter;
figure; ft_topoplotER(cfg, erpearly); colorbar

cfg = [];
cfg.comment = 'xlim';
cfg.commentpos ='title';
cfg.baseline = [-0.2 0];
cfg.xlim = [-0.2 : 0.1 : 1.0];  % Define 12 time intervals
cfg.zlim = [-0.5e-13 0.5e-13]; 
cfg.layout = layout;
cfg.colormap = winter;
figure; ft_topoplotER(cfg, erplate); colorbar

%% difference plot
different = erpearly;
different.avg = erpearly.avg - erplate.avg;

cfg = [];
cfg.comment = 'xlim';
cfg.commentpos ='title';
cfg.baseline = [-0.2 0];
cfg.xlim = [-0.2 : 0.2 : 1.0];  % Define 12 time intervals
cfg.zlim = [-0.5e-13 0.5e-13]; 
cfg.layout = layout;
cfg.colormap = winter;
figure; ft_topoplotER(cfg, different); 
colorbar

%% Plot raw data

% y1 = smoothdata(grandavg_Ephon.avg,2, 'movmean', [2 2]); %do the stats on the smoothed data too and maybe additionally plot the raw in the appendix!
% y2 = smoothdata(grandavg_Lphon.avg,2, 'movmean', [2 2]);
% y3 = smoothdata(grandavg_Esem.avg,2, 'movmean', [2 2]); 
% y4 = smoothdata(grandavg_Lsem.avg,2, 'movmean', [2 2]);

%% plot early late sem/phon
z1 = grandavg_Ephon.avg; %do the stats on the smoothed data too and maybe additionally plot the raw in the appendix!
z2 = grandavg_Lphon.avg;
z3 = grandavg_Esem.avg; 
z4 = grandavg_Lsem.avg;

x = grandavg_Ephon.time;

%left 
figure
shadedErrorBar(x,z1,n1,'lineProps',{'color','#6cbdfc'});
hold on 
shadedErrorBar(x,z2,n2,'lineProps',{'color','#221ea4'});
legend('Early', 'Late')
hold off

%right 
figure
shadedErrorBar(x,z3,n3,'lineProps',{'color','#e6aa68'});
hold on 
shadedErrorBar(x,z4,n4,'lineProps',{'color','#d36135'});
legend('Early', 'Late')
hold off

