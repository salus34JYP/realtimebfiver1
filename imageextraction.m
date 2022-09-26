%%
clc
clear all
close all
%%
load("background_array_128.mat");
%%
tif_image = imread('test_b6.tiff');
tif_image = cast(tif_image,"double");
new_image = tif_image - background_array;
% tif_image = tif_image/16;
new_image = new_image/16;
% imshow("y.tiff")
% hold on
% colormap("hot");
% colorbar();

imagesc(new_image);
axis([0 128 0 128])
M = max(new_image,[],'all');
m = min(new_image,[],'all');
axis image
% title('Raw speckle image','FontSize',20);
% 
% str_r = {'red label ','Left hand','1cm'};
% text(320,360,str_r,'Color','w',"FontSize",15)
% 
% str_g = {'green label ', ...
%         'Right hand', ...
%         '1cm'};
% text(340,210,str_g,'Color','w',"FontSize",15)
% 
% str_o = {'orange label ', ...
%         'Right hand ', ...
%         '1.5cm'};
% text(80,210,str_o,'Color','w',"FontSize",15)
% 
% str_b = {'blue label ', ...
%         'Left hand ', ...
%         '1.5cm'};
% text(70,360,str_b,'Color','w',"FontSize",15)
% 
% ax = gca;
% ax.FontSize = 18;
% axis image
%
colormap("hot");
% imagesc(subtractimage);
colorbar();
title("0823 10mW 2ms laser speckle image")
% axis([0 512 0 512])
% axis image