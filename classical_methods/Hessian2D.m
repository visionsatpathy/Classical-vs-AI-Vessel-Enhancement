function [Dxx,Dxy,Dyy] = Hessian2D(I,Sigma)

% Hessian matrix calculation

I = double(I);

% Gaussian smoothing derivatives

[X,Y] = meshgrid(-ceil(3*Sigma):ceil(3*Sigma));

G = exp(-(X.^2 + Y.^2)/(2*Sigma^2));

G = G ./ sum(G(:));


Gx = -X/(Sigma^2).*G;

Gy = -Y/(Sigma^2).*G;


Gxx = (X.^2/Sigma^4 - 1/Sigma^2).*G;

Gxy = (X.*Y/Sigma^4).*G;

Gyy = (Y.^2/Sigma^4 - 1/Sigma^2).*G;



Dxx = imfilter(I,Gxx,'replicate');

Dxy = imfilter(I,Gxy,'replicate');

Dyy = imfilter(I,Gyy,'replicate');


end