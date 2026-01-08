%% ===============================================================
%  PART V – Image Restoration (Corrected Functional Version)
%% ===============================================================

clear; clc; close all;

%% -------- PARAMETERS --------------------------------------------
SNR_dB = 20;                
imgName = 'cameraman.tif';   

I = im2double(imread(imgName));
I = im2gray(I);
[M,N] = size(I);

%% PSFs 
psf5 = fspecial('gaussian',[5 5],1.0);
psf7 = fspecial('gaussian',[7 7],1.4);

%Perform restoration for both PSFs 
[deg5, inv5, wnr5] = restore(I, psf5, SNR_dB);
[deg7, inv7, wnr7] = restore(I, psf7, SNR_dB);

% results
figure('Position',[50 50 1400 700]);
tiledlayout(2,4,'TileSpacing','compact');

nexttile; imshow(I); title('Original');

nexttile; imshow(deg5); title('5×5 Gaussian + 20 dB noise');
nexttile; imshow(inv5); title('Inverse Filtering (5×5)');
nexttile; imshow(wnr5); title('Wiener Filtering (5×5)');

nexttile; imshow(I); title('Original');

nexttile; imshow(deg7); title('7×7 Gaussian + 20 dB noise');
nexttile; imshow(inv7); title('Inverse Filtering (7×7)');
nexttile; imshow(wnr7); title('Wiener Filtering (7×7)');


%% 
function [g_noisy, f_inv, f_wiener] = restore(f, psf, SNR_dB)

    [M,N] = size(f);

    %blur image
    g_blur = imfilter(f, psf, 'conv', 'replicate');

    % Add noise of required SNR
    Ps = mean(g_blur(:).^2);
    SNR = 10^(SNR_dB/10);
    Pn = Ps / SNR;
    sigma = sqrt(Pn);

    noise = sigma*randn(size(g_blur));
    g_noisy = g_blur + noise;

    % Frequency domain representation
    G = fft2(g_noisy);
    H = psf2otf(psf, [M N]);

    
    %   1.regularised inverse filter (avoids noise blow-up)
    eps_reg = 0.5;
    Finv = G .* conj(H) ./ (abs(H).^2 + eps_reg);
    f_inv = real(ifft2(Finv));

    % 2. Wiener Filter (correct formulation)

    % Estimate noise power spectrum (white noise)
    Sn = Pn;

    % Estimate signal spectrum using blurred image and smoothing
    Sx_est = abs(fft2(f)).^2;          % better estimate
    Sx_est = imgaussfilt(Sx_est, 3);   % smooth estimate

    K = Sn ./ (Sx_est + Sn);          % noise-to-signal ratio

    W = conj(H) ./ (abs(H).^2 + K);
    F_w = W .* G;

    f_wiener = real(ifft2(F_w));
end
