%%  TASK 2 & TASK 3 
clear; clc; close all;

%% Task 2(a) 
% Compute the DCT of a standard image (autumn.tif)

X = imread('autumn.tif');         
I = rgb2gray(X);                 
I = im2double(I);

% 2D DCT
J = dct2(I);

%% Task 2(b)
% FFT of the same image for comparison
F     = fftshift(fft2(I));
F_mag = log(1 + abs(F));           % log-magnitude for visibility
DCT_log = log(abs(J));             % log-magnitude of DCT

%% Task 3 – Hadamard Transform
I2 = im2double(imread('cameraman.tif'));

% Ensure dimension is a power of 2
targetSize = 256;
I2 = imresize(I2, [targetSize targetSize]);

H = hadamard(targetSize);
H_norm = H / sqrt(targetSize);     % orthonormal Hadamard

Had = H_norm * I2 * H_norm';       % 2D Hadamard transform
Had_log = log(abs(Had) + 1);

% Single Grid Figure
figure('Position',[100 100 1200 800]);
tiledlayout(3,2,'TileSpacing','compact','Padding','compact');

% Task 2(a)
ax1 = nexttile;
imshow(I, []);
title('Task 2(a): Original (autumn.tif)');
colormap(ax1, gray);

ax2 = nexttile;
imagesc(DCT_log);
axis image off;
title('Task 2(a): DCT Log-Magnitude');
colormap(ax2, jet(64));
colorbar;

% Task 2(b)
ax3 = nexttile;
imagesc(DCT_log);
axis image off;
title('Task 2(b): DCT Log-Magnitude');
colormap(ax3, jet(64));
colorbar;

ax4 = nexttile;
imagesc(F_mag);
axis image off;
title('Task 2(b): FFT Log-Magnitude');
colormap(ax4, jet(64));
colorbar;

% Task 3 
ax5 = nexttile;
imshow(I2, []);
title('Task 3: Original (cameraman)');
colormap(ax5, gray);

ax6 = nexttile;
imagesc(Had_log);
axis image off;
title('Task 3: Hadamard Log-Magnitude');
colormap(ax6, gray);
colorbar;

% sgtitle('Tasks 2 & 3: DCT, FFT and Hadamard Transforms','FontSize',14,'FontWeight','bold');
