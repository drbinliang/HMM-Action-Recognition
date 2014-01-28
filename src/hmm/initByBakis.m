function [prior, transmat] = initByBakis(Q, level)

prior = zeros(Q, 1);
prior(1) = 1;

transmat = prior_transition_matrix(Q, level);

end