%% TASK 1 – FFT Analysis 
clear; clc; close all;
N = 256;

% Prepare artificial patterns
step = 16;
impGrid = zeros(N); 
impGrid(1:step:end, 1:step:end) = 1;

stripePattern = repmat([zeros(1,8) ones(1,8)], 1, N/16);
stripeImg = repmat(stripePattern, N, 1);

nonPer = zeros(N);
nonPer(100:120, 140:160) = 1;

% Real images for amplitude-phase swap
imA = imread('starr1.jpg');
imB = imread('starr.jpg');

imA = im2double(rgb2gray(imA));
imB = im2double(rgb2gray(imB));
imB = imresize(imB, size(imA));

[imC1, imC2] = swap_amp_phase(imA, imB);

% Cameraman FFT
I1 = im2double(imread('cameraman.tif'));


% put output in a single grid figure

figure('Position',[50 50 1650 900]);
t = tiledlayout(4,4,'TileSpacing','compact','Padding','compact');

% 1(a) Cameraman + FFT 
nexttile; imshow(I1, []); title('1(a) Original: cameraman');
nexttile; showFFT(I1, '1(a) FFT Log-Magnitude');

% 1(b)(i) Impulse Grid 
nexttile; imshow(impGrid, []); title('1(b)(i) Impulse Grid');
nexttile; showFFT(impGrid, '1(b)(i) Impulse FFT');

% 1(b)(ii) Vertical Stripes 
nexttile; imshow(stripeImg, []); title('1(b)(ii) Vertical Stripes');
nexttile; showFFT(stripeImg, '1(b)(ii) Stripes FFT');

% 1(b)(iii) Non-periodic Square 
nexttile; imshow(nonPer, []); title('1(b)(iii) Non-Periodic Square');
nexttile; showFFT(nonPer, '1(b)(iii) Non-Periodic FFT');

% 1(c) Swap Amplitude & Phase
nexttile; imshow(imA, []); title('1(c) Image A');
nexttile; imshow(imB, []); title('1(c) Image B');

nexttile; imshow(imC1, []); title('|A| + ∠B');
nexttile; imshow(imC2, []); title('|B| + ∠A');

sgtitle('Task 1', ...
        'FontSize',16,'FontWeight','bold');

%% Function Definitions 
function showFFT(I, ttl)
    F = fftshift(fft2(I));
    imagesc(log(1+abs(F))); colormap gray; axis image off;
    title(ttl, 'FontWeight','bold');
end

function [imC1, imC2] = swap_amp_phase(imA, imB)
    FA = fft2(imA);
    FB = fft2(imB);

    C1 = abs(FA) .* exp(1i * angle(FB));
    C2 = abs(FB) .* exp(1i * angle(FA));

    imC1 = real(ifft2(C1));
    imC2 = real(ifft2(C2));
end
