clear;
clc;
close all;

%% Select image
[file,path] = uigetfile({'*.png;*.jpg;*.tif'},...
    'Select PAM image');

I = imread(fullfile(path,file));

if size(I,3)==3
    I = rgb2gray(I);
end

I = im2double(I);

%% LIGHT preprocessing only
I_pre = adapthisteq(I,...
    'ClipLimit',0.008);

%% Frangi enhancement
Ivessel = FrangiFilter2D(I_pre);

%% Display
figure('Color','w')

subplot(1,3,1)
imshow(I,[])
title('Raw')

subplot(1,3,2)
imshow(I_pre,[])
title('Light CLAHE')

subplot(1,3,3)
imshow(Ivessel,[])
title('Sharp Frangi')