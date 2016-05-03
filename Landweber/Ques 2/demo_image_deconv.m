%% demo_image_deconv
% Image deconvolution using least squares and the Landweber algorithm

%%

clear 

%% Load image

x = imread('ngc_atrou.gif');    % Astronomical image from Jean Luc Starck
x = double(x);                  % Convert from 8-bit integer to floating point 
[N1, N2] = size(x);

figure(1), clf
imagesc(x)              
axis image
colormap(gray)
title('Astronomical image')

% Note: imagesc scales the image display so that
% black = minimum pixel value
% white = maximum pixel value

%% Convolution
% Create a blurry noisy image

% Two-dimensional impulse response 
M = 6;
h = eye(M);
h = [h zeros(M, 3)];
h = h + fliplr(h);
h = h/sum(h(:));                          % The impulse response is not square

y = conv2(h, x);                % Two-dimensional convolution
    
y = y + 1.0 * randn(size(y));   % Add noise

figure(2), clf
imagesc(y)
axis image
colormap(gray)
title('Convolution + noise')

%% Deconvolution
% Can we estimate the original image x from the blurred noisy image y?

lam = 0.2;
Nit = 100;
[x_deconv_LW, J1] = image_deconv_landweber(y, h, lam, Nit);

figure(1), clf
imagesc(x_deconv_LW);
axis image
colormap(gray)
title('Landweber deconvolution')

% Verify convergence of algorithm
figure(2)
plot(J1)
title('Cost function history')
xlabel('Iteration')

%% Deconvolution with non-negativity constraint
% We know the pixels are non-negative, so let us include that
% constraint in the method.

[x_deconv_LW_NonNeg, J2] = image_deconv_landweber_nonneg(y, h, lam, Nit);

figure(1), clf
imagesc(x_deconv_LW_NonNeg)
axis image
colormap(gray)
title('Landweber deconv with non-negativity')

% Verify convergence of algorithm
figure(2)
plot(J2)
title('Cost function history')
xlabel('Iteration')

%% Display results
% The algorithm does not perfectly recover the original image, 
% but it does significantly correct the blurring.

figure(1), clf
subplot(2, 2, 1)
imagesc(x)
colormap(gray)
axis image off
title('Astronomical image')

subplot(2, 2, 2)
imagesc(y)
colormap(gray)
axis image off
title('Convolution + noise')

subplot(2, 2, 3)
imagesc(x_deconv_LW)
axis image off
title('Landweber deconvolution')

subplot(2, 2, 4)
imagesc(x_deconv_LW_NonNeg)
axis image off
title('Landweber deconv with non-negativity')

orient landscape
print -dpdf demo_image_deconv_fig11

%% Display a single row
% Note that without the non-negativity constraint, some pixels
% negative. 

M = 177;

figure(1), clf
subplot(2, 2, 1)
plot(x(M, :))
ylim([-20 250])
title('Astronomical image (row 177)')

subplot(2, 2, 2)
plot(y(M, :))
ylim([-20 250])
title('Convolution + noise (row 177)')

subplot(2, 2, 3)
plot(x_deconv_LW(M, :))
ylim([-20 250])
title('Landweber deconvolution (row 177)')

subplot(2, 2, 4)
plot(x_deconv_LW_NonNeg(M, :))
ylim([-20 250])
title('Landweber deconv with non-negativity (row 177)')

orient landscape
print -dpdf demo_image_deconv_fig21


%% Frequency response of 2D impulse response h
% It is informative (but not necessary) to display the frequency response

Nfft = 64;
Hf = fft2(h, Nfft, Nfft);
Hf = fftshift(Hf);
f = (0:Nfft-1)/Nfft - 0.5;

figure(1), clf
subplot(2, 1, 1)
mesh(f, f, abs(Hf), 'Edgecolor', 'black')
title('Frequency response of 2D impulse response h')
xlabel('f_1')
ylabel('f_2')

%% Frequency response of 2D high-pass difference filter d

d = [1 -1; -1 1];
Df = fft2(d, Nfft, Nfft);
Df = fftshift(Df);

subplot(2, 1, 2)
mesh(f, f, abs(Df), 'Edgecolor', 'black')
title('Frequency response of 2D high-pass difference filter d')
xlabel('f_1')
ylabel('f_2')

orient landscape
print -dpdf demo_image_deconv_fig31