function [r, t, p, df] = dbs_corr_matrix (gr , label , direction)
% DBS_CORR_MATRIX    
% ================================================================================================================ 
% [ INPUTS ]
%     gr = 3-D matrix which consists of a set of 2-D matrices from multiple subjects.
%         A size of setmat should be [N by N by M].
%             N: the number of nodes.
%             M: the number of subjects.
% 
%     label = 1-D vector containing a list of labels 
%               with individual measures of behavioral performance from each subjects for correlation
% 
%     direction
%          0: g1 = g2 (two-tail)
%          1: g1 > g2 (one-tail)
%         -1: g2 < g1 (one-tail)
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     r, t, p, df
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
if nargin<3
    direction = 0;
end
setmat.mean = mean(gr, 3);
numsub = size(gr,3);
df = numsub - 2;

lab.B = zeros(1,1, numsub);
lab.B(1,1,:) = label;
lab.mean = mean(lab.B,3);
lab.full = repmat(lab.B, [size(gr,1), size(gr,2)]);

lab.mean2 = mean(lab.full, 3);
setmat.mean2 = repmat(setmat.mean, [1, 1, numsub]);
lab.B2 = repmat(lab.B, [1, 1, numsub]);
lab.mean3 = repmat(lab.mean2, [1, 1, numsub]);

r = sum ( (gr - setmat.mean2) .* (lab.full - lab.mean3), 3) ./ sqrt ( sum( (gr - setmat.mean2).^2 ,3) .*  sum( (lab.full - lab.mean3).^2 ,3) );
t = r ./ sqrt( (1-r.^2) / df) ;
if direction == 0
    p = 2 * tcdf(abs(t), df, 'upper' ) ;
elseif direction == 1  %% testing whether positive corrlation (the same as corr right) (with ttest right)
    p = tcdf(t, df, 'upper' ) ;
elseif direction == -1 %% testing whether negative corrlation (the same as corr left) (with ttest left)
    p = tcdf(t, df ) ;
end