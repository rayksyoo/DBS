function [perm] = dbs_perm(setmat, label, hypotest, direction, numperm)
% DBS_PERM    Permutation to acquire an emprical null distributino of the maximum measures targeted.
%              for FWE correction using DBS in connectivity analysis
% ================================================================================================================ 
% [ INPUTS ]
%     setmat = 3-D matrix. a set of matrices from multiple subjects. One for each.
%         A size of setmat should be [N by N by M].
%             N: the number of nodes.
%             M: the number of subjects
% 
%     label = 1-D vector. a list of labels with a value 0 or 1, indicating in which group each subject is included (for hypotest = 0 or 2)
%                                     or with individual measures of all subjects for correlation (for hypotest = 1)
% 
%     numperm = # of permutations performed for family (default = 5000).
% 
%     hypotest = type of test (default = 0).
%         0: two-sample paired t-test (ttest)
%         1: correlation analysis (corr)
%         2: two-sample unpaired t-test (ttest2)
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     dbs_perm
% ----------------------------------------------------------------------------------------------------------------
% Last update: Aug 31, 2016.
% 
% Copyright 2016. Kwangsun Yoo (K Yoo), PhD
%     E-mail: rayksyoo@gmail.com / raybeam@kaist.ac.kr
%     Laboratory for Cognitive Neuroscience and NeuroImaging (CNI)
%     Department of Bio and Brain Engineering
%     Korea Advanced Instititue of Science and Technology (KAIST)
%     Daejeon, Republic of Korea
% ================================================================================================================

numsub = size(setmat,3);
numnode = size(setmat, 1); % or numnode = size(setmat,2);

for i_perm = 1 : numperm
    permlist(i_perm, :) = randperm(numsub); % permlist_uniq = unique(permlist,'rows');
end

t1 = clock;     reverseStr = '';    h = waitbar(0, 'DBS is running ...');

for i_perm = 1 : numperm
    temp_setmat = zeros(numnode, numnode, numsub );
    for j = 1:numsub
        temp_setmat(:,:,j) = setmat(:,:,permlist(i_perm,j));
    end
    [temp_s, ~, temp_p] = dbs_hypo_test(temp_setmat, label, hypotest, direction);
    perm.s(:,:,i_perm) = temp_s;
    perm.p(:,:,i_perm) = temp_p;
    
    [reverseStr, msg] = dbs_progress_box(i_perm, numperm, t1, reverseStr);
    waitbar(i_perm/numperm, h, sprintf('DBS is running ...  %0.1f %%', 100*i_perm/numperm))
end
reverseStr = repmat(sprintf('\b'), 1, length(msg));     fprintf(reverseStr);    close(h);
perm_result.p(isnan(perm_result.p)) =1;
perm_result.s(isnan(perm_result.s)) =0;

fprintf('\t[ %d permutations done ]', i_perm)
