clear all;
close all;
v = imread('ngc_atrou.gif');    % Astronomical image from Jean Luc Starck
v = double(v);                  % Convert from 8-bit integer to floating point 

figure(1), clf
imagesc(v)
axis image
colormap(gray)

x = v(190, :);
N = length(x);

M = 5;
h = ones(1, M)/M;

y = conv(h, x);
y = y + 1.0 * randn(size(y));

%% Least square deconvolution
% using the Landweber algorithm

lam = 0.04;
Nit = 50;
[x_deconv_LW, cost_landweber] = deconv_landweber(y, h, lam, Nit);

%% Sparse Haar wavelet deconvolution
% Using the iterative shrinkage-thresholding algorithm (ISTA)

lam = 0.2;
J = 4;          % number of wavelet levels
% [x_deconv_sparswlet, cost_sparswlet, w] = deconv_sparse_Haar(y, h, J, lam, Nit);

%% Display signals

figure(2), clf
subplot(3, 1, 1)
imagesc(v)
axis image off
colormap(gray)
title('Astronomical image')

subplot(3, 2, 3)
plot(x)
xlim([0 N])
ylim([-20 250])
title('Row 100 (All pixels non-negative)')

subplot(3, 2, 4)
plot(y)
title('Convolution + noise')
xlim([0 N])
ylim([-20 250])

subplot(3, 2, 5)
plot(x_deconv_LW)
xlim([0 N])
ylim([-20 250])
title('Least-squares deconvolution (Landweber)')

% subplot(3, 2, 6)
% plot(x_deconv_sparswlet);
% xlim([0 N])
% ylim([-20 250])
% title('Sparse Haar deconvolution (ISTA)')

orient landscape
print -dpdf demo_deconv_sparse_Haar1

