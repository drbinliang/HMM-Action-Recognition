function HMM_Models = hmmTrain(TR_Actions, param)
% training using hmm

%% HMM parameters
Q = param.Q;
O = param.O;
M = param.M;
cov_type = param.cov_type;
max_iter = param.max_iter;

%% Preparation for HMM
training_number = length(TR_Actions);
all_labels = zeros(training_number, 1);

for i = 1:training_number
    all_labels(i) = TR_Actions(i).Label;
end

labels = unique(all_labels);
label_number = size(labels, 1);

HMM_Models = struct;

%% Training models
for i = 1:label_number
    Train_Data = [];
    label = labels(i);
    HMM_Models(i).Label = label;
    
    for j = 1:training_number
        if TR_Actions(j).Label == label
            Train_Data = [Train_Data, TR_Actions(i).Observations];
        end    
    end
    
    %% HMM training
    % normalization by standard deviation
    Train_Data = normalizeByStd(Train_Data);
     
    % parameters initialization
    initializeParam()
    
    % initial guess (Bakis model)
    [prior0, transmat0, mu0, sigma0, mixmat0] = initializaParam(Train_Data, Q, M, cov_type);
    
    %  improve guess by using iterations of EM
    [LL, prior1, transmat1, mu1, sigma1, mixmat1] = mhmm_em(Train_Data, prior0, transmat0, mu0, sigma0, mixmat0, 'max_iter', max_iter);
    
    HMM_Models(i).LL = LL;
    HMM_Models(i).Prior = prior1;
    HMM_Models(i).Transmat = transmat1;
    HMM_Models(i).Mu = mu1;
    HMM_Models(i).Sigma = sigma1;
    HMM_Models(i).Mixmat = mixmat1;
end


