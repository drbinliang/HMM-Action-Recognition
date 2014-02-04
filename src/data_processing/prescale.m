function [Actions, scale_mu, scale_sigma] = prescale(Actions, scale_mu, scale_sigma)
% prescale data

data_num = length(Actions);
Full_Matrix = [];

%% Get full matrix
for i =1:data_num
    Full_Matrix = [Full_Matrix, Actions(i).Observations];
end

if nargin < 2
    scale_mu = mean(Full_Matrix, 2);
    scale_sigma = std(Full_Matrix, 0, 2);
    scale_sigma = scale_sigma + eps*(scale_sigma==0);
end

%% Scale
for i =1:data_num
    Actions(i).Observations = standardize(Actions(i).Observations, scale_mu, scale_sigma);
end

end

