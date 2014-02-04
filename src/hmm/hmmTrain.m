function HMM_Models = hmmTrain(TR_Actions, param)
% training using hmm

%% HMM parameters
Q = param.Q;
O = param.O;
M = param.M;
cov_type = param.cov_type;
max_iter = param.max_iter;
verbose = param.verbose;

%% Preparation for HMM
training_number = length(TR_Actions);
all_labels = zeros(training_number, 1);

% get labels
for i = 1:training_number
    all_labels(i) = TR_Actions(i).label;
end

labels = unique(all_labels);
label_number = size(labels, 1);

HMM_Models = struct;

%% Training models
for i = 1:label_number
    % each element in cell array is a sequence with dimensionality of 
    % 60 * T (T is the length of sequence)
    Train_Data = cell(1, 1);    
    label = labels(i);
    HMM_Models(i).label = label;
    
    %% get all the training data with the same label
    for j = 1 : training_number
        if TR_Actions(j).label == label
            len = size(Train_Data, 2);
            if isempty(Train_Data{len})
                Train_Data{len} = TR_Actions(j).Observations;
            else
                Train_Data{len + 1} = TR_Actions(j).Observations;
            end            
        end
    end
        
    %% HMM training
    % initial guess (Bakis model)
    model_type = 2;   % model type: 1 - 'ergodic', 2 - 'bakis'
    [prior0, transmat0, mu0, sigma0, mixmat0] = initializeParam(...
        Train_Data, Q, O, M, cov_type, model_type);
    
    %  improve guess by using iterations of EM
    [LL, prior1, transmat1, mu1, sigma1, mixmat1] = mhmm_em(...
        Train_Data, prior0, transmat0, mu0, sigma0, mixmat0,...
        'max_iter', max_iter, 'cov_type', cov_type, 'verbose', verbose);
    
    HMM_Models(i).LL = LL;
    HMM_Models(i).prior = prior1;
    HMM_Models(i).transmat = transmat1;
    HMM_Models(i).mu = mu1;
    HMM_Models(i).sigma = sigma1;
    HMM_Models(i).mixmat = mixmat1;
end


