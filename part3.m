%%  PART III – IMAGE COMPRESSION  
clear; clc; close all;


% Whole Image DCT with Different Thresholds 

X = imread('autumn.tif');
I = im2gray(X);
I = im2double(I);                      % scale to [0,1]

J = dct2(I);                           % full-image 2D DCT

thresholds = [5, 10, 20, 40];          % try different thresholds
nT = numel(thresholds);

figure;
subplot(2, ceil((nT+1)/2), 1);
imshow(I, []);
title('Part III: Original Image');

for k = 1:nT
    T = thresholds(k);

    Jt = J;
    Jt(abs(Jt) < T) = 0;               % zero small coefficients

    K = idct2(Jt);                     % reconstructed image

    subplot(2, ceil((nT+1)/2), k+1);
    imshow(K, []);
    title(sprintf('Whole-image DCT, T = %d', T));
end


%% Block-Based DCT (8x8) with different thresholds

B = 8;                                 % block size

[H, W] = size(I);

% Pad image to a multiple of 8 (avoids indexing errors)
Hp = ceil(H / B) * B;
Wp = ceil(W / B) * B;

Ip = zeros(Hp, Wp);                    % padded image
Ip(1:H, 1:W) = I;                      % original inside

block_thresholds = [5, 10, 20];
nTb = numel(block_thresholds);

figure;
subplot(1, nTb+1, 1);
imshow(I, []);
title('Block DCT: Original');

for k = 1:nTb
    T = block_thresholds(k);
    Kblk = zeros(Hp, Wp);

    % process each 8x8 block
    for r = 1:B:Hp
        for c = 1:B:Wp
            block = Ip(r:r+B-1, c:c+B-1);

            % 2D DCT of block
            Jb = dct2(block);

            % threshold
            Jb(abs(Jb) < T) = 0;

            % inverse DCT
            Kb = idct2(Jb);

            Kblk(r:r+B-1, c:c+B-1) = Kb;
        end
    end

    % crop back to original size for display
    Kblk_crop = Kblk(1:H, 1:W);

    subplot(1, nTb+1, k+1);
    imshow(Kblk_crop, []);
    title(sprintf('Block DCT 8x8, T = %d', T));
end
