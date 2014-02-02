%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bin Liang (bin.liang.ty@gmail.com)
% Charles Sturt University
% Created:	Jan 2014
% Modified:	Jan 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step.1 -- Preparing for running
% clear variables
clear all; close all; clc;

% 1 -- display processing information, 0 -- just display final results
verbose = 1;  
feature_dim = 3 * 20;   % feature dimensionality

% cross validate or not
is_cv = 1;  % 1 -- yes; 0 -- no
if is_cv == 0
    %     | T1 | T2 | T3
    % AS1 |  7 |  9 |  6
    % AS2 |  9 |  8 |  5
    % AS3 |  3 |  8 | 10
    best_Q = 8; % if no cross validataion, 5 states number is default
end

% add to path
this_dir = pwd;
addpath(genpath(this_dir));

% set dataset path
data_path = 'D:\\Research\\Projects\\Dataset\\MSR Action3D\\dataset\\';

% specify the paths to training and  test data
test_subsets = {'test_one\\', 'test_two\\', 'cross_subject_test\\'};
action_subsets = {'AS1\\', 'AS2\\', 'AS3\\'};

performed_dataset_path = [data_path test_subsets{3}, action_subsets{3}];
training_data_dir = [performed_dataset_path, 'training\\skeleton\\'];
test_data_dir = [performed_dataset_path, 'test\\skeleton\\'];

%% Draw skeleton on screen
%drawSkeleton(2, 2, 1, 1, 1, 1, training_data_dir);

%% Step.2 -- Load training data
TR_Actions = loadTrainData(training_data_dir, verbose);

%% Step.3 -- Load test data
TE_Actions = loadTestData(test_data_dir, verbose);

%% Step.4 -- recognition using HMM
% parameters for HMM
param.O = feature_dim;  % dimensionality of feature vector of each frame in an action sequence
param.Q = 5;   % number of states (default)
param.M = 2;    % number of mixtures
param.cov_type = 'diag'; % cov_type: 'full', 'diag', 'spherical'
param.max_iter = 10;    % number of iterations
param.verbose = verbose;

%% Step4.1 -- Cross Validation
if is_cv == 1
    candidates_Q = 3:10;
    num_folds = 5;  % number of folds
    best_Q = crossValidate(TR_Actions, candidates_Q, num_folds, param);
end

%% Step4.2 -- Training
fprintf('HMM training.\n');
% best parameters for Q
param.Q = best_Q;   % number of states

% get hmm models
HMM_Models = hmmTrain(TR_Actions, param);

%% Step4.3 -- Testing
fprintf('HMM testing.\n');
[accuracy, predict_label, true_label] = hmmTest(TE_Actions, HMM_Models);
fprintf('accuracy: %.2f\n', accuracy);
pause(0.5);beep; pause(0.5);beep; pause(0.5);beep;