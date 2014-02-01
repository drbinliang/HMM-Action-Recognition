function best_Q = crossValidate(data, candidates_Q, num_folds, param)
    % get best Q by cross validation

    num_data = length(data);
    num_Q = length(candidates_Q);
    param.verbose = 0;

    indices = crossvalind('Kfold', num_data, num_folds);

    for i = 1:length(indices)     
        data(i).index = indices(i);
    end

    accuracy = zeros(num_Q, num_folds);

    for i = 1:num_Q
        param.Q = candidates_Q(i);

        for j = 1 : num_folds
            test_index = j;

            % split data into training data and test data by cross validation
            [TR_Actions, TE_Actions] = splitData(data, test_index); 

            % training
            HMM_Models = hmmTrain(TR_Actions, param);

            % test
            accuracy(i, j) = hmmTest(TE_Actions, HMM_Models);
        end

    end
    [best_accuracy, idx] = max(mean(accuracy, 2));
    best_Q = candidates_Q(idx);
end

function [TR_Actions, TE_Actions] = splitData(data, test_index)
    % split data into training data and test data by cross validation
    TR_Actions = struct;
    TE_Actions = struct;
    
    len_tr = length(TR_Actions);
    len_te = length(TE_Actions);
    
    for i = 1:length(data)     
        if data(i).index == test_index
            TE_Actions(len_te).Observations = data(i).Observations;
            TE_Actions(len_te).name = data(i).name;
            TE_Actions(len_te).label = data(i).label;
            TE_Actions(len_te).index = data(i).index;
            
            len_te = len_te + 1;
        else
            TR_Actions(len_tr).Observations = data(i).Observations;
            TR_Actions(len_tr).name = data(i).name;
            TR_Actions(len_tr).label = data(i).label;
            TR_Actions(len_tr).index = data(i).index;
            
            len_tr = len_tr + 1;
        end
    end
end

