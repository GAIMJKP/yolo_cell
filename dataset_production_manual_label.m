% requires m-file newid.m copied to location of inputdlg.m. find correct
% folder using which -all inputdlg

clearvars -except image_temp
close all

sampleRange = [10];
%choose image size (training image pixel width) such that a maximum of 7 cells
%will fit in the width. i.e. imageSize < 7 times mean cell spacing in pixels
%224 is good for dark nuclei smaller cells, 448 is good for larger
%"phenotype 2" cells.
imageSize = 224;
try % DG
    load('M:\NIH\Code_M3\Sample.mat')
catch
    namePC = 'M:\NIH\Code_M3\Sample.mat';
    nameMAC  = namePC;
    for i = 1:length(namePC)
        if strcmp(namePC(i),'\')
            nameMAC(i) = '/';
        end
    end
    nameMAC(1:2) = [];
    nameMAC = strcat('/Volumes/DGshare-1', nameMAC);
    load(nameMAC)
end





for m = sampleRange
    str1 = Sample(m).name;
    shortName = extractBetween(str1,'U18_','\stack');
    
    
    try % DG
        cd(strcat(Sample(m).name,'\488'));
    catch
        
        Name =Sample(m).name;
        for i = 1:length(Name)
            if strcmp(Name(i),'\')
                Name(i) = '/';
            end
        end
        Name(1:2) = [];
        Name = strcat('/Volumes/DGshare-1', Name);
        cd(strcat(Name,'/488'));
        
    end
    
    dirtif = dir('*.tif');
    Nz = length(dirtif);
    uinput1{1} = '1';
    z = 0;
    while str2num(uinput1{1}) ~= 0
        close all
        validcheck = 0;
        while validcheck == 0
            try
                uinput1 = newid(strcat('Enter stack number z (max= ',num2str(Nz),') or enter 0 to exit stack'));
            catch
                uinput1 = inputdlg(strcat('Enter stack number z (max= ',num2str(Nz),') or enter 0 to exit stack'));
            end
            z = str2num(uinput1{1});
            if z >= 0 && z<= Nz
                validcheck = 1;
            else
                validcheck = 0;
            end
        end
        if str2num(uinput1{1}) ~= 0
            disp('Loading image');
            image_temp = imread(dirtif(z).name);
            imshow(image_temp);
            title(strcat(shortName{1},44,32,'z =',32,num2str(z)),'Interpreter', 'none');
            hold on
            uinput3{1} = '1';
            while str2num(uinput3{1}) ~= 0
                disp('Pan, zoom, etc and press enter when ready to label cells');
                pause;
                disp(strcat('Click center of',32,num2str(imageSize),'x',num2str(imageSize),32,'pixel region containing cells'));
                boxcoords = ginput(1);
                xmin = floor(boxcoords(1)-imageSize/2);
                xmax = floor(boxcoords(1)+imageSize/2);
                ymin = floor(boxcoords(2)-imageSize/2);
                ymax = floor(boxcoords(2)+imageSize/2);
                h1(1) = plot([xmax xmax],[ymin ymax],'g-');
                h1(2) = plot([xmin xmin],[ymin ymax],'g-');
                h1(3) = plot([xmin xmax],[ymin ymin],'g-');
                h1(4) = plot([xmin xmax],[ymax ymax],'g-');
                disp('Double click centers of all cells and hit enter when all cells are labelled');
                counter = 0;
                temp = 1;
                
                while 1
                    w = waitforbuttonpress;
                    if w == 0
                        try
                            counter = counter+1;
                            cells(counter,:) = ginput(1);
                            h2(counter) = plot(cells(counter,1),cells(counter,2),'r+');
                        catch
                            break
                        end
                    else
                        break
                    end
                end
                %     for i = 1:size(cells,1)
                %     plot(cells(i,1),cells(i,2),'r+')
                %     end
                validcheck = 0;
                while validcheck == 0
                    try
                        uinput2 = newid('Enter 1 to keep image, 0 to discard');
                    catch
                        uinput2 = inputdlg('Enter 1 to keep image, 0 to discard');
                    end
                    input2 = str2num(uinput2{1});
                    if input2 == 1 || input2 == 0
                        validcheck = 1;
                    else
                        validcheck = 0;
                    end
                end
                
                if str2num(uinput2{1}) == 1
                    trainData.trainImage = imcrop(image_temp,[xmin ymin imageSize-1 imageSize-1]);
                    trainData.cellsCoordsAbsolute(:,1) = cells(:,1) ;
                    trainData.cellsCoordsAbsolute(:,2) = cells(:,2) ;
                    trainData.cellsCoordsRelative(:,1) = cells(:,1) - xmin;
                    trainData.cellsCoordsRelative(:,2) = cells(:,2) - ymin;
                    trainData.imagecenterxy = uint16(boxcoords);
                    trainData.name = shortName{1};
                    trainData.imageNumber = m;
                    trainData.z = z;
                    filename = strcat(shortName{1},'_z',num2str(z),'_x',num2str(trainData.imagecenterxy(1)),'_y',num2str(trainData.imagecenterxy(2)));
                    savepath = strcat(strcat('M:\NIH\Code_M3\Code_Jamey\YOLO_cell\Training_Data\Manual_Labelled_phenotype_1\',filename));
                    
                    
                    
                    try % DG
                        save(savepath, 'trainData')
                    catch
                        
                        Name =savepath;
                        for i = 1:length(Name)
                            if strcmp(Name(i),'\')
                                Name(i) = '/';
                            end
                        end
                        Name(1:2) = [];
                        Name = strcat('/Volumes/DGshare-1', Name);
                        %cd(strcat(Name,'/488'));
                        save(Name, 'trainData')
                    end
                    
                    
                    clear trainData
                    
                    clear cells_relative cells
                else
                    for i = 1:4
                        delete(h1(i));
                    end
                    for i = 1:counter
                        delete(h2(i));
                    end
                end
                validcheck = 0;
                while validcheck == 0
                    try
                        uinput3 = newid('Enter 1 to continue with this image, 0 move to new image in stack');
                    catch
                        uinput3 = inputdlg('Enter 1 to continue with this image, 0 move to new image in stack');
                    end
                    input3 = str2num(uinput3{1});
                    if input3 == 1 || input3 == 0
                        validcheck = 1;
                    else
                        validcheck = 0;
                    end
                end
                
                
            end
        else
        end
        
    end
end
