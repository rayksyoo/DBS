function [dbs_result, cp_result, perm_result, fileName] = dbs(setmat, label, hypoTest, direction, numPerm, icft_p, thrClst)
% DBS    FWE correction using Degree-based statistics (DBS) in connectivity analysis
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
%
%     icft_p = an initial cluster-forming threshold (p-value)
% 
%     thrClst = DBS-based FWE-corrected cluster-level threshold for significance  (default = 0.05) 
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     dbs_result  = A result from DBS-bsed correction in connectivity analysis
%     cp_result   = A result from testing CP scores 
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

%% Check the input argument
if nargin < 3; error('You need at least three parameters to run analysis with DBS correction.\n'); end

if ~exist('direction'); direction = 0; 
elseif isempty(direction); direction = 0; end;

if ~exist('numPerm'); numPerm = 5000; 
elseif isempty(numPerm); numPerm = 5000;
else	if numPerm < 1000; warning('You should run permutations more for the exact estimation (e.g. 1,000, 5,000, 10,000 times, or more.)'); end; end;

%% Set and run permutations
[perm_result, fileName] = dbs_set_perm(setmat, label, hypoTest, direction, numPerm);

%% Set and run DBS-based correction
if nargin < 7
    prompt = {'an initial cluster-forming threshold (p-value)' ; 'a DBS-corrected threshold (p-value)'};
    dlg_title = 'Select thresholds ...';
    num_lines = [1 50];
    timeNow = clock;
    defaultans = {'0.001'; '0.05'};
    thres = inputdlg(prompt,dlg_title,num_lines,defaultans);

    icft_p = str2num(thres{1});
    thrClst = str2num(thres{2});
end;

[dbs_result, cp_result] = dbs_run_correction(setmat, label, hypoTest, direction, numPerm, perm_result, icft_p, thrClst);
