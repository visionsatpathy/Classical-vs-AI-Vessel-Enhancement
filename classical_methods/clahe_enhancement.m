clc;
clear;
close all;

%% Load image

img = imread(''); % Type your image file path here 

if size(img,3)==3
    img = rgb2gray(img);
end

img = im2double(img);

%% CLAHE

clahe_img = adapthisteq(img,...
    'ClipLimit',0.02,...
    'NumTiles',[8 8]);

%% Display

figure;

subplot(1,2,1)
imshow(img,[])
title('Original')

subplot(1,2,2)
imshow(clahe_img,[])
title('CLAHE')

%% Save result

imwrite(im2uint8(mat2gray(clahe_img)),...
    'CLAHE_Output.png');
