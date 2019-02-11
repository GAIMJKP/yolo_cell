probThresh = 0.9;

if exist('outVector')~=1 || exist('trainImages')~=1
    tic
    display('loading training data');
    load(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_2\Train_Data_V2_2019_1_4_12_37_48'))
    toc
end

for z = 1:1:size(trainImages,4);
    
    for i = 1:3
        image(:,:,i) = imresize(trainImages(:,:,i,z),[448 448]);
    end
    
    [Ny Nx] = size(image);
    
    coords = yolocellcoords(outVector(z,:), (size(outVector,2)/3)^.5, Ny, probThresh);
    
    imshow(image);
    
    hold on
    if isempty(coords) ~= 1
        plot(coords(:,1),coords(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off
    %pause(1.5);
    pause
end