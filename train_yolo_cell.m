reset(gpuDevice(1));
fileName = 'train_data_manual_phenotype_1_rotated_2019_1_24_9_16_18';
groundTruth = 'manual_phenotype_1_rotated';
if exist('outVector')~=1 || exist('trainImages')~=1
    tic
    display('loading training data');
    load(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1\Collated\',fileName))
    toc
end


if exist('lgraph')~=1
    tic
    display('loading network')
    load('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\trained_networks\pretrained_network_yolo_coin_trained_input_norm')
    toc
end

clearvars -except lgraph trainImages outVector fileName groundTruth

sizeTrain = size(trainImages);
trainImages2 = uint8(zeros(448,448,3,sizeTrain(4)));
display('resizing images')
for i = 1:sizeTrain(4);
    
    for c = 1:3
        trainImages2(:,:,c,i) = im2uint8(imresize(trainImages(:,:,c,i),[448 448]));
    end
end
%outVector2 = transpose(outVector);

outVector2 = outVector;
numTest = floor(length(outVector)/8);
testIndices = randperm(size(trainImages2,4),numTest);
imValidation = trainImages2(:,:,:,testIndices);
trainImages2(:,:,:,testIndices) = [];
outVectValidation = outVector2(testIndices,:);
outVector2(testIndices,:) = [];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',16, ...
    'MaxEpochs',8, ...
    'InitialLearnRate',1e-3, ...
    'ValidationFrequency',10, ...
    'ValidationData',{imValidation,outVectValidation},...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu', ...
    'Verbose',false, ...
    'L2Regularization',0.0001);

net = trainNetwork(trainImages2,outVector2,lgraph,options);

metaDataNet.options = options;
metaDataNet.testIndices = testIndices;
metaDataNet.trainData = fileName;
c = clock;
c = fix(c);
cd('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\trained_networks')
fileName = strcat('yolonetjb_cells_trained_',groundTruth,'_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)),'.mat');
save(fileName, 'net','metaDataNet');
fileName = strcat('yolonetjb_cells_trained_',groundTruth,'_',num2str(c(1)),'_',num2str(c(2)),'_',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(c(6)));
saveas(findall(groot, 'Type', 'Figure'),fileName,'tiff');