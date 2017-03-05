function stats = dbs_set_initrange (hypotest, range, df, direction)
% DBS_SET_INITRANGE    Set a range of the initial cluster-forming threshold statistical value 
%                      (corresponding to the p-value) to be tested
% ================================================================================================================ 
% [ INPUTS ]
%     hypotest = type of test (default = 0).
%         0: two-sample paired t-test (ttest)
%         1: two-sample unpaired t-test (ttest2) (assumping the same variance for the two groups)
%         2: correlation analysis (corr)
% 
%     range
% 
%     df = the degree of freedom (DOF) for the hypothesis testing and the number of samples 
%
%     direction
%          0: g1 = g2 (two-tail)
%          1: g1 > g2 (one-tail)
%         -1: g2 < g1 (one-tail)
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     stats 
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
    if direction == 0
        t = tinv( range/2 , df ); % for two-tailed (subdivision by 2 represents the two-tail) paired t-test. If <0, 1st grp has higher.
    elseif direction == 1 %% testing whether [g1 > g2] (the same as ttest right)
        t = tinv( 1 - range , df );
    elseif direction == - 1 %% testing whether [g1 < g2] (the same as ttest left)
        t = tinv( range , df );
    end;     stats = t;
elseif hypotest == 1
    if direction == 0
        t = tinv( range/2 , df ); % for unpaired t-test df = (numfirst-1) + (numsub-numfirst -1) = n_total - 2 for the equal variances
    elseif direction == 1 %% testing whether [g1 > g2] (the same as ttest right)
        t = tinv( 1- range , df );
    elseif direction == - 1 %% testing whether [g1 < g2] (the same as ttest left)
        t = tinv( range , df );
    end;     stats = t;
elseif hypotest == 2
    if direction == 0
        t = tinv( range/2 , df ); % for two-tailed (subdivision by 2 represents the two-tail) paired t-test.
    elseif direction == 1 %% testing whether positive corrlation (the same as corr right) (with ttest right)
        t = tinv( 1- range , df );
    elseif direction == - 1 %% testing whether negative corrlation (the same as corr left) (with ttest left)
        t = tinv( range , df );
    end;     r = sqrt( t.^2 ./ (df + t.^2)); % t to r transformation (from r to t transform)
    stats = r;
end;
stats = abs(stats);
