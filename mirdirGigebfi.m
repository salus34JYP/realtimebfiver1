%% Initialize
clear, clc, close all

%% Obtain Experiment Name from the user, and makes a data directory
%
% background mat file has to be in the current directory,
% and all the data files should be saved in the data directory
%
% ex) save([DataDir '\filename'], 'fulltrans')

CurDir = pwd;
CurDate = date;
disp(['The present working directory is ' CurDir])
ExpName = input('Type a new experiment name : ', 's');
DataDir = [CurDate '-' ExpName];
disp(['Creating a new data directory : ' DataDir])
mkdir(DataDir)

%% Get information Gige camer in matlab
gc = gigecamlist;
gc_address = gc.IPAddress;
gc_string = string(gc_address);

%% Access Gige camera in maltab
g = gigecam(gc_string, 'PixelFormat', 'Mono12');
%% Setting Gige camera
g.AcquisitionFrameRateAbs = 10;
g.AcquisitionFrameRateEnable ='True';
g.Width = 128;
g.Height = 128;
g.OffsetY = 460;
g.OffsetX = 540;
g.GainRaw = 3;

%% Set up channl plot and calcuation for plot range
fprintf('Please give your using channel.\n')
% framerate = 10;
% Base_prompt = 'Baseline:';
% stimulus_prompt = 'stimulus:';
% release_prompt = 'release:';
% title_prompt = 'title name';
channel_prompt = 'channel count:';

% basetime = input(Base_prompt);
% stimulustime = input(stimulus_prompt);
% releasetime = input(release_prompt);
% title_num = input(title_prompt);
channel_num = input(channel_prompt);
% baselineframe = basetime*60*framerate;
% stimulusframe = stimulustime*60*framerate;
% releaseframe = releasetime*60*framerate;
totalframe = 3000;
frameline = 0:300:totalframe;
timeline = frameline/10;
stringframe = string(timeline);
number_box = zeros(1,totalframe);

%% pixel location
%                    b     g     o     r     s     y     p
pixel_location = [  44    63    83    22    90    15    50;
                    64    83   103    42   110    35    70;
                    17    97    30    83    66    43    59;
                    37   117    50   103    86    63    79;


];


sz = size(pixel_location(:,:));
load('background_array_128.mat');

%% Set up variable for BFI calculation
frame_label = zeros(1,totalframe,'double');
final_BFI = zeros(7,totalframe,'double');
final_BFI_std = zeros(7,totalframe,'double');
background_array = zeros(128,128,'double');
baseline_array = zeros(128,128,'double');
frame_array = zeros(128,128,'double');
BSsumimage = zeros(128,128,'double');
%% make array for BFI value plot
for i = 1:totalframe
    number_box(1,i) = fix(i/10);
    
end

%% main loop

N = totalframe; % total number of frames
tic
for j = 1:N
    img = snapshot(g);
    frame_label(1,j) = j;
    while 1 % to be convinced for making img file
        if ~isempty(img)
            break
        else
            continue
        end
    end
    img = cast(img,'double'); % change data type because img of initial condiditon is uint16

    for label = 1 : sz(1,2) % BFI calculation part 
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

        final_BFI(label,j) = BFI_box_mean;
        final_BFI_std(label,j)= BFI_box_std;
    end
    
    switch channel_num % selection channel part
        case 1 
            
            plot(frame_label,final_BFI(1,:),'.','Color','#0000FF')
            xlabel("times (s)")
            ylabel("BFI (A. U)")
            xticks(frameline)
            xticklabels(stringframe)
            title("Channel 1 Blood Flow Index vs times")
            if number_box(1,j) == fix((j)/10)
                round_bfi = round(final_BFI(1,number_box(1,j)+1),1);
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
            xticks(frameline)
            xticklabels(stringframe)
            title("Channel 2 Blood Flow Index vs times")

            if number_box(1,j) == fix((j)/10)
               round_bfi = round(final_BFI(2,number_box(1,j)+1),1);
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

            if number_box(1,j) == fix((j)/10)
                round_bfi = round(final_BFI(1,number_box(1,j)+1),1);
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

            if number_box(j) == fix((j)/10)
               round_bfi = round(final_BFI(2,number_box(j)+1),1);
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
    

total_time = toc
eachtime = toc/totalframe
framerate = 1/eachtime
%% selection for used channel

final_BFI_blue = final_BFI(1,:);

%% test : saving a variable in the Data Directory
filename = strcat('\',DataDir);
save([DataDir filename],'final_BFI_blue')