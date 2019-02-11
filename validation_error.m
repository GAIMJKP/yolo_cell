%Calculate performance statistics for various training ground truth
%protocols

probThresh = .5;

%switch for classifying only validation images (i.e. holdout images)
testOnly = 1;


if exist('outVector')~=1 || exist('trainImages')~=1
    tic
    display('loading training data');
    load(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1\Collated\train_data_manual_phenotype_1_rotated_2019_1_24_9_16_18'))
    toc
end

if exist('net')~=1
    tic
    display('loading network')
    load('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\trained_networks\yolonetjb_cells_trained_manual_phenotype_1_rotated_2019_1_24_10_8_45')
    toc
end
clearvars -except net trainImages outVector testOnly metaDataNet
if testOnly
    images = trainImages(:,:,:,metaDataNet.testIndices);
    outVector2 = outVector(metaDataNet.testIndices,:);
else
    images = trainImages;
    outVector2 = outVector;
end

for n = 1:size(images,4);
    for i = 1:3
        image(:,:,i) = im2uint8(imresize(images(:,:,i,n),[448 448]));
    end
    
    out = double(predict(net,image,'ExecutionEnvironment', 'gpu'));
    err(n) = (immse(out,outVector2(n,:)))^.5;
    
end

err_mean = mean(err);
std_err = std(err)/sqrt(length(err));
n_train = length(outVector);
n_val = length(outVector2);


