function [dbs_result, cp_result] = dbs_run_correction(setmat, label, hypoTest, direction, numPerm, perm_result, icft_p, thrClst)
% DBS_MAIN    FWE correction using Degree-based statistics (DBS) in connectivity analysis
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
%     perm_result = A permutations result for DBS-based correction.
%                   An output from 'dbs_set_perm'.
%
%     icft_p = an initial cluster-forming threshold (p-value)
% 
%     thrClst = DBS-based FWE-corrected cluster-level threshold for significance  (default = 0.05) 
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     dbs_result  = A result from DBS-bsed correction in connectivity analysis
%     cp_result   = A result from testing CP scores 
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

%% Set the default parameters & get the information from input
numSubj = size(setmat,3);    numNode = size(setmat, 1);
df = dbs_cal_df (hypoTest, numSubj); % calculate degree of freedom (DOF or DF) given a hypothesis and the number of subjects

%% WD threshold with an pre-defined initial cluster-forming threshold (icft)
% two paramters described in the Discussion section of the original paper. This is for further development.
% pwr.dgr = 1;    pwr.thr = 0; 

icft_s = dbs_set_initrange (hypoTest, icft_p, df, direction);

temp_perm_s = perm_result.s - icft_s;
temp_perm_s(temp_perm_s<0) = 0;
temp_perm_wd_max = sort(max(squeeze(sum(temp_perm_s))), 'descend')';

thrClst1 = ceil(thrClst*numPerm); % thrClst1 = floor(thrClst*numPerm);
dbs_result.thr = temp_perm_wd_max(thrClst1);

%% Test the hypothesis
[s, ~, p] = dbs_hypo_test(setmat, label, hypoTest, direction);
p(isnan(p)) =1;    s(isnan(s)) =0;

%% Correction with DBS
obs_s = s - icft_s;
obs_s(obs_s<0) = 0;

dbs_result.wd = sum(obs_s)';
dbs_result.nodeCent = find(dbs_result.wd > dbs_result.thr);

tempMatLine = zeros(numNode);
tempMatLine(dbs_result.nodeCent,:) = 1;    tempMatLine(:,dbs_result.nodeCent) = 1;
dbs_result.conMat_height = obs_s .* tempMatLine;
obs_sOrig = s;
obs_sOrig(obs_s==0) = 0;
dbs_result.conMat_orig = obs_sOrig .* tempMatLine;

%% Calculate Center Persistency (CP) score
% thr_p_min = min(min(min(perm_result.p)));

icft_s2 = dbs_set_initrange (hypoTest, 0.05, df, direction);

obs_s2 = s - icft_s2;    obs_s2(obs_s2<0) = 0;
temp_perm_s2 = perm_result.s - icft_s2;    temp_perm_s2(temp_perm_s2<0) = 0;

cp_result.score = sum(obs_s2.^2 /2)';
temp_perm_cp_max = sort(max(squeeze(sum(temp_perm_s2.^2/2))), 'descend')';
cp_result.thr = temp_perm_cp_max(thrClst1);
cp_result.node = find(cp_result.score > cp_result.thr);
cp_result.norm = cp_result.score / cp_result.thr;
