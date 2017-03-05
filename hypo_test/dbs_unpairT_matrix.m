function [t, p, df] = dbs_unpairT_matrix (gr1 , gr2 , direction)
% DBS_UNPAIRT_MATRIX    
% ================================================================================================================ 
% [ INPUTS ]
%     gr1, gr2 = a pair of 3-D matrix which consists of a set of 2-D matrices from multiple subjects.
%         A size of setmat should be [N by N by M].
%             N: the number of nodes.
%             M: the number of subjects. Two groups could have different M.
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

setmat.g1.mean = mean(gr1, 3);
setmat.g2.mean = mean(gr2, 3);

numfirst = size(gr1,3);
numsecond = size(gr2,3);
df = numfirst+numsecond-2;

setmat.g1.mean2 = repmat(setmat.g1.mean, [1, 1, numfirst]);
setmat.g2.mean2 = repmat(setmat.g2.mean, [1, 1, numsecond]);

setmat.g1.usv = sum( (gr1 - setmat.g1.mean2) .^2 ,3) ./ (numfirst-1); % usv: unbiased sample variation
setmat.g2.usv = sum( (gr2 - setmat.g2.mean2) .^2 ,3) ./ (numsecond-1);

t = ( setmat.g1.mean - setmat.g2.mean) ./ sqrt ( ( ( (numfirst-1) * setmat.g1.usv + (numsecond-1) * setmat.g2.usv ) / df) * ( (1/numfirst) + (1/numsecond) ) );
if direction == 0
    p = 2 * tcdf(abs(t), df, 'upper' ) ;
elseif direction == 1 %% testing whether [g1 > g2] (the same as ttest right)
    p = tcdf(t, df, 'upper' ) ;
elseif direction == -1 %% testing whether [g1 < g2] (the same as ttest left)
    p = tcdf(t, df) ;
end
