%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bin Liang (bin.liang.ty@gmail.com)
% Charles Sturt University
% Created:	Jan 2014
% Modified:	Jan 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preparing for running
% clear variables
clear all; close all; clc;

% add to path
this_dir = pwd;
addpath(genpath(this_dir));

% set dataset path
data_path = 'D:\\Research\\Projects\\Dataset\\MSR Action3D\\dataset\\';

% specify the paths to training and  test data
test_subsets = {'test_one\\', 'test_two\\', 'cross_subject_test\\'};
action_subsets = {'AS1\\', 'AS2\\', 'AS3\\'};

performed_dataset_path = [data_path test_subsets{2}, action_subsets{3}];
training_data_dir = [performed_dataset_path, 'training\\skeleton\\'];
test_data_dir = [performed_dataset_path, 'test\\skeleton\\'];

%% Draw skeleton on screen
%drawSkeleton(2, 2, 1, 1, 1, 1, training_data_dir);

%% Load training data
d = dir(training_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TR_Actions = struct;
feature_dim = 3 * 20;   % feature dimensionality

fprintf('Loading training data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    file = [training_data_dir, files{i}];
    
    %% Feature extraction
    Features = extractFeatures(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TR_Actions(i).Observations = Features;
    TR_Actions(i).name = file_name;
    TR_Actions(i).label = label;
    
    fprintf('done.\n');        
end

% save training data as .mat file
save('TR_Actions.mat', 'TR_Actions');

%% Load test data
d = dir(test_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TE_Actions = struct;

fprintf('Loading test data:\n');
for i=1:length(files)
%for i=1:53
    fprintf([files{i}, '...']);
    
    file = [test_data_dir, files{i}];
    
    %% Feature extraction
    Features = extractFeatures(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TE_Actions(i).Observations = Features;
    TE_Actions(i).name = file_name;
    TE_Actions(i).label = label;
    
    fprintf('done.\n');        
end

% save test data as .mat file
save('TE_Actions.mat', 'TE_Actions')

%% recognition using HMM
%% Training
% parameters for HMM
param.O = feature_dim;  % dimensionality of feature vector of each frame in an action sequence
param.Q = 5;   % number of states
param.M = 2;    % number of mixtures
param.cov_type = 'diag'; % cov_type: 'full', 'diag', 'spherical'
param.max_iter = 10;    % number of iterations

% get hmm models
HMM_Models = hmmTrain(TR_Actions, param);

%% Test
[accuracy, predict_label, true_label] = hmmTest(TE_Actions, HMM_Models);
fprintf('accuracy: %.2f\n', accuracy);
pause(0.5);beep; pause(0.5);beep; pause(0.5);beep;