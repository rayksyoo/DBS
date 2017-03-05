function dof = dbs_cal_df (hypotest , numSamples)
% DBS_CAL_DF    Provide the degree of freedom (dof) for the hypothesis testing and the number of samples
% ================================================================================================================ 
% [ INPUTS ]
%     hypotest = type of test (default = 0).
%         0: two-sample paired t-test (ttest)
%         1: two-sample unpaired t-test (ttest2) (assumping the same variance for the two groups)
%         2: correlation analysis (corr)
% 
%     numSaples = the number of samples (or subjects) give to the hypothesis testing 
% ----------------------------------------------------------------------------------------------------------------
% [ OUTPUTS ]
%     dof = the degree of freedom (DOF) for the hypothesis testing and the number of samples 
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
    dof = numSamples/2 - 1 ;
    
elseif hypotest == 1
    dof = numSamples - 2 ; % for equal variance
    
elseif hypotest == 2
    dof = numSamples - 2 ; 
end