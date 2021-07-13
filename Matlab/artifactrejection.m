%% prep 
%load data and run subject file
clear all
run('sub009.m')


load(subjectdata.preprocdir, 'data');
subject = ['sub' subjectdata.subjectnr];
load(subjectdata.icadir, 'comp');

%% delete non-parsed trials and generate layout

list = [34  93  95  99  104  123  124  135  146  159  168  196  234  250  311  325  451  501  560  585  598  605  616  625  657  679  769  770  774  777  836  844  895  916  928  959  994  1049  1079  1104  1135  1171  1220  1253  1290  1299  1307  1314  1335  8  13  14  23  44  66  71  106  108  112  116  122  134  137  138  153  174  199  202  211  221  236  240  255  256  275  296  298  333  366  383  387  403  424  432  446  477  490  507  511  514  521  545  546  549  586  590  601  602  612  620  630  637  651  659  678  682  683  714  720  723  724  737  795  828  831  885  929  940  948  965  967  1027  1051  1062  1112  1117  1119  1121  1137  1186  1198  1207  1217  1222  1230  1233  1237  1244  1250  1251  1295  1320  1326  1327  1329  1331  1333];
list = list';
row = data.cfg.previous.trl(:,4);
idx = setdiff(row,list);

cfg = [];
cfg.trials = idx;
data = ft_selectdata(cfg, data);

cfg = [];
layout = ft_prepare_layout(cfg,data);
save([subjectdata.subjectdir filesep subject '_layout'], 'layout')
save([subjectdata.subjectdir filesep subject '_databis'], 'data')
% save trl to use when removing artifacts; not needed as art reject doesn't work 
% 
% trl = data.cfg.previous.previous.trl;
% [tf, kepttrials] = ismember(idx,trl(:,4));
% trl = trl(kepttrials,:);
% 
% clear  idx list row kepttrials tf
%
%save version of trials before cleaning per condition 
cfg = [];
cfg.trials = find(data.trialinfo(:,4)== 100);
earlydata = ft_selectdata(cfg, data);
earlydata = earlydata.trialinfo(:,1);
save([subjectdata.subjectdir filesep subject '_earlydata'], 'earlydata')


cfg = [];
cfg.trials = find(data.trialinfo(:,4)== 300);
latedata = ft_selectdata(cfg, data);
latedata = latedata.trialinfo(:,1);
save([subjectdata.subjectdir filesep subject '_latedata'], 'latedata');

clear earlydata latedata idx list row
 %% ID artifacts 

figure
cfg = [];
cfg.layout    = layout;
cfg.component = 1:20; 
%cfg.component = 20:30; 
cfg.comment   = 'no';
ft_topoplotIC(cfg, comp)

figure
cfg = [];
cfg.layout    = layout;
cfg.component = 20:30; 
cfg.comment   = 'no';
ft_topoplotIC(cfg, comp)

% ID aritfacts visually
cfg = [];
cfg.viewmode  = 'component';      
cfg.layout    = layout;
ft_databrowser(cfg, comp);

%% Reject components
cfg = [];
cfg.component = [1 10 19 22]; % to be removed component(s)
cleandata = ft_rejectcomponent(cfg, comp, data);
% cleandata.sampleinfo = trl(:,[1 2]); %add the sample info for artifact rejection
% cleandata.cfg.sampleinfo = trl(:,[1 2]);

save([subjectdata.subjectdir filesep subject '_cleandata'], 'cleandata');
clear comp data

%% Jump artifact detection - now batched 

