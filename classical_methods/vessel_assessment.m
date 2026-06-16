clc;
clear;
close all;

%% Load images

original = im2double(imread('Original.png'));

clahe_img = im2double(imread('CLAHE_Output.png'));

frangi_img = im2double(imread('Frangi_Output.png'));

%% Convert RGB if needed

if size(original,3)==3
    original = rgb2gray(original);
end

if size(clahe_img,3)==3
    clahe_img = rgb2gray(clahe_img);
end

if size(frangi_img,3)==3
    frangi_img = rgb2gray(frangi_img);
end

%% Methods

methods = {
    original,...
    clahe_img,...
    frangi_img
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

    signal = mean(current(current>mean(current(:))));
    noise = std(current(current<mean(current(:))));

    CNR = signal/noise;

    bw = imbinarize(current,'adaptive');

    bw = bwareaopen(bw,20);

    vessel_pixels = sum(bw(:));

    density = vessel_pixels / numel(bw);

    cc = bwconncomp(bw);

    vessel_count = cc.NumObjects;

    fprintf('%s\n',names{k})
    fprintf('CNR = %.3f\n',CNR)
    fprintf('Vessel Density = %.4f\n',density)
    fprintf('Connected Vessels = %d\n\n',vessel_count)

end