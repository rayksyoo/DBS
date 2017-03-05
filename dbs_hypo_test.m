function [s, t, p] = dbs_hypo_test(setmat, label, hypotest, direction)
% DBS_HYPO_TEST    Set the hypothesis testing
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
%         -1: g2 < g1 (one-tail)
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     s, t, p
% ----------------------------------------------------------------------------------------------------------------
% Last update: Aug 30, 2016.
% 
% Copyright 2016. Kwangsun Yoo (K Yoo), PhD
%     E-mail: rayksyoo@gmail.com / raybeam@kaist.ac.kr
%     Laboratory for Cognitive Neuroscience and NeuroImaging (CNI)
%     Department of Bio and Brain Engineering
%     Korea Advanced Instititue of Science and Technology (KAIST)
%     Daejeon, Republic of Korea
% ================================================================================================================

if hypotest == 0
    [t, p] = dbs_pairT_matrix (setmat(:,:,label==0) , setmat(:,:,label==1), direction);    s = t;
elseif hypotest == 1
    [t, p] = dbs_unpairT_matrix (setmat(:,:,label==0) , setmat(:,:,label==1), direction);    s = t;
elseif hypotest == 2
    [s, t, p] = dbs_corr_matrix (setmat, label, direction);
end
