function [perm_result, fileName] = dbs_set_perm(setmat, label, hypoTest, direction, numPerm)
% DBS_SET_PERM    FWE correction using Degree-based statistics (DBS) in connectivity analysis
% ================================================================================================================ 
% [ INPUTS ]
%     setmat = 3-D matrix which consists of a set of 2-D matrices from multiple subjects.
%         A size of setmat should be [N by N by M].
%             N: the number of nodes.
%             M: the number of subjects
% 
%     label = 1-D vector containing a list of labels 
%               with a value 0 (group 1) or 1 (group 2), indicating in which group each subject is included (for hypoTest = 0 or 1)
%               or with individual measures of behavioral performance from each subjects for correlation (for hypoTest = 2)
% 
%     hypoTest = type of test (default = 0).
%         0: two-sample paired t-test (ttest)
%         1: two-sample unpaired t-test (ttest2) (assumping the same variance for the two groups)
%         2: correlation analysis (corr)
% 
%     direction
%          0: g1 = g2 (two-tail)
%          1: g1 > g2 (one-tail)
%         -1: g1 < g2 (one-tail)
% 
%     numPerm = the number of permutations performed for family (default = 5000).
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     perm_result = A permutations result for DBS-based correction
%     fileName    = The name of .mat file containing 'per_result' and other inputs
% ----------------------------------------------------------------------------------------------------------------
% Last update: Mar 5, 2017.
% 
% Copyright 2017. Kwangsun Yoo (K Yoo), PhD
%     E-mail: rayksyoo@gmail.com / raybeam@kaist.ac.kr / kwangsun.yoo@yale.edu
%     Laboratory for Cognitive Neuroscience and NeuroImaging (CNI)
%     Department of Bio and Brain Engineering
%     Korea Advanced Instititue of Science and Technology (KAIST)
%     Daejeon, Republic of Korea
%
%     Department of Psychology
%     Yale University.
%     New Haven, CT. USA.
% 
%     Paper: Yoo et al. (2017) Human Brain Mapping.
%            Degree-based statistic and center persistency for brain connectivity analysis. 
% ================================================================================================================

temp = clock;   fprintf('\n\t\t%d, %d/%d, %d:%2.0f:%2.0f\tProcess started\n', temp)

%% Check the input argument
if nargin < 3; error('Must input at least three parameters.\n'); end

if ~exist('direction'); direction = 0; 
elseif isempty(direction); direction = 0; end;

if ~exist('numPerm'); numPerm = 5000; 
elseif isempty(numPerm); numPerm = 5000;
else	if numPerm < 1000; warning('You should run permutations more for the exact estimation (e.g. 1,000, 5,000, 10,000 times, or more.)'); end; end;

%% Permutations for correction
tic;     
[perm_result] = dbs_run_perm(setmat, label, hypoTest, direction, numPerm);
temp_time = toc;
fprintf('\t( %.2f minutes elapsed. )\n', temp_time/60)

%% Finish process
dbs.time{1} = temp;     dbs.time{2,1} = clock;
fprintf('\t\t%d, %d/%d, %d:%2.0f:%2.0f\tProcess done\n\n', dbs.time{2})

%% Save permutation results
prompt = {'Save a mat file of permutation'};
dlg_title = 'Save file as ...';
num_lines = [1 40];
timeNow = clock;
defaultans = {['DBS_perm_' num2str(timeNow(1)) num2str(timeNow(2)) num2str(timeNow(3), '%02i') '_' num2str(timeNow(4), '%02i') '_' num2str(timeNow(5), '%02i') '.mat']};
nameSave = inputdlg(prompt,dlg_title,num_lines,defaultans);

if ~isempty(nameSave)
    fileName = nameSave{1};
    save([fileName], 'perm_result', 'setmat', 'label', 'hypoTest', 'direction', 'numPerm');
end
