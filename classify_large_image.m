probThresh = .5;

load('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\large_test_images\P180424_05_16_2018_1c_tp0_z20_x848_y8065')
if exist('net')~=1
tic
display('loading network')
load('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\trained_networks\yolonetjb_cells_trained_manual_phenotype_1_rotated_2019_1_24_10_8_45')
toc
end


imCrop = testImage.imCrop;
imshow(imCrop)
hold on
[Ny Nx] = size(imCrop);

for y = 1:224:Ny-224
    for x = 1:224:Nx-224
        subImage = imCrop(y:y+223, x:x+223);
        for i = 1:3
            image(:,:,i) = im2uint8(imresize(subImage,[448 448]));
        end
        
        out = predict(net,image,'ExecutionEnvironment', 'gpu');
        
        coords1 = yolocellcoords(out, (length(out)/3)^.5, 224, probThresh);
        if ~isempty(coords1)
        coords2 = coords1+[x*ones(size(coords1, 1),1),y*ones(size(coords1, 1),1)];
        %hold on
            plot(coords2(:,1),coords2(:,2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
        end
        
    end
end

%{
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

%}