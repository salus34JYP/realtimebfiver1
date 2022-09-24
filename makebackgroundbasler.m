%% clear
close all 
clear
clc

%% background image
background_array = zeros(128,128,'double');

for i = 0:9

    str = string(i);
    name = strcat('Basler_acA1300-60gmNIR__24337866__20220924_134811396_000',str,'.tiff');
    background = imread(name);
    background = cast(background,'double');
    background_array = background_array + background;

end

background_array = background_array/(i+1);
save('background_array_128.mat','background_array')