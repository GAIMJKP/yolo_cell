
load('M:\NIH\Code_M3\Sample.mat')


addpath('M:\NIH\Code_M3\Code_Jamey\U18_functions');
sampleRange = [6,9,10,13];
%specify z limits (inclusive)
zLimits = [22,32;22,30;20,26;18,20];
imSize = 224;
numCells = 7;
counter = 0;
zlCounter = 0;
for m = sampleRange
    zlCounter =  zlCounter+1;
    %load cellsout
    load(strcat(Sample(m).name,'\488\CellsOut.mat'));
    % load croppedcube
    load(strcat(Sample(m).name,'\488\CroppedCube.mat'));
    
    shortName = strcat(Sample(m).name,'\CroppedCube');
    sampleNumber = m;
    [Ny Nx Nz] = size(IC_8b);
    
    %put Cells_Dnorm into x,y,z rather than y,x,z.
    allCoords(:,1) = Cells_Dnorm(:,2);
    allCoords(:,2) = Cells_Dnorm(:,1);
    allCoords(:,3) = Cells_Dnorm(:,3);
    
    
    
    for z = zLimits(zlCounter,1):zLimits(zlCounter,2)
        sampleNumber
        z = z
        for i = randi([1 112]):imSize:Ny-imSize
            for j = randi([1 112]):imSize:Nx-imSize
                imBounds = [j,i,z-1;j+imSize,i+imSize,z+1];
                counter = counter + 1;
                subIm488 = IC_8b(i:i+imSize-1,j:j+imSize-1,z);
                for c = 1:3
                    trainImages(:,:,c,counter) = subIm488;
                end
                
                indices = find(allCoords(:,1)>imBounds(1,1) & allCoords(:,1)<imBounds(2,1) ...
                    & allCoords(:,2)>imBounds(1,2) & allCoords(:,2)<imBounds(2,2) ...
                    & allCoords(:,3)>imBounds(1,3) & allCoords(:,3)<imBounds(2,3));
                coords = allCoords(indices,1:2);
                coords = coords - [j*ones(size(coords,1),1),i*ones(size(coords,1),1)];
                outVector(counter,:) = yolocellvector(numCells,imSize,coords);
                
                metaData(counter).imagecenterxyz = [j+imSize/2 i+imSize/2 z];
                metaData(counter).name = shortName;
                metaData(counter).sampleNumber = sampleNumber;
                metaData(counter).groundTruth = 'bucket';
                metaData(counter).dimensions = [imSize imSize];
                
                
            end
        end
    end
    clear allCoords
end
c = clock;
c = fix(c);
fileName = strcat('train_data_bucket_staggered','_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)),'.mat');
save(fileName,'trainImages','outVector','metaData');

