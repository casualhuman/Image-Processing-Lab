%%  PART II – IMAGE ENHANCEMENT 
clear; clc; close all;

figure('Position',[100 100 1600 800]);
tiledlayout(3,6,"TileSpacing","compact","Padding","compact");

%%  Task 1 – Histogram Equalisation with Different Bin Sizes

X = imread('cameraman.tif');
I = im2gray(X);              % Safe for RGB or grayscale
I = im2double(I);

% Original histogram (64 bins)
nexttile;
imhist(I, 64);
title('Task 1: Orig Hist (64 bins)');

% Original image
nexttile;
imshow(I, []);
title('Task 1: Original');

% Equalise with 64 bins
J = histeq(I, 64);           

% Hist of equalised (64 bins)
nexttile;
imhist(J, 64);
title('Task 1: Hist Eq (64 bins)');

% Equalised image (64 bins)
nexttile;
imshow(J, []);
title('Task 1: Eq Image (64 bins)');

% Equalise with 4 bins
K = histeq(I, 4);            

% Hist of 4-bin equalised (still display 64 bin hist)
nexttile;
imhist(K, 64);
title('Task 1: Hist Eq (4 bins)');

% Equalised image (4 bins)
nexttile;
imshow(K, []);
title('Task 1: Eq Image (4 bins)');

%%  Task 2 – Histogram Modification (gamma)

I2 = imread('cameraman.tif');
I2 = im2gray(I2);
I2 = im2double(I2);

gamma = 0.6;
T = I2 .^ gamma;     

% Original image
nexttile;
imshow(I2, []);
title('Task 2: Original');

% Gamma corrected image
nexttile;
imshow(T, []);
title('Task 2: Gamma 0.6');

% (Leave 2 tiles in this row for Task 3 edges)
% They'll be filled by Task 3 (Sobel & Roberts) to keep grouping sensible.

%%  Task 3 – Edge Detection with Different Operators
X3 = imread('trees.tif');
I3 = im2gray(X3);

% Sobel
nexttile;
imshow(edge(I3, 'sobel'));
title('Task 3: Sobel');

% Roberts
nexttile;
imshow(edge(I3, 'roberts'));
title('Task 3: Roberts');

% Prewitt
nexttile;
imshow(edge(I3, 'prewitt'));
title('Task 3: Prewitt');

% LoG
nexttile;
imshow(edge(I3, 'log'));
title('Task 3: LoG');

%% Task 3 Extension: Edges only at +/- 45°

F45  = [-1 0 1; -1 0 1; -1 0 1]';     
F_45 = [1 0 -1; 0 0 0; -1 0 1];      

E45  = imfilter(I3, F45,  'replicate');
E_45 = imfilter(I3, F_45, 'replicate');

% +45°
nexttile;
imshow(abs(E45), []);
title('Task 3: +45° edges');

% -45°
nexttile;
imshow(abs(E_45), []);
title('Task 3: -45° edges');

%%  Task 4 – Salt & Pepper Noise + Median Filtering

X4 = imread('autumn.tif');
I4 = im2gray(X4);

J4 = imnoise(I4, 'salt & pepper');

M3 = medfilt2(J4, [3 3]);
M5 = medfilt2(J4, [5 5]);
M7 = medfilt2(J4, [7 7]);

% Noisy image
nexttile;
imshow(J4, []);
title('Task 4: Noisy (S&P)');

% Median 3×3
nexttile;
imshow(M3, []);
title('Task 4: Median 3×3');

% Median 5×5
nexttile;
imshow(M5, []);
title('Task 4: Median 5×5');

% Median 7×7
nexttile;
imshow(M7, []);
title('Task 4: Median 7×7');
