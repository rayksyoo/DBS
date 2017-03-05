function [t, p, df] = dbs_pairT_matrix (gr1 , gr2 , direction)
% DBS_PAIRT_MATRIX    
% ================================================================================================================ 
% [ INPUTS ]
%     gr1, gr2 = a pair of 3-D matrix which consists of a set of 2-D matrices from multiple subjects.
%         A size of setmat should be [N by N by M].
%             N: the number of nodes.
%             M: the number of subjects. the same across two groups
% 
%     direction
%          0: g1 = g2 (two-tail)
%          1: g1 > g2 (one-tail)
%         -1: g2 < g1 (one-tail)
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     t, p, df
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

mu_zero = 0; % target difference to test

setmat.diff = gr1 - gr2;
setmat.mean = mean(setmat.diff,3);

numfirst = size(gr1,3);
df = numfirst - 1; 

setmat.mean2 = repmat(setmat.mean, [1, 1, numfirst]);

setmat.csd = sqrt ( sum((setmat.diff - setmat.mean2).^2, 3)  ./ df ); % csd: corrected sample standard deviation
t = (setmat.mean - mu_zero) ./ (setmat.csd / sqrt(numfirst));

if direction == 0
    p = 2 * tcdf(abs(t), df, 'upper') ;
elseif direction == 1 %% testing whether [g1 > g2] (the same as ttest right)
    p = tcdf(t, df, 'upper') ;
elseif direction == -1 %% testing whether [g1 < g2] (the same as ttest left)
    p = tcdf(t, df) ;
end

    
    
    