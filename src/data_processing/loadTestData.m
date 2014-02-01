function TE_Actions = loadTestData(test_data_dir, verbose)
% load test data

d = dir(test_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TE_Actions = struct;

fprintf('Loading test data:\n');

for i=1:length(files)
%for i=1:53
    if verbose
        fprintf([files{i}, '...']);
    end
    
    file = [test_data_dir, files{i}];
    
    %% Feature extraction
    Features = extractFeatures(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TE_Actions(i).Observations = Features;
    TE_Actions(i).name = file_name;
    TE_Actions(i).label = label;
    
    if verbose
        fprintf('done.\n');        
    end
end

% save test data as .mat file
save('TE_Actions.mat', 'TE_Actions')
fprintf('Test data have been loaded.\n\n');