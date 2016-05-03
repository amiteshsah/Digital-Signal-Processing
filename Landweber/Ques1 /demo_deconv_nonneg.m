
clear 

v = imread('ngc_atrou.gif');    % Astronomical image from Jean Luc Starck
v = double(v);                  % Convert from 8-bit integer to floating point 

figure(1), clf
imagesc(v)
title('Astronomical image');
axis image
colormap(gray)

x = v(190, :);
N = length(x);

M = 5;
h = ones(1, M)/M;

y = conv(h, x);
y = y + 1.0 * randn(size(y));

y=y';
h=h';
x_deconv = deconv(y, h);

lam = 0.05;
Nit = 50;
[x_deconv_LW, J1] = deconv_landweber1(y, h, lam, Nit);
[x_deconv_LW_NonNeg, J2] = deconv_landweber_nonneg1(y, h, lam, Nit);


figure(2), clf
subplot(4, 2, 1)
imagesc(v)
axis image off
colormap(gray)
title('Astronomical image')

subplot(4, 2, 2)
plot(x)
xlim([0 N])
ylim([-20 250])
title('Row 100 (All pixels non-negative)')

subplot(4, 2, 3)
plot(y)
title('Convolution + noise')
xlim([0 N])
ylim([-20 250])

subplot(4, 2, 4)
plot(x_deconv)
xlim([0 N])
ylim([-20 250])
title('MATLAB deconv function')

subplot(4, 2, 5)
plot(x_deconv_LW)
xlim([0 N])
ylim([-20 250])
title('Landweber deconvolution')

subplot(4, 2, 6)
  plot(x_deconv_LW_NonNeg)
xlim([0 N])
ylim([-20 250])
title('Landweber deconv with non-negativity')
% 
orient tall
print -dpdf demo_deconv_nonneg1

figure, subplot(2,1,1),plot(J1),title('Cost function from deconv landweber');
 subplot(2,1,2),plot(J2),title('Cost function from deconv landweber nonneg');
