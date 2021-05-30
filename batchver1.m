%run this in the command line before batch preprocessing

number_of_subjects = {'sub008','sub009', 'sub010', 'sub018'};  

%%
for i = 1:length(number_of_subjects)
    x = number_of_subjects{i};
    eval(x);
try
  batchpreprocessing(x)
  clear data
  catch
  disp(['Something was wrong with Subject' subjectdata.subjectnr '! Continuing with next in line']);
end
end
