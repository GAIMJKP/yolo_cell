probThresh = .5;

%switch for classifying only validation images (i.e. holdout images)
testOnly = 1;
showGroundTruth = 1;
%addpath('M:\NIH\Code_M3\Code_Jamey\U18_functions')

if exist('outVector')~=1 || exist('trainImages')~=1
    tic
    display('loading training data');
    load(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Coins\train_data_coins_staggered_2019_1_22_9_58_39'))
    toc
end

if exist('net')~=1
    tic
    display('loading network')
    load('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\trained_networks\yolonetjb_cells_trained_coins_staggered_2019_1_22_13_31_30')
    toc
end

if testOnly
    images = trainImages(:,:,:,metaDataNet.testIndices);
    outVector2 = outVector(metaDataNet.testIndices,:);
else
    images = trainImages;
    outVector2 = outVector;
end



for z = 1:1:size(images,4);
    for i = 1:3
        image(:,:,i) = im2uint8(imresize(images(:,:,i,z),[448 448]));
    end
    
    [Ny Nx] = size(image);
    
    tic
    out = predict(net,image,'ExecutionEnvironment', 'gpu');
    toc
    
    %plot prediction in green
    coords1 = yolocellcoords(out, (length(out)/3)^.5, Ny, probThresh);
    imshow(image);
    hold on
    if isempty(coords1) ~= 1
        plot(coords1(:,1),coords1(:,2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    end
    
    %plot ground truth in red
    if showGroundTruth
        coords2 = yolocellcoords(outVector2(z,:), (length(out)/3)^.5, Ny, probThresh);
        if isempty(coords2) ~= 1
            plot(coords2(:,1),coords2(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
        end
    end
    hold off
    pause;
    %pause(1.5);
end