clearvars -except lgraph 
addpath('M:\NIH\Code_M3\Code_Jamey\U18_functions');
cd('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1')
dirmat= dir('*.mat');
c = 7; %break image into cxc cells
numImages = length(dirmat);
load(dirmat(1).name)
imSize = size(trainData.trainImage,1);
cellWidth = imSize/c;

for i = 1:numImages
    for r = 0:3
    i = i
    load(dirmat(i).name)
    [cellsCoordsRelative, trainImage] = rotateImage(trainData.cellsCoordsRelative, trainData.trainImage, r*90);
    
    
    outVector(i+r*numImages,:) = yolocellvector(c,imSize,cellsCoordsRelative);
    
    for j = 1:3
    trainImages(:,:,j,i+r*numImages) = trainImage;
    end
        metaData(i+r*numImages).imagecenterxyz = trainData.imagecenterxy;
        metaData(i+r*numImages).name = trainData.name;
        metaData(i+r*numImages).sampleNumber = trainData.imageNumber;
        metaData(i+r*numImages).groundTruth = 'manual';
        metaData(i+r*numImages).dimensions = [imSize imSize];
        metaData(i+r*numImages).rotate = r*90;
    end
end

c = clock;
c = fix(c);
cd('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1\Collated')
fileName = strcat('train_data_manual_phenotype_1','_rotated_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)),'.mat');    
save(fileName,'trainImages','outVector','metaData');



