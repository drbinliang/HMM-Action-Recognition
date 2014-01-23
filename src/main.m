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

% training_data_dir = [data_path test_subsets{1} 'training\\' action_subsets{1}];
% test_data_dir = [data_path test_subsets{1} 'test\\' action_subsets{1}];

performed_dataset_path = [data_path test_subsets{1}, action_subsets{1}];
training_data_dir = [performed_dataset_path, 'training\\skeleton\\'];
test_data_dir = [performed_dataset_path, 'test\\skeleton\\'];

%% Draw skeleton on screen
%drawSkeleton(2, 2, 1, 3, 1, 1, training_data_dir);


%% Load training data
d = dir(training_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TR_Actions = struct;
feature_dim = 3 * 20;   % feature dimensionality
train_label = zeros(length(files), 1);
train_data = zeros(length(files), feature_dim);

fprintf('Loading training data:\n');
%for i=1:length(files)
for i=1:27
    fprintf([files{i}, '...']);
    
    file = [training_data_dir, files{i}];
    
    %% Feature extraction
    Features = featureExtraction(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TR_Actions(i).Observations = Features;
    TR_Actions(i).Name = file_name;
    TR_Actions(i).Label = label;
    
    fprintf('done.\n');        
end

% save training data as .mat file
save('TR_Actions.mat', 'TR_Actions');

%% Load test data
d = dir(test_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TE_Actions = struct;
test_label = zeros(length(files), 1);
test_data = zeros(length(files), feature_dim);

fprintf('Loading test data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    file = [test_data_dir, files{i}];
    
    %% Feature extraction
    Features = featureExtraction(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TE_Actions(i).Observations = Features;
    TE_Actions(i).Name = file_name;
    TE_Actions(i).Label = label;
    
    fprintf('done.\n');        
end

% save test data as .mat file
save('TE_Actions.mat', 'TE_Actions')

%% recognition using HMM
%% Training
% parameters for HMM
param.O = feature_dim;
param.Q = 5;
param.M = 2;
param.cov_type = 'diag'; % cov_type: 'full', 'diag', 'spherical'
param.max_iter = 10;

% get hmm models
HMM_Models = hmmTrain(TR_Actions, param);

[predict, accuracy] = hmmTest(TE_Actions, HMM_Models);
pause(0.5);beep; pause(0.5);beep; pause(0.5);beep;