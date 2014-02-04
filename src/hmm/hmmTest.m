function [accuracy, predict_label, true_label] = hmmTest(TE_Actions, HMM_Models)

model_number = length(HMM_Models); % model number
test_number = length(TE_Actions);
true_label = zeros(test_number, 1);
predict_label = zeros(test_number, 1);

prob_scores = zeros(test_number, model_number);
count = 0;
for i = 1:test_number
    % get true label
    true_label(i) = TE_Actions(i).label;
    for j = 1:model_number
        data = TE_Actions(i).Observations;
        prob_scores(i, j) = mhmm_logprob(data, HMM_Models(j).prior, ...
            HMM_Models(j).transmat, HMM_Models(j).mu, ...
            HMM_Models(j).sigma, HMM_Models(j).mixmat);
    end
    
    [max_prob, idx] = max(prob_scores(i,:));
    predict_label(i) = HMM_Models(idx).label;
    
    if predict_label(i) == true_label(i)
        count = count + 1;
    end
end

accuracy = count / test_number;



