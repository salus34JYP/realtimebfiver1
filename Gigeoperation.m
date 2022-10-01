%%
clc
clear
close all
%%
gc = gigecamlist;
%%
gigecam
%%
g = gigecam('169.254.0.1', 'PixelFormat', 'Mono12')
%%
g.AcquisitionFrameRateAbs = 10;
g.OffsetY = 0;
g.OffsetX = 0;
g.Width = 1280;
g.Height = 1024;

%%
tic
for i = 1:20
    img = snapshot(g);
    %     colormap('hot')
%     imagesc(img);
%     colorbar();
%     drawnow

%     str = string(i);
%     filelocation = pwd;
%     filename = strcat('test_q',str,'.tiff');
%     fullFilename = fullfile(filelocation, filename);
%     
%     imwrite(img,fullFilename,"tiff");
%     colormap('hot')
%     imagesc(img)
%     colorbar();

end
total_time = toc;
eachtime = toc/20;
framerate = 1/eachtime;

%%
for j = 1:20

    str_2 = string(j);
    filelocation_2 = pwd;
    filename = strcat('test_q',str_2,'.tiff');
    img_2 = imread(filename);
    colormap('hot')
    imagesc(img_2);
    colorbar();
    
   
    pause(0.5);
end