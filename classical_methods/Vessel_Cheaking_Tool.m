clear;
clc;
close all;

%% ==========================================
% LOAD IMAGE
%% ==========================================
[file,path] = uigetfile({'*.png;*.jpg;*.tif;*.bmp'},...
    'Select PAM Image');

if isequal(file,0)
    return;
end

I = imread(fullfile(path,file));

if size(I,3)==3
    I = rgb2gray(I);
end

I = im2double(I);

%% ==========================================
% SELECT ROI
%% ==========================================
figure('Color','w');
imshow(I,[]);
title('Select ROI and Double Click');

roi = drawrectangle('Color','r');
wait(roi);

pos = round(roi.Position);

x = pos(1);
y = pos(2);
w = pos(3);
h = pos(4);

ROI = I(y:y+h-1, x:x+w-1);

close

%% ==========================================
% CLAHE
%% ==========================================
ROI_CLAHE = adapthisteq(ROI,...
    'ClipLimit',0.008,...
    'NumTiles',[8 8]);

%% ==========================================
% UPDATED FRANGI
%% ==========================================
ROI_pre = adapthisteq(ROI,...
    'ClipLimit',0.006);

ROI_Frangi = FrangiFilter2D(ROI_pre);

%% ==========================================
% VESSEL SEGMENTATION
%% ==========================================
% RAW
BW_raw = imbinarize(ROI,...
    adaptthresh(ROI,0.45));

BW_raw = bwareaopen(BW_raw,10);

% CLAHE
BW_clahe = imbinarize(ROI_CLAHE,...
    adaptthresh(ROI_CLAHE,0.45));

BW_clahe = bwareaopen(BW_clahe,10);

% FRANGI
BW_frangi = imbinarize(ROI_Frangi,...
    adaptthresh(ROI_Frangi,0.45));

BW_frangi = bwareaopen(BW_frangi,10);

%% ==========================================
% VESSEL COUNT
%% ==========================================
CC_raw = bwconncomp(BW_raw);
CC_clahe = bwconncomp(BW_clahe);
CC_frangi = bwconncomp(BW_frangi);

vesselCount_raw = CC_raw.NumObjects;
vesselCount_clahe = CC_clahe.NumObjects;
vesselCount_frangi = CC_frangi.NumObjects;

%% ==========================================
% VESSEL AREA FRACTION
%% ==========================================
area_raw = 100 * sum(BW_raw(:)) / numel(BW_raw);
area_clahe = 100 * sum(BW_clahe(:)) / numel(BW_clahe);
area_frangi = 100 * sum(BW_frangi(:)) / numel(BW_frangi);

%% ==========================================
% DISPLAY RESULTS
%% ==========================================
figure('Color','w',...
    'Position',[100 100 1400 700]);

subplot(2,3,1)
imshow(ROI,[])
title('Raw ROI')

subplot(2,3,2)
imshow(ROI_CLAHE,[])
title('CLAHE ROI')

subplot(2,3,3)
imshow(ROI_Frangi,[])
title('Frangi ROI')

subplot(2,3,4)
imshow(BW_raw)
title(['Raw Vessels = ',num2str(vesselCount_raw)])

subplot(2,3,5)
imshow(BW_clahe)
title(['CLAHE Vessels = ',num2str(vesselCount_clahe)])

subplot(2,3,6)
imshow(BW_frangi)
title(['Frangi Vessels = ',num2str(vesselCount_frangi)])

%% ==========================================
% PRINT METRICS
%% ==========================================
fprintf('\n===== ROI ANALYSIS =====\n');

fprintf('\nRAW IMAGE\n');
fprintf('Vessel Count: %d\n', vesselCount_raw);
fprintf('Vessel Area: %.2f %%\n', area_raw);
fprintf('SNR: %.2f dB\n', snr_raw);

fprintf('\nCLAHE IMAGE\n');
fprintf('Vessel Count: %d\n', vesselCount_clahe);
fprintf('Vessel Area: %.2f %%\n', area_clahe);
fprintf('SNR: %.2f dB\n', snr_clahe);

fprintf('\nFRANGI IMAGE\n');
fprintf('Vessel Count: %d\n', vesselCount_frangi);
fprintf('Vessel Area: %.2f %%\n', area_frangi);
fprintf('SNR: %.2f dB\n', snr_frangi);
%% ==========================================
% SNR CALCULATION
%% ==========================================

% -------- RAW --------
signal_raw = ROI(BW_raw == 1);
background_raw = ROI(BW_raw == 0);

signal_mean_raw = mean(signal_raw(:));
noise_std_raw = std(background_raw(:));

snr_raw = 20 * log10(signal_mean_raw / noise_std_raw);


% -------- CLAHE --------
signal_clahe = ROI_CLAHE(BW_clahe == 1);
background_clahe = ROI_CLAHE(BW_clahe == 0);

signal_mean_clahe = mean(signal_clahe(:));
noise_std_clahe = std(background_clahe(:));

snr_clahe = 20 * log10(signal_mean_clahe / noise_std_clahe);


% -------- FRANGI --------
signal_frangi = ROI_Frangi(BW_frangi == 1);
background_frangi = ROI_Frangi(BW_frangi == 0);

signal_mean_frangi = mean(signal_frangi(:));
noise_std_frangi = std(background_frangi(:));

snr_frangi = 20 * log10(signal_mean_frangi / noise_std_frangi);