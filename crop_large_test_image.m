% crops a large test image and saves with metadata

clearvars -except image_temp
close all

uinput1{1} = '1';
try
    uinput1 = newid(strcat('Enter Sample Number'));
catch
    uinput1 = inputdlg(strcat('Enter Sample Number'));
end
m =str2num(uinput1{1});

load('M:\NIH\Code_M3\Sample.mat')
str1 = Sample(m).name;
shortName = extractBetween(str1,'U18_','\stack');
cd(strcat(Sample(m).name,'\488'));

dirtif = dir('*.tif');
Nz = length(dirtif);

try
    uinput2 = newid(strcat('Enter stack number z (max= ',num2str(Nz),') or enter 0 to exit stack'));
catch
    uinput2 = inputdlg(strcat('Enter stack number z (max= ',num2str(Nz),') or enter 0 to exit stack'));
end

z = str2num(uinput2{1});
if z >= 0 && z<= Nz
    validcheck = 1;
else
    validcheck = 0;
end

disp('Loading image');
image_temp = imread(dirtif(z).name);
imshow(image_temp);
title(strcat(shortName{1},44,32,'z =',32,num2str(z)),'Interpreter', 'none');
hold on
disp('Pan, zoom, etc and press enter when ready to crop');
pause;
disp(strcat('Click two points for bounding box of crop and hit enter'));

roi = ginput(2);

xmax = floor(max(roi(:,1)));
ymax = floor(max(roi(:,2)));
xmin = floor(min(roi(:,1)));
ymin = floor(min(roi(:,2)));

plot([xmax xmax],[ymin ymax],'g-')
plot([xmin xmin],[ymin ymax],'g-')
plot([xmin xmax],[ymin ymin],'g-')
plot([xmin xmax],[ymax ymax],'g-')
pause(2);

close all

imCrop = image_temp(ymin:ymax, xmin:xmax);

testImage.imCrop = imCrop;
testImage.coords = [xmin, xmax, ymin, ymax];
testImage.sampleNum = m;
testImage.z = z;

imagecenterxy = [(xmax-xmin)/2, (ymax-ymin)/2];
filename = strcat(shortName{1},'_z',num2str(z),'_x',num2str(floor(imagecenterxy(1))),'_y',num2str(floor(imagecenterxy(2))));
savepath = strcat(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\large_test_images\',filename));
save(savepath, 'testImage')


