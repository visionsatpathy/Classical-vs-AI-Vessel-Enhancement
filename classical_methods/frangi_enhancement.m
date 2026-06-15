clc;
clear;
close all;

%% Load image

img = imread('C7.png');

if size(img,3)==3
    img = rgb2gray(img);
end

img = im2double(img);

%% Frangi vesselness

vessel_img = FrangiFilter2D(img);

%% Display

figure;

subplot(1,2,1)
imshow(img,[])
title('Original')

subplot(1,2,2)
imshow(vessel_img,[])
title('Frangi Vesselness')

%% Save result

imwrite(im2uint8(mat2gray(vessel_img)),...
    'Frangi_Output.png');