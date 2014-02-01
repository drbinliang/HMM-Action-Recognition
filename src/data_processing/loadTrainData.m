function TR_Actions = loadTrainData(training_data_dir, verbose)
% load training data
d = dir(training_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TR_Actions = struct;

fprintf('Loading training data:\n');

for i=1:length(files)
    if verbose
        fprintf([files{i}, '...']);
    end
    
    file = [training_data_dir, files{i}];
    
    %% Feature extraction
    Features = extractFeatures(file);    
    
    % additional information
    file_name = files{i};
    label = str2double(file_name(2:3));

    % save data
    TR_Actions(i).Observations = Features;
    TR_Actions(i).name = file_name;
    TR_Actions(i).label = label;
    
    if verbose
        fprintf('done.\n');        
    end
end

% save training data as .mat file
save('TR_Actions.mat', 'TR_Actions');
fprintf('Training data have been loaded.\n\n');