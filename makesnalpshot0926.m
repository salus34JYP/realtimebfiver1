%%
clear 
clc
close all

%%
v = videoinput("gentl", 1, "Mono12");
% imaqhwinfo(v)
v.ROIPosition = [560  405  128  128];
src = getselectedsource(v);
src.AutoTargetValue = 2048;
src.ExposureTimeAbs = 2000;
src.ExposureTimeRaw = 2000;
src.AcquisitionFrameRateAbs = 10;

%%
image1 = getsnapshot(v);

% Set the desired file location and name.
filelocation = "C:\Users\LENOVO\Desktop\9월\0926\128desktop\green_re";
filename = "snapshot1.tif";
fullFilename = fullfile(filelocation, filename);

% Write image data to file.
imwrite(image1, fullFilename, "tiff");
%%
for i = 1:10
    img = getsnapshot(v);
    colormap('hot')
    imagesc(img);
    colorbar();
    str = string(i);
    filelocation = "C:\Users\LENOVO\Desktop\9월\0926\128desktop\green_re";
    filename = strcat('test_q',str,'.tiff');
    fullFilename = fullfile(filelocation, filename);
    
    imwrite(img,fullFilename,"tiff");
    pause(0.1);
end
%%
numFrames = 10;
v.FramesPerTrigger = numFrames;

start(v);
wait(v);
stop(v);
img2 = v;
colormap('hot')
imagesc(img2);
colorbar();
% recording2 = getdata(v, numFrames);
%%
a = imread('test_1287.tiff');
colormap('hot')
imagesc(a);
colorbar();