function batchpreprocessing(Subjectm)
% preprocessing function to be run on multiple subjects at once 

currentdir = 'W:\shared\Aline\thesis_allsubjects';
eval(Subjectm)

% define trials
cfg            = [];
cfg.dataset      = [subjectdata.subjectdir filesep subjectdata.datadir];
cfg.trialfun     = 'audiobooktrialfun_SO';
cfg.allowoverlap = 'yes';
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

cfg = [];
cfg.resamplefs = 200;
cfg.detrend    = 'no';
data = ft_resampledata(cfg, data);

save([currentdir filesep subjectdata.subjectnr '_data.mat'],'data', '-v7.3');
end

