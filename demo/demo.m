% ======================================================= %
%  Example using DBS for the brain connectivity analysis  %
% ======================================================= %
% DEMO
% --------------------------------------------------------------------
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

%% Load the demo.mat file provided.
load('./demo.mat');
% aa : a label information of connectivity matrices
% s_all : 3-D connectivity matrix of 116x116x16
%         116x116 : AAL parcellation based connectivity matrix. 
%         16 : two matrices for each of 8 subjects (1,9 : 1st subject / ... / 8,16 : 8nd subject
% roi_name : an ordered list of AAL ROI

%% Run the dbs_main for the paired t-test with default options.
[DBSresult, CPresult, ~, fileName] = dbs(s_all, aa, 0);

%% Check the result.
% 
% DBSresult.nodeCent contains a list of nodes having significant wd values
%     These individual nodes would be considered as a hub of each cluster.
%
% DBSresult.conMat_orig or DBSresult.conMat_height 
%     shows a set of significant edges from your hypothesis testing.
%     Edges with non-zero values are only significant.
% 
% CPresult.node contains a list of nodes having significant CP scores

%% When you re-run the above analysis with different icft.
icft_p = 0.05; % Set your icft
[DBSresult2, CPresult2] = dbs_only_run_correction(fileName, icft_p);

