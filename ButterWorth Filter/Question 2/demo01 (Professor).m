
%% Start

clc
clear

%% Make ECG signal
% Use 'ecgsyn.m' by
% P. E. McSharry, G. D. Clifford, L. Tarassenko, and L. A. Smith.
% A dynamical model for generating synthetic electrocardiogram signals.
% Trans. on Biomed. Eng., 50(3):289-294, March 2003.
% http://www.physionet.org/physiotools/ecgsyn/

addpath ecg
% rand('state', 1);               % Set rand/randn states for reproducibility

Fs = 256;                       % Fs : sampling frequency (samples/sec)

x = ecgsyn(Fs, 10);             % Simulate 10 heart beats

N = length(x);
n = 0:N-1;
t = n / Fs;

sigma = 0.2;                    % sigma : noise standard deviation

noise = sigma * randn(N, 1);    % noise : white Gaussian noise

g1 = x + noise;                 % g1 : noisy ECG (white noise)

g2 = g1 + cos(0.2*pi*n');       % g2 : ECG with white noise and tonal noise


%% Display ECG signals

ax1 = [0 N/Fs -1.0 2.0];

ax1 = [6 10 -1.0 2.0];

xlim([6 10])

figure(1)
clf
subplot(3,1,1)
plot(t, x)
title('ECG (noise-free)')
xlabel('Time (seconds)')
axis(ax1)

subplot(3,1,2)
plot(t, g1)
title('g1 (ECG with white noise)');
xlabel('Time (seconds)')
axis(ax1)

subplot(3,1,3)
plot(t, g2)
title('g2 (ECG with white noise and tonal noise)');
xlabel('Time (seconds)')
axis(ax1)

orient tall
print -dpdf ecg_figure01

