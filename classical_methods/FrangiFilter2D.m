function out = FrangiFilter2D(I)

% =====================================================
% Improved Frangi Vessel Filter for PAM / OAT Images
% =====================================================

I = im2double(I);

% ---------- Parameters ----------
scales = 1:8;      % wider vessel size range
beta = 0.7;        % vessel sensitivity
c = 8;             % structure sensitivity

% Bright vessels?
brightVessels = true;

% ---------- Output ----------
out = zeros(size(I));

% ---------- Multi-scale analysis ----------
for sigma = scales

    % Hessian calculation
    [Dxx,Dxy,Dyy] = Hessian2D(I,sigma);

    % Scale normalization
    Dxx = (sigma^2) * Dxx;
    Dxy = (sigma^2) * Dxy;
    Dyy = (sigma^2) * Dyy;

    % Eigenvalues
    [lambda1,lambda2] = eig2image(Dxx,Dxy,Dyy);

    % Sort eigenvalues
    check = abs(lambda1) > abs(lambda2);

    temp = lambda1(check);
    lambda1(check) = lambda2(check);
    lambda2(check) = temp;

    % Avoid divide-by-zero
    lambda2(lambda2==0) = eps;

    % Vesselness measures
    Rb = (lambda1 ./ lambda2).^2;

    S2 = lambda1.^2 + lambda2.^2;

    % Frangi vesselness equation
    V = exp(-Rb/(2*beta^2)) .* ...
        (1 - exp(-S2/(2*c^2)));

    % Vessel polarity
    if brightVessels
        V(lambda2 > 0) = 0;
    else
        V(lambda2 < 0) = 0;
    end

    % Multi-scale maximum response
    out = max(out,V);

end

% ---------- Postprocessing ----------
out = mat2gray(out);

% Mild smoothing
out = imgaussfilt(out,0.8);

% Contrast boost
out = adapthisteq(out,...
    'ClipLimit',0.01,...
    'Distribution','rayleigh');

end