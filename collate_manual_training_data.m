clearvars -except lgraph
addpath('M:\NIH\Code_M3\Code_Jamey\U18_functions');
cd('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1')
dirmat= dir('*.mat');
c = 7; %break image into cxc cells
numImages = length(dirmat);
load(dirmat(1).name)
imSize = size(trainData.trainImage,1);
cellWidth = imSize/c;

for i = 1:length(dirmat)
    i = i
    load(dirmat(i).name)
    outVector(i,:) = yolocellvector(c,imSize,trainData.cellsCoordsRelative);
    for j = 1:3
        trainImages(:,:,j,i) = trainData.trainImage;
    end
    metaData(i).imagecenterxyz = trainData.imagecenterxy;
    metaData(i).name = trainData.name;
    metaData(i).sampleNumber = trainData.imageNumber;
    metaData(i).groundTruth = 'manual';
    metaData(i).dimensions = [imSize imSize];
end

c = clock;
c = fix(c);
cd('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1\Collated')
fileName = strcat('train_data_manual_phenotype_1','_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)),'.mat');
save(fileName,'trainImages','outVector','metaData');



