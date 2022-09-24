%%
clear 
clc
close all

%%
fprintf('Please give your setting time.\n')
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
%                   b     g     o     r     s     y     p
pixel_location = [ 70    41    14    97    84    29    56;
                   90    61    34   117   104    49    76;
                   15    95    63    48    88    23    55;
                   35   115    83    68   108    43    75;

];


sz = size(pixel_location(:,:));
load('background_array_128.mat');
% load('number_box.mat');
%%
frame_label = zeros(1,totalframe,'double');
final_BFI = zeros(7,totalframe,'double');
final_BFI_std = zeros(7,totalframe,'double');
background_array = zeros(128,128,'double');
baseline_array = zeros(128,128,'double');
frame_array = zeros(128,128,'double');
BSsumimage = zeros(128,128,'double');

%%
% prompt = 'What is the frame number? ';
% totalframe = input(prompt);

% RT_READTIFF.M
%
% Basler realtime tiff reader
% make sure the data directory doesn't have any previous tiff data
% before starting the acquisition

DataDir = pwd;
DataDir_2 = strcat(DataDir,'\');
% imds = imageDatastore(DataDir);
%% acquire header of tiff filenames

while 1
    fn0 = dir([DataDir_2 '*0000.tiff']);
    if size(fn0,1) && (fn0(1).bytes ~= 0)
        Header = extractBefore(fn0.name,'0000');
        break;
    else
       pause(0.001)
    end
end
disp('tiff file detected. Starting the main loop ...')

%% main loop

N = totalframe; % total number of frames
tic
for i = 0:N-1
    str4 = sprintf('%04.0f',i);
    filename = [Header str4 '.tiff'];

    while 1
        if isfile(filename)
%             disp(filename)
             pause(0.01);
          

            tiff_image = imread(filename);
            tiff_image = cast(tiff_image,'double');
            tiff_image = tiff_image - background_array;
            frame_label(1,i+1) = i+1;

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
                    MEAN = mean(tiff_image(Y_pixel(count):Y_pixel(count)+6,X_pixel(count):X_pixel(count)+6),"all");
                    STD = std(tiff_image(Y_pixel(count):Y_pixel(count)+6,X_pixel(count):X_pixel(count)+6),1,'all');
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
                 plot(frame_label,final_BFI(1,:),'.',...
                    'Color','#0000FF')
                 xlabel("times (s)")
                 ylabel("BFI (A. U)")
%                  xticks(frameline)
                 xticklabels(stringframe)
                 title("Channel 1 Blood Flow Index vs times")
%          hold off
%          text(3300,100,'BFI =','FontSize',25,'FontWeight','bold');
                 if number_box(i+1) == fix((i+1)/10)
                    round_bfi = round(final_BFI(1,number_box(i+1)+1),1);
                    txt = sprintf('%.0f', round_bfi);
                    final_bfi_text = num2str(txt);
                    text(3550, max(final_BFI(1,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');
             
                end
         
                axis([-300 (totalframe+300) 0 max(final_BFI(1,:))+ max(final_BFI(1,:))*0.2])
                drawnow;

             case 2
                 plot(frame_label,final_BFI(2,:),'.',...
                    'Color','#00FF00')
                 xlabel("times (s)")
                 ylabel("BFI (A. U)")
%                  xticks(frameline)
                 xticklabels(stringframe)
                 title("Channel 2 Blood Flow Index vs times")
%          hold off
%          text(3300,100,'BFI =','FontSize',25,'FontWeight','bold');
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
                 plot(frame_label,final_BFI(1,:),'.',...
                    'Color','#0000FF')
                 xlabel("times (s)")
                 ylabel("BFI (A. U)")
                 xticks(frameline)
                 xticklabels(stringframe)
                 title("Channel 1 Blood Flow Index vs times")

%          text(3300,100,'BFI =','FontSize',25,'FontWeight','bold');
                 if number_box(i+1) == fix((i+1)/10)
                    round_bfi = round(final_BFI(1,number_box(i+1)+1),1);
                    txt = sprintf('%.0f', round_bfi);
                    final_bfi_text = num2str(txt);
                    text(totalframe-50, max(final_BFI(1,:))*1.25, final_bfi_text,'FontSize',25,'FontWeight','bold');
             
                 end
         
                axis([-300 (totalframe+300) 0 max(final_BFI(1,:))+ max(final_BFI(1,:))*0.2])
                drawnow;

         
                subplot(2,1,2)
                plot(frame_label,final_BFI(2,:),'.',...
                    'Color','#00FF00')
                xlabel("times (s)")
                ylabel("BFI (A. U)")
                xticks(frameline)
                xticklabels(stringframe)
                title("Channel 2 Blood Flow Index vs times")

%          text(3300,100,'BFI =','FontSize',25,'FontWeight','bold');
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

            break
        else
            disp(filename)
            pause(0.001);
        end
    end
end
toc
%%
baseline_mean_BFI = mean(final_BFI(:,1:baselineframe),2);
normalized_BFI = final_BFI./baseline_mean_BFI;
fulltrans = transpose(normalized_BFI);
save('0924BFI','fulltrans')