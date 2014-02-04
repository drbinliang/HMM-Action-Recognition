function Actions = loadData(data_dir, verbose)
% load training data
d = dir(data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

Actions = struct;

for i=1:length(files)
    if verbose
        fprintf([files{i}, '...']);
    end
    
    file = [data_dir, files{i}];
    
    % feature extraction
    Features = extractFeatures(file);  
    
    % scale feature
    Scaled_Features = standardize(Features);
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    Actions(i).Observations = Scaled_Features;
    %Actions(i).Observations = Features;
    Actions(i).name = file_name;
    Actions(i).label = label;
    
    if verbose
        fprintf('done.\n');        
    end
end
