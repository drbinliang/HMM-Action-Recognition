function [prior0, transmat0, mu0, sigma0, mixmat0] = initializaParam(data, Q, M, cov_type)

prior0 = zeros(Q, 1);
prior0(1) = 1;  % initial state parameters

transmat0 = zeros(Q, Q);    % transmission parameters
for i = 1:Q - 2
    transmat0(i, i:i+2) = 1/3;
end
transmat0(Q-1,Q-1:Q) = 0.5;
transmat0(Q,Q) = 1;

[mu0, sigma0] = mixgauss_init(Q * M, data, cov_type);
mu0 = reshape(mu0, [O Q M]);
sigma0 = reshape(sigma0, [O O Q M]);
mixmat0 = mk_stochastic(rand(Q, M));