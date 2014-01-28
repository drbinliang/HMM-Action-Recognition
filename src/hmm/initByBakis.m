function [prior, transmat] = initByBakis(Q, level)

    prior = zeros(Q, 1);
    prior(1) = 1;

    transmat = getPriorTransitionMatrix(Q, level);

end

function P = getPriorTransitionMatrix(Q, level)

    % LR is the allowable number of left-to-right transitions

    P = ((1/level))*eye(Q);

    for i=1:Q-(level-1)
        for j=1:level-1
            P(i,i+j) = 1/level;
        end
    end
    for i=Q-(level-2):Q
        for j=1:Q-i+1
            P(i,i+(j-1)) = 1/(Q-i+1);
        end
    end
end