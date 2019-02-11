clearvars -except im488 im785 class
close all

shortName = 'U18_P180424_05_16_2018_1c_tp0_mm\stack1'
sampleNumber = 11;

if exist('im488') ~= 1 || exist('im785') ~= 1
    load(strcat('M:\NIH\Confocal_Data\Post_RSG4\',shortName,'\composites\488\CroppedCube'));
    im488 = IC_8b;
    load(strcat('M:\NIH\Confocal_Data\Post_RSG4\',shortName,'\composites\785\CroppedCube'));
    im785 = IC_8b;
    load(strcat('M:\NIH\Confocal_Data\Post_RSG4\',shortName,'\composites\488\class'));
end

[Ny Nx Nz] = size(im488);
imSize = 224;
numCells = 7;
addpath('M:\NIH\Code_M3\Code_Jamey\U18_functions');
counter = 0;
for z = 6:26
    z = z
    for i = randi([1 112]):imSize:Ny-imSize
        for j = randi([1 112]):imSize:Nx-imSize
            counter = counter + 1;
            subIm785 = im785(i:i+imSize-1,j:j+imSize-1,z);
            subIm488 = im488(i:i+imSize-1,j:j+imSize-1,z);
            centroids = segment(subIm785);
            outVector(counter,:) = yolocellvector(numCells,imSize,centroids);
            for c = 1:3
                trainImages(:,:,c,counter) = subIm488;
            end
            metaData(counter).imagecenterxyz = [j+imSize/2 i+imSize/2 z];
            metaData(counter).name = shortName;
            metaData(counter).sampleNumber = sampleNumber;
            metaData(counter).groundTruth = 'acridine';
            metaData(counter).dimensions = [imSize imSize];
        end
    end
end

c = clock;
c = fix(c);
fileName = strcat('train_data_acridine_staggered','_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)),'.mat');
save(fileName,'trainImages','outVector','metaData');










