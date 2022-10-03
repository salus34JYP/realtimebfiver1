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

%%
fprintf('Please give your setting time.\n')
img_array = zeros(128,128,20);
framerate = 10;
Base_prompt = 'Baseline:';
stimulus_prompt = 'stimulus:';
release_prompt = 'release:';
channel_prompt = 'channel count:';
basetime = input(Base_prompt);
stimulustime = input(stimulus_prompt);
releasetime = input(release_prompt);
channel_num = input(channel_prompt);
baselineframe = basetime*60*framerate;
stimulusframe = stimulustime*60*framerate;
releaseframe = releasetime*60*framerate;
totalframe = baselineframe + stimulusframe + releaseframe;
frameline = 0:300:totalframe;
timeline = frameline/10;
stringframe = string(timeline);
%%
number_box = zeros(1,totalframe);

for i = 1:totalframe
    number_box(1,i) = fix(i/10);
end

%% pixel location
%                    b     g     o     r     s     y     p
pixel_location = [  44    63    83    22    90    15    50;
                    64    83   103    42   110    35    70;
                    17    97    30    83    66    43    59;
                    37   117    50   103    86    63    79;


];


sz = size(pixel_location(:,:));
load('background_array_128.mat');

%%
frame_label = zeros(1,totalframe,'double');
final_BFI = zeros(7,totalframe,'double');
final_BFI_std = zeros(7,totalframe,'double');
background_array = zeros(128,128,'double');
baseline_array = zeros(128,128,'double');
frame_array = zeros(128,128,'double');
BSsumimage = zeros(128,128,'double');
% %%
% tic
% for i = 1:20
%     img = snapshot(g);
%     img_array(:,:,i) = img;
% 
% end
% total_time = toc;
% eachtime = toc/20;
% framerate = 1/eachtime;

%% main loop

N = totalframe; % total number of frames
tic
for i = 1:N
    img = snapshot(g);
%     img_array(:,:,i) = img;
    frame_label(1,i) = i;

    for label = 1 : sz(1,2)
        BFI_box = zeros(9,1);

        for count = 1 : 9
            y = pixel_location(1,label) : 7 : pixel_location(1,label) + 20;
            x = pixel_location(3,label) : 7 : pixel_location(3,label) + 20;
            [Y,X] = meshgrid(y,x);
            y_n = numel(Y);
            X_m = numel(X);
            Y_pixel = reshape(Y, [y_n ,1]);
            X_pixel = reshape(X, [X_m ,1]);
            MEAN = mean(img(Y_pixel(count):Y_pixel(count)+6,X_pixel(count):X_pixel(count)+6),"all");
            STD = std(img(Y_pixel(count):Y_pixel(count)+6,X_pixel(count):X_pixel(count)+6),1,'all');
            K = STD/MEAN;
            BFI = 1/(K)^2;
            BFI_box(count,1) = BFI;
        end
             
         
        BFI_box_mean = mean(BFI_box(:,1));
        BFI_box_std = std(BFI_box(:,1));

        final_BFI(label,i+1) = BFI_box_mean;
        final_BFI_std(label,i+1)= BFI_box_std;
    end
    
    switch channel_num
        case 1 
            plot(frame_label,final_BFI(1,:),'.','Color','#0000FF')
            xlabel("times (s)")
            ylabel("BFI (A. U)")
            xticklabels(stringframe)
            title("Channel 1 Blood Flow Index vs times")
            if number_box(i+1) == fix((i+1)/10)
                round_bfi = round(final_BFI(1,number_box(i+1)+1),1);
                txt = sprintf('%.0f', round_bfi);
                final_bfi_text = num2str(txt);
                text(3550, max(final_BFI(1,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');
             
            end
            axis([-300 (totalframe+300) 0 max(final_BFI(1,:))+ max(final_BFI(1,:))*0.2])
            drawnow;

        case 2
            plot(frame_label,final_BFI(2,:),'.','Color','#00FF00')
            xlabel("times (s)")
            ylabel("BFI (A. U)")
            xticklabels(stringframe)
            title("Channel 2 Blood Flow Index vs times")

            if number_box(i+1) == fix((i+1)/10)
               round_bfi = round(final_BFI(2,number_box(i+1)+1),1);
               txt = sprintf('%.0f', round_bfi);
               final_bfi_text = num2str(txt);
               text(3550, max(final_BFI(2,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');
             
            end
            axis([-300 (totalframe+300) 0 max(final_BFI(2,:))+ max(final_BFI(2,:))*0.2])
            drawnow;
                 
        case 3
            subplot(2,1,1)
            plot(frame_label,final_BFI(1,:),'.','Color','#0000FF')
            xlabel("times (s)")
            ylabel("BFI (A. U)")
            xticks(frameline)
            xticklabels(stringframe)
            title("Channel 1 Blood Flow Index vs times")

            if number_box(i+1) == fix((i+1)/10)
                round_bfi = round(final_BFI(1,number_box(i+1)+1),1);
                txt = sprintf('%.0f', round_bfi);
                final_bfi_text = num2str(txt);
                text(totalframe-50, max(final_BFI(1,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');
            end
         
            axis([-300 (totalframe+300) 0 max(final_BFI(1,:))+ max(final_BFI(1,:))*0.2])
            drawnow;

            subplot(2,1,2)
            plot(frame_label,final_BFI(2,:),'.', 'Color','#00FF00')
            xlabel("times (s)")
            ylabel("BFI (A. U)")
            xticks(frameline)
            xticklabels(stringframe)
            title("Channel 2 Blood Flow Index vs times")  

            if number_box(i+1) == fix((i+1)/10)
               round_bfi = round(final_BFI(2,number_box(i+1)+1),1);
               txt = sprintf('%.0f', round_bfi);
               final_bfi_text = num2str(txt);
               text(totalframe-50, max(final_BFI(2,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');    
                 
             
            end    

            axis([-300 (totalframe+300) 0 max(final_BFI(2,:))+ max(final_BFI(2,:))*0.2])
            drawnow;    
         
                
                 
                 
        otherwise
            disp('other value')
          
    end
end
    

total_time = toc;
eachtime = toc/20;
framerate = 1/eachtime;
%%
baseline_mean_BFI = mean(final_BFI(:,1:baselineframe),2);
normalized_BFI = final_BFI./baseline_mean_BFI;
fulltrans = transpose(normalized_BFI);
save('1003BFI','fulltrans')

% %%
% for j = 1:20
% 
% %     str_2 = string(j);
% %     filelocation_2 = pwd;
% %     filename = strcat('test_q',str_2,'.tiff');
% %     img_2 = imread(filename);
%     colormap('hot')
%     imagesc(img_array(:,:,j));
%     colorbar();
%     
%    
%     pause(0.5);
% end