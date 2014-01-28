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

