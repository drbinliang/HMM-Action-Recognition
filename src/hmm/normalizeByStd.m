function X = normalizeByStd(X)
% normalization by standard deviation
X = X - repmat(mean(X), [size(X, 1) 1]);
X = X ./ repmat(sqrt(sum(X .^ 2)), [size(X, 1) 1]);