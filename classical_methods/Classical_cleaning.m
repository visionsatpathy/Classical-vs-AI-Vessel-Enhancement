clc;
clear;
close all;

%% Load image
% Change path to your PAM image
img = imread('G:\Raw data\optoacoustic imaging\AI training Photoaccousatic data\4042171\Photoacoustic_UNet\Contrast_testing_Set\C7.png');

if size(img,3)==3
    img = rgb2gray(img);
end

img = im2double(img);


%% =========================
% 1. Original PAM
%% =========================

original = img;


%% =========================
% 2. CLAHE Enhancement
%% =========================

clahe_img = adapthisteq(original,...
    'ClipLimit',0.02,...
    'NumTiles',[8 8]);


%% =========================
% 3. Vessel Specific Filtering
% Frangi vesselness
%% =========================

% Requires Image Processing Toolbox

vessel_img = FrangiFilter2D(original);



%% =========================
% Display comparison
%% =========================

figure('Position',[100 100 1200 700])

subplot(2,2,1)
imshow(original,[])
title('Original PAM')

subplot(2,2,2)
imshow(clahe_img,[])
title('CLAHE Contrast')

subplot(2,2,3)
imshow(vessel_img,[])
title('Frangi Vessel Enhancement')


%% =========================
% ROI comparison
%% =========================

figure

imshow(original,[])
title('Select ROI')

roi = drawrectangle;

crop_original = imcrop(original,roi.Position);
crop_clahe = imcrop(clahe_img,roi.Position);
crop_vessel = imcrop(vessel_img,roi.Position);

figure('Position',[100 100 1200 600])

subplot(1,4,1)
imshow(crop_original,[])
title('Original ROI')

subplot(1,4,2)
imshow(crop_clahe,[])
title('CLAHE ROI')

subplot(1,4,3)
imshow(crop_vessel,[])
title('Frangi ROI')

%% =========================
% Quantitative metrics
%% =========================


methods = {
    original,...
    clahe_img,...
    vessel_img
};


names = {
    'Original'
    'CLAHE'
    'Frangi'
};


fprintf('\nRESULTS\n')
fprintf('-----------------------------\n')


for k=1:length(methods)

    current = methods{k};

    % Contrast-to-noise ratio

    signal = mean(current(current>mean(current(:))));
    noise = std(current(current<mean(current(:))));

    CNR = signal/noise;


    % Vessel segmentation
    bw = imbinarize(current,'adaptive');

    bw = bwareaopen(bw,20);


    vessel_pixels = sum(bw(:));

    density = vessel_pixels / numel(bw);


    % connected structures

    cc = bwconncomp(bw);

    vessel_count = cc.NumObjects;


    fprintf('%s\n',names{k})
    fprintf('CNR = %.3f\n',CNR)
    fprintf('Vessel density = %.4f\n',density)
    fprintf('Connected vessels = %d\n\n',vessel_count)

end