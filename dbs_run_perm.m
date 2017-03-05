function [perm_result] = dbs_run_perm(setmat, label, hypotest, direction, numperm)
% DBS_RUN_PERM    Permutation to acquire an emprical null distributino of the maximum measures targeted
%              for FWE correction using DBS in connectivity analysis
% ================================================================================================================ 
% [ INPUTS ]
%     setmat = 3-D matrix. a set of matrices from multiple subjects. One for each.
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

numsub = size(setmat,3);
numnode = size(setmat, 1); % or numnode = size(setmat,2);

for i_perm = 1 : numperm
    permlist(i_perm, :) = randperm(numsub); % permlist_uniq = unique(permlist,'rows');
end

t1 = clock;     reverseStr = '';    h = waitbar(0, 'Running permutations for DBS correction ...');

for i_perm = 1 : numperm
    temp_setmat = zeros(numnode, numnode, numsub );
    for j = 1:numsub
        temp_setmat(:,:,j) = setmat(:,:,permlist(i_perm,j));
    end
    [temp_s, ~, temp_p] = dbs_hypo_test(temp_setmat, label, hypotest, direction);
    perm_result.s(:,:,i_perm) = temp_s;
    perm_result.p(:,:,i_perm) = temp_p;
    
    [reverseStr, msg] = dbs_progress_box(i_perm, numperm, t1, reverseStr);
    waitbar(i_perm/numperm, h, sprintf('Running permutations for DBS correction ...  %0.1f %%', 100*i_perm/numperm))
end
reverseStr = repmat(sprintf('\b'), 1, length(msg));     fprintf(reverseStr);    close(h);
perm_result.p(isnan(perm_result.p)) =1;
perm_result.s(isnan(perm_result.s)) =0;

fprintf('\t[ %d permutations were done ]', i_perm)
