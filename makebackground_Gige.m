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
img_array = zeros(128,128,10);

%% background image

for i = 1:10
    img = snapshot(g);
    img_array(:,:,i) = img;

end
%%
background_sum = sum(img_array,3);
%%
background_array = background_sum/(i);
%%
save('background_array_128.mat','background_array')