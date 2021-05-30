%Call to define trial

cfg              = [];
cfg.trialfun     = 'audiobooktrialfun_SO';
cfg.allowoverlap = 'yes';
cfg.dataset = ('K:\MEGdata\sub009\sub009.ds'); %change to correspond to each subject
cfg = ft_definetrial(cfg);

cfg.channel = 'MEG'; 
cfg.demean     = 'yes';
cfg.continuous = 'yes';
cfg.allowoverlap = 'yes';


    % Fitering options
cfg.bpfilter        = 'yes';
cfg.bpfreq          = [0.5 100];
cfg.dftfilter       = 'yes';
cfg.dftfreq         = [50 100 150];

data = ft_preprocessing(cfg);

% remove words not in final matrix 
% list = [34  93  95  99  104  123  124  135  146  159  168  196  234  250  311  325  451  501  560  585  598  605  616  625  657  679  769  770  774  777  836  844  895  916  928  959  994  1049  1079  1104  1135  1171  1220  1253  1290  1299  1307  1314  1335  8  13  14  23  44  66  71  106  108  112  116  122  134  137  138  153  174  199  202  211  221  236  240  255  256  275  296  298  333  366  383  387  403  424  432  446  477  490  507  511  514  521  545  546  549  586  590  601  602  612  620  630  637  651  659  678  682  683  714  720  723  724  737  795  828  831  885  929  940  948  965  967  1027  1051  1062  1112  1117  1119  1121  1137  1186  1198  1207  1217  1222  1230  1233  1237  1244  1250  1251  1295  1320  1326  1327  1329  1331  1333];
% list = list';
% row = data.cfg.trl(:,4);
% idx = setdiff(row,list);
% 
% cfg = [];
% cfg.trials = idx;
% data = ft_selectdata(cfg, data);
% 
%save([currentdir filesep subjectdata.subjectnr '_data.mat'],'data')
%%
cfg = [];
cfg.allowoverlap = 'yes';
cfg.viewmode = 'butterfly';
ft_databrowser(cfg, data);

%%

%View data vertically 
cfg.viewmode = 'vertical';
ft_databrowser(cfg, data);




