function RSA(Subjectm)
%load data and run subject file
%run('sub010.m')
run(Subjectm)

%%
subject = ['sub' subjectdata.subjectnr];
fdir = 'K:\MEGdata\finaldata';
load([subjectdata.subjectdir filesep subject '_finaldata']);
load([subjectdata.subjectdir filesep subject '_earlydata']);
load([subjectdata.subjectdir filesep subject '_latedata']);

%%
%finaldata = cleandata2; %to use if no channels are deleted 
%     clear cleandata2

%%

%Separate trials
 
cfg = [];
cfg.trials = find(finaldata.trialinfo(:,4)== 100);
early = ft_selectdata(cfg, finaldata);

e = early.trialinfo(:,1);
ediff = setdiff(earlydata,e); %find deleted trials 
[~, deleted_earlytrials] = ismember(ediff,earlydata); %get index which then corresponds to trial number 

cfg = [];
cfg.trials = find(finaldata.trialinfo(:,4)== 300);
late = ft_selectdata(cfg, finaldata);

l = late.trialinfo(:,1);
ldiff = setdiff(latedata,l); %find deleted trials 
[~, deleted_latetrials] = ismember(ldiff,latedata); %get index which then corresponds to trial
%% clean early models 
disp(subject)

load('K:\audiobook\early_pmatrix.mat')
load('K:\audiobook\early_vmatrix.mat')

%Delete early trials 

pmatrix(deleted_earlytrials,:)=[];
pmatrix(:,deleted_earlytrials)=[];
vmatrix(deleted_earlytrials,:)=[];
vmatrix(:,deleted_earlytrials)=[];

% create brain rdms

for j=1:length(early.trial{1,1})
    for i=1:length(early.trial)
     for k=1:length(early.label)
        early.newtrial{1,j}(i,k) = early.trial{1,i}(k,j);
     end
    end
end

early.RDM = cell(1,length(early.newtrial));
for i=1:length(early.newtrial)
    X = early.newtrial{1,i};
    early.RDM{1,i} = squareform(pdist(X,'spearman'));
    X = early.RDM{1,i};
end

disp('Early RDM done!')
% Final comparison at each timepoint: early
 
 Y = vmatrix;
 Z = pmatrix;
 index_tril = boolean(tril(ones(size(X)), -1)); %lower diagonal of X and Y 
 idx = Y > 1e-16 & Y ~=1 & Z~=0;
 final_index = index_tril & idx;
 
for i=1:length(early.RDM)
    X = early.RDM{1,i};
    early.sem(1,i) = corr(X(final_index),Y(final_index), 'type','spearman'); %if correlation is 1 then are the same? and dissim is 0
    early.phon(1,i)= corr(X(final_index),Z(final_index), 'type','spearman'); 
end
 
disp('Early Correlation done!')
save ([fdir filesep subject filesep subject '_early'], 'early', '-v7.3')
%% clean late models 

clear vmatrix pmatrix
disp('Finished saving early variable!')

load('K:\audiobook\late_pmatrix.mat')
load('K:\audiobook\late_vmatrix.mat')

 %Delete late trials 
pmatrix(deleted_latetrials,:)=[];
pmatrix(:,deleted_latetrials)=[];
vmatrix(deleted_latetrials,:)=[];
vmatrix(:,deleted_latetrials)=[];
 
% rdm late 

for j=1:length(late.trial{1,1})
    for i=1:length(late.trial)
     for k=1:length(late.label)
        late.newtrial{1,j}(i,k) = late.trial{1,i}(k,j);
     end
    end
end

late.RDM = cell(1,length(late.newtrial));
for i=1:length(late.newtrial)
    X2 = late.newtrial{1,i};
    late.RDM{1,i} = squareform(pdist(X2,'spearman'));
    X2= late.RDM{1,i};
end

disp('Late RDM done!');

% Final comparison at each timepoint: late
 Y = vmatrix;
 Z = pmatrix;
 
 index_tril = boolean(tril(ones(size(X2)), -1)); %lower diagonal of X and Y 
 idx = Y > 1e-16 & Y ~=1 & Z~=0;
 final_index = index_tril & idx;
 
for i=1:length(late.RDM)
    X2 = late.RDM{1,i};
    late.sem(1,i) = corr(X2(final_index),Y(final_index), 'type','spearman'); %if correlation is 1 then are the same? and dissim is 0
    late.phon(1,i)= corr(X2(final_index),Z(final_index), 'type','spearman'); 
end

disp('Late correlation done!')
save ([fdir filesep subject filesep subject '_late'], 'late', '-v7.3')

end
