%%  PART IV – DESIGN EXERCISE: BLOCK DCT COMPRESSION (Small T)
clear; clc; close all;

% Load NON-cameraman image and resize to 128×128
X = imread('peppers.png');     
I = im2gray(X);
I = imresize(I, [128 128]);
I = im2double(I);

% Add Gaussian noise
noise_var = 0.01;
I_noisy = imnoise(I, 'gaussian', 0, noise_var);

% Block sizes and (smaller) thresholds to test
block_sizes = [8, 16];
thresholds  = [0.5, 1, 2, 5];   % <= here we test 0.5–1 plus a bit higher
nT = numel(thresholds);

figure('Position',[100 100 1500 900]);
tiledlayout(3, nT+1, 'TileSpacing','compact');

% Row 1 – Noiseless, block size B=8
nexttile;
imshow(I, []);
title('Original (128×128)');

B = 8;
for k = 1:nT
    T = thresholds(k);
    K = blockDCTcompress(I, B, T);

    nexttile;
    imshow(K, []);
    title(sprintf('B=8, T=%.1f', T));
end

% Row 2 – Noiseless, block size B=16

nexttile;
imshow(I, []);
title('Original (for B=16)');

B = 16;
for k = 1:nT
    T = thresholds(k);
    K = blockDCTcompress(I, B, T);

    nexttile;
    imshow(K, []);
    title(sprintf('B=16, T=%.1f', T));
end

% Row 3 – Noisy image, block size B=16
nexttile;
imshow(I_noisy, []);
title(sprintf('Gaussian Noise (\\sigma^2 = %.2f)', noise_var));

B = 16;
for k = 1:nT
    T = thresholds(k);
    K = blockDCTcompress(I_noisy, B, T);

    nexttile;
    imshow(K, []);
    title(sprintf('Noisy, B=16, T=%.1f', T));
end


% Helper function: Block DCT compress & reconstruct

function out = blockDCTcompress(I, B, T)

[H, W] = size(I);

% Pad image to a multiple of B
Hp = ceil(H/B) * B;
Wp = ceil(W/B) * B;

Ip = zeros(Hp, Wp);
Ip(1:H, 1:W) = I;

outp = zeros(Hp, Wp);

for r = 1:B:Hp
    for c = 1:B:Wp
        block = Ip(r:r+B-1, c:c+B-1);

        % 2-D DCT of block
        J = dct2(block);

        % Threshold small coefficients
        J(abs(J) < T) = 0;

        % Inverse DCT
        outp(r:r+B-1, c:c+B-1) = idct2(J);
    end
end

% Crop back to original size
out = outp(1:H, 1:W);

end
