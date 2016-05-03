clc;clear all;close all;
% B) Use the Matlab function 'butter' to create a Butterworth low-pass filter. Plot the
% impulse response, frequency response, and pole-zero diagram of the filter. Use the
% Matlab function 'filter' to apply the low-pass filter to the noisy ECG signals generated in
% the demo file in the ECG folder. How well can you recover the true ECG signal from the
% noisy signals by low-pass filtering? Plot true ECG and filtered ECG signals on the same
% axes to compare them.

% To get the filter coefficient of butterworth filter H(z)=B(z)/A(z)
[b,a]=butter(3,0.08); %Third order filter with 0.3pi radian/sec as cutoff freq

% Impulse Response
imp=[1 zeros(1,100)];
h=filter(b,a,imp);
figure,stem(h)
xlabel('samples n');
ylabel('Amplitude');
title('Impulse Response of the filter');

% Frequency Response
j=sqrt(-1);
om=linspace(-pi,pi,200);
Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
figure,plot(om/(2*pi),abs(Hf))
title('Frequency Response |H^f(\omega)|');
xlabel('\omega/2\pi');

figure,
% Pole zero diagram
zplane(b,a)
title('Pole zero diagram of butterworth filter of order 3, cutoff 0.8')

% load ECG signal
Fs=256;
x=ecgsyn(Fs,10);
n=0:length(x)-1;
t=n/Fs;
figure,plot(t,x);
title('ECG signal');
xlabel('Time in sec');
xlim([4 7]);

% Noise signal
N=length(x);
sigma=0.2;                    % sigma : noise standard deviation
noise=sigma*randn(N, 1);    % noise : white Gaussian noise
g1=x+noise;                 % g1 : noisy ECG (white noise)
g2=g1+cos(0.2*pi*n');       % g2 : ECG with white noise and tonal noise
figure,plot(t,g2);
title('Noisy ECG signal');
xlabel('Time in sec');
xlim([4 7]);

% Fourier Transform of noise signal

f=fftshift(fft(g2,N));%Fourier Transform of noise signal
t1=(-N/2:N/2-1)/N;
f2=fftshift(fft(x,N))% Fourier transform of original signal
figure,plot(t1,abs(f),t1,abs(f2));
legend('noisy ecg','true ecg');
xlabel('Normalized Frequency');
ylabel('Magnitude');
title('Double Sided FFT - with FFTShift of noise signal');

% Apply low pass filter to noisy ECG signal
y=filter(b,a,g2);
figure,plot(t,y,t,x)
legend('filtered output','true ecg')
title('Filter output signal')
xlabel('Time (seconds)')
xlim([4 6]);