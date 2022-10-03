%%
clc
clear
close all
%%
gc = gigecamlist;
%%
gc_address = gc.IPAddress;
gc_string = string(gc_address);
% %%
% gigecam
%%
g = gigecam(gc_string, 'PixelFormat', 'Mono12');
%%
g.AcquisitionFrameRateAbs = 10;
g.AcquisitionFrameRateEnable ='True';
g.Width = 128;
g.Height = 128;
g.OffsetY = 460;
g.OffsetX = 540;
g.Timeout = 15;
img_array = zeros(128,128,20);
%%
tic
for i = 1:20
    img = snapshot(g);
    img_array(:,:,i) = img;

end
total_time = toc;
mean_time = toc/i;
framerate = 1/mean_time;
%%
for j = 1:20
    colormap('hot');
    imagesc(img_array(:,:,j));
    colorbar();
    pause(0.5);
end