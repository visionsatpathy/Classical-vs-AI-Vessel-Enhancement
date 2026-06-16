clear;
clc;
close all;

%% ==========================================
% LOAD SIDE-BY-SIDE IMAGE
%% ==========================================
[file,path] = uigetfile({'*.png;*.jpg;*.tif;*.bmp'},...
    'Select Side-by-Side RAW vs AI Image');

if isequal(file,0)
    return;
end

I = imread(fullfile(path,file));

% Convert RGB to grayscale if needed
if size(I,3)==3
    I = rgb2gray(I);
end

I = im2double(I);

%% ==========================================
% SPLIT LEFT & RIGHT
%% ==========================================
[rows, cols] = size(I);

mid_col = floor(cols/2);

Raw = I(:,1:mid_col);
AI  = I(:,mid_col+1:end);

%% ==========================================
% SELECT ROI ON RAW IMAGE
%% ==========================================
figure('Color','w');
imshow(Raw,[]);
title('Select ROI on RAW image and double click');

roi = drawrectangle('Color','r');
wait(roi);

pos = round(roi.Position);

x = pos(1);
y = pos(2);
w = pos(3);
h = pos(4);

close

%% ==========================================
% APPLY SAME ROI TO BOTH
%% ==========================================
ROI_raw = Raw(y:y+h-1, x:x+w-1);

ROI_ai = AI(y:y+h-1, x:x+w-1);

%% ==========================================
% VESSEL SEGMENTATION
%% ==========================================

% ----- RAW -----
BW_raw = imbinarize(ROI_raw,...
    adaptthresh(ROI_raw,0.45));

BW_raw = bwareaopen(BW_raw,10);

% ----- AI -----
BW_ai = imbinarize(ROI_ai,...
    adaptthresh(ROI_ai,0.45));

BW_ai = bwareaopen(BW_ai,10);

%% ==========================================
% VESSEL COUNT
%% ==========================================
CC_raw = bwconncomp(BW_raw);
CC_ai = bwconncomp(BW_ai);

vesselCount_raw = CC_raw.NumObjects;
vesselCount_ai = CC_ai.NumObjects;

%% ==========================================
% VESSEL AREA FRACTION
%% ==========================================
area_raw = 100 * sum(BW_raw(:)) / numel(BW_raw);

area_ai = 100 * sum(BW_ai(:)) / numel(BW_ai);

%% ==========================================
% RELATIVE VESSEL-to-BACKGROUND SNR
%% ==========================================

% ----- RAW -----
signal_raw = ROI_raw(BW_raw == 1);
background_raw = ROI_raw(BW_raw == 0);

signal_mean_raw = mean(signal_raw(:));
noise_std_raw = std(background_raw(:));

snr_raw = 20 * log10(signal_mean_raw / noise_std_raw);

% ----- AI -----
signal_ai = ROI_ai(BW_ai == 1);
background_ai = ROI_ai(BW_ai == 0);

signal_mean_ai = mean(signal_ai(:));
noise_std_ai = std(background_ai(:));

snr_ai = 20 * log10(signal_mean_ai / noise_std_ai);

%% ==========================================
% DISPLAY RESULTS
%% ==========================================
figure('Color','w',...
    'Position',[100 100 1500 700]);

subplot(2,3,1)
imshow(ROI_raw,[])
title('Raw ROI')

subplot(2,3,2)
imshow(ROI_ai,[])
title('AI ROI')

subplot(2,3,4)
imshow(BW_raw)
title(['Raw Vessel Count = ',...
    num2str(vesselCount_raw)])

subplot(2,3,5)
imshow(BW_ai)
title(['AI Vessel Count = ',...
    num2str(vesselCount_ai)])

subplot(2,3,3)
axis off

text(0,0.9,...
    ['RAW SNR = ',num2str(snr_raw,'%.2f'),' dB'],...
    'FontSize',12)

text(0,0.7,...
    ['RAW Vessel Area = ',...
    num2str(area_raw,'%.2f'),' %'],...
    'FontSize',12)

text(0,0.45,...
    ['AI SNR = ',num2str(snr_ai,'%.2f'),' dB'],...
    'FontSize',12)

text(0,0.25,...
    ['AI Vessel Area = ',...
    num2str(area_ai,'%.2f'),' %'],...
    'FontSize',12)

text(0,0.05,...
    ['RAW Count = ',num2str(vesselCount_raw),...
    ' | AI Count = ',num2str(vesselCount_ai)],...
    'FontSize',12,...
    'FontWeight','bold')

title('Quantitative Comparison')

sgtitle('RAW vs AI Vessel Analysis')

%% ==========================================
% PRINT RESULTS
%% ==========================================
fprintf('\n===== RAW vs AI ANALYSIS =====\n');

fprintf('\nRAW IMAGE\n');
fprintf('Vessel Count: %d\n', vesselCount_raw);
fprintf('Vessel Area: %.2f %%\n', area_raw);
fprintf('Relative Vessel SNR: %.2f dB\n', snr_raw);

fprintf('\nAI ENHANCED IMAGE\n');
fprintf('Vessel Count: %d\n', vesselCount_ai);
fprintf('Vessel Area: %.2f %%\n', area_ai);
fprintf('Relative Vessel SNR: %.2f dB\n', snr_ai);