% cfg              = [];
% cfg.trialfun     = 'audiobooktrialfun_SO';
% cfg.dataset = [subjectdata.subjectdir filesep subjectdata.datadir];
% cfg.headerformat       = 'ctf_ds';
% cfg.allowoverlap        = 'yes';
% cfg.dataformat         = 'ctf_ds';
% cfg = ft_definetrial(cfg);
% trl = cfg.trl; 
% 
% %jump
% cfg = [];
% cfg.trl = trl;
% cfg.allowoverlap = 'yes';
% cfg.datafile = [subjectdata.subjectdir filesep subjectdata.datadir];
% cfg.headerfile = [subjectdata.subjectdir filesep subjectdata.datadir];
% cfg.continuous = 'yes';
% 
% % channel selection, cutoff and padding
% %cfg.artfctdef.zvalue.channel = 'ML';
%  cfg.artfctdef.zvalue.channel = 'MR';
% cfg.artfctdef.zvalue.cutoff = 80;
% cfg.artfctdef.zvalue.trlpadding = 0;
% cfg.artfctdef.zvalue.artpadding = 0;
% cfg.artfctdef.zvalue.fltpadding = 0;
% 
% % algorithmic parameters
% cfg.artfctdef.zvalue.cumulative = 'yes';
% cfg.artfctdef.zvalue.medianfilter = 'yes';
% cfg.artfctdef.zvalue.medianfiltord = 9;
% cfg.artfctdef.zvalue.absdiff = 'yes';
% 
% % make the process interactive
% cfg.artfctdef.zvalue.interactive = 'yes';
% 
% % [cfg, artifact_jumpL] = ft_artifact_zvalue(cfg);
%  [cfg, artifact_jumpR] = ft_artifact_zvalue(cfg);
% 
% %% muscle artifact detection
% cfg = [];
% cfg.trl = trl;
% cfg.allowoverlap = 'yes';
% cfg.datafile = [subjectdata.subjectdir filesep subjectdata.datadir];
% cfg.headerfile = [subjectdata.subjectdir filesep subjectdata.datadir];
% cfg.continuous = 'yes';
% 
% % channel selection, cutoff and padding
% cfg.artfctdef.zvalue.channel      = 'MRT*';
% cfg.artfctdef.zvalue.cutoff       = 12;
% cfg.artfctdef.zvalue.trlpadding   = 0;
% cfg.artfctdef.zvalue.fltpadding   = 0;
% cfg.artfctdef.zvalue.artpadding   = 0.1;
% 
% % algorithmic parameters
% cfg.artfctdef.zvalue.bpfilter     = 'yes';
% cfg.artfctdef.zvalue.bpfreq       = [110 140];
% cfg.artfctdef.zvalue.bpfiltord    = 9;
% cfg.artfctdef.zvalue.bpfilttype   = 'but';
% cfg.artfctdef.zvalue.hilbert      = 'yes';
% cfg.artfctdef.zvalue.boxcar       = 0.2;
% 
% % make the process interactive
% cfg.artfctdef.zvalue.interactive = 'yes';
% 
% [cfg, artifact_muscle] = ft_artifact_zvalue(cfg);
% 
% %% combine the sep artifacts 
% artifact_jump = [artifact_jumpL; artifact_jumpR];

%% actual rejection  

% load(subjectdata.artifactjdir, 'artifact_jump');
% load(subjectdata.artifactmdir, 'artifact_muscle');
% 
% cfg=[];
% cfg.trl = trl;
% cfg.allowoverlap = 'yes';
% cfg.artfctdef.reject = 'complete'; % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
% cfg.artfctdef.jump.artifact = artifact_jump;
% cfg.artfctdef.muscle.artifact = artifact_muscle;
% noartifactdata = ft_rejectartifact(cfg,cleandata);

% save([subjectdata.subjectdir filesep subject '_noartdata'], 'noartifactdata', '-v7.3');
% clear cleandata artifact_jump artifact_muscle trl
%% 
%Check the trials semi-auto;

cfg          = [];
cfg.method   = 'summary';
cfg.layout    = layout;
% cleandata2 = ft_rejectvisual(cfg,noartifactdata);
cleandata2 = ft_rejectvisual(cfg,cleandata);
%%
save([subjectdata.subjectdir filesep subject '_cleandata2'], 'cleandata2');
% if no deleted channels 
%save([subjectdata.subjectdir filesep subject '_finaldata'], 'cleandata2');

%% Interpolate deleted channels
%Locate neighbors = do with uncorrected data
cfg = [];
cfg.method = 'triangulation';
cfg.grad = ft_read_sens([subjectdata.subjectdir filesep subjectdata.datadir], 'senstype','meg'); %change for each subject
neighbours = ft_prepare_neighbours(cfg, cleandata);

%% 
%Interpolate 
cfg = [];
cfg.method  = 'weighted';
cfg.senstype = 'meg';
cfg.missingchannel = setdiff(cleandata.label, cleandata2.label);
cfg.neighbours = neighbours;
[finaldata] = ft_channelrepair(cfg, cleandata2);


save([subjectdata.subjectdir filesep subject '_finaldata'], 'finaldata');

clear cleandata2 cleandata