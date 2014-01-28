function Features = extractFeatures(file)
% extract features from input file

%% Reshape data 
fp = fopen(file);
if fp > 0
    items = fscanf(fp, '%f');
    fclose(fp);
end
len = size(items, 1) / 4;   % number of the total joint points
Joint_Matrix = reshape(items, [4 len]);
Joint_Matrix = Joint_Matrix(1:3,:); % 1st row: X, 2nd row: Z, 3rd row: Y

% adjust the coordinates
Joint_Matrix(2,:) = 400 - Joint_Matrix(2,:);
Joint_Matrix(3,:) = Joint_Matrix(3,:) / 4;

frame_number = size(Joint_Matrix, 2) / 20;
Frames = reshape(Joint_Matrix, [3 20 frame_number]);

%% Feature extraction
Features = zeros(60, frame_number);
for i = 1:frame_number
    Single_Frame = Frames(:, :, i);
    Single_Frame = Single_Frame';
    
    % treat hip center coordiante as the relative coordinate
    relative_coordinate = Single_Frame(7,:);    
    Single_Frame_Tmp = Single_Frame;
    Single_Frame_Tmp(:, 1) = Single_Frame(:, 1) - relative_coordinate(1);
    Single_Frame_Tmp(:, 2) = Single_Frame(:, 2) - relative_coordinate(2);
    Single_Frame_Tmp(:, 3) = Single_Frame(:, 3) - relative_coordinate(3);
    
    feature = reshape(Single_Frame_Tmp, [60 1]);
    Features(:, i) = feature;
end