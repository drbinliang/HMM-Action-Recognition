function [prior0, transmat0, mu0, sigma0, mixmat0] = initializeParam( ...
    data, Q, O, M, cov_type, model_type)
% model type: 1 - 'ergodic', 2 - 'bakis'

switch model_type
    case 1
        % ergodic model
        prior0 = normalise(rand(Q,1));
        transmat0 = mk_stochastic(rand(Q,Q));
    case 2
        % bakis model
        level = 2;  % levels of bakis model
        [prior0, transmat0] = initByBakis(Q, level);
end

%% method 1
State_matrix = cell(Q,1);
training_number = length(data);
for i = 1 : training_number
    Sequence = data{i};
    len = size(Sequence,2);
    
    % divide the sequence to Q subsequences in average, 
    % the length of each subsequences is t
    t = floor(len / Q);
    for j = 1 : Q,
        begin_index = (j-1) * t + 1;
        Subsequence = Sequence(:, begin_index : begin_index + t -1);        
        State_matrix{j} = horzcat(State_matrix{j}, Subsequence);
    end
end

mu0 = zeros(O, Q, M);
sigma0 = zeros(O, O, Q, M);

for j = 1 : Q, 
    [mu0(:, j, :), sigma0(:, :, j, :)] = mixgauss_init(M, State_matrix{j}, cov_type); 
end

mixmat0 = mk_stochastic(rand(Q, M));

%% Method2
% training_number = length(data);
% 
% % each column of State_matrix{i} is a feature vector
% State_matrix = cell(Q, M);
% data_num_per_mix = floor(training_number / M);
% 
% for i = 1:M
%     for j = 1:data_num_per_mix
%         Sequence = data{(i - 1) * data_num_per_mix + j};
%         
%         % length of the sequence
%         len = size(Sequence, 2);
%         
%         % divide the sequence to Q subsequences in average, 
%         % the length of each subsequences is t
%         t = floor(len / (Q-1));
%         
%         % group observations of the same state together
%         for k = 1:(Q-1)
%             begin_index = (k-1) * t + 1;
%             Subsequence = Sequence(:, begin_index : begin_index + t -1);
%             State_matrix{k} = [State_matrix{k}, Subsequence];
%         end
%     end
% end
% 
% mu0 = zeros(O, Q, M);
% sigma0 = zeros(O, O, Q, M);
% 
% for i = 1:(Q-1)
%     [mu0(:, i, :), sigma0(:, :, i, :)] = mixgauss_init(M, State_matrix{i}, cov_type); 
%     sigma0(:, :, i, :) = repmat(eye(O), [1, 1, 1, M]);
% end
% 
% mixmat0 = ones(Q, M);
% mixmat0(Q, 2 : end) = 0; 
% sigma0(:, :, Q, :) = repmat(eye(O), [1, 1, 1, M]);

%% method 3
% [mu0, sigma0] = mixgauss_init(Q * M,  cell2mat(data), cov_type);
% mu0 = reshape(mu0, [O Q M]);
% sigma0 = reshape(sigma0, [O O Q M]);
% mixmat0 = mk_stochastic(rand(Q, M));

