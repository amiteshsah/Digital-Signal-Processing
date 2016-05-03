clc;clear all; close all
 
% Read a signal or audio file
[s,fs]=audioread('/Users/amitesh/Desktop/DSP 2/Assignment 5/Question 1/sp1.wav');
% [s,fs]=audioread('sp1.wav');
 
% Length of audio signal
N=length(s);
% Block length
R=600;
 
% Overlapping is 2/3 , Number of block calculation
Nb=floor(N/(R/3))-1;  
 
% Plotting the speech signal
x=s(1:(Nb+1)*(R/3));
N = length(x);
figure,plot((1:N)/fs, x)
title('Speech signal')
xlabel('Time (seconds)')
 
soundsc(x, fs);     % Play the audio file


%  FORWARD STFT
X1 = zeros(R, Nb);
i = 0;
for k = 1:Nb-1
%     X1(:,k) = w'.*x(i + (1:R));
X1(:,k) = x(i + (1:R));
    i = i + R/3;
end
X = fft(X1);                  % Compute the FFT of each block
Tr = R/fs;                   % Duration of each block (in seconds)
 
% % plot spectrogram
figure,imagesc([0 N/fs], [0 fs/3], 20*log10(abs(X(1:R/3, :)))); 
cmap = flipud(gray);
colormap(cmap);
colorbar
axis xy 
xlabel('Time (sec.)') 
ylabel('Frequency (Hz)') 
title('Spectrogram') 
caxis([-20 30])
 
% INVERSE Stft
 
Y = ifft(X);        % inverse FFT of each column of X
y = zeros(size(x));
i = 0;
for k = 1:Nb-1
%     y(i + (1:R)) = y(i + (1:R)) + w' .* Y(:,k);
 y(i + (1:R)) = y(i + (1:R)) + Y(:,k)/3;
    i = i + R/3;
end
% Take care of first half-block
% y(1:R/3) = y(1:R/3) ./ (w(1:R/3).^2)';
y(1:R/3) = 3*y(1:R/3);
y(R/3+1:2*R/3) = 3*y(R/3+1:2*R/3)/2;
 
% Take care of last half-block
% y(end-2*R/3+(1:2*R/3)) = y(end-2*R/3+(1:2*R/3)) ./ (w(R/3+1:R).^2)';
y(end-2*R/3+(1:R/3)) = 3*y(end-2*R/3+(1:R/3))/2;
y(end-R/3+(1:R/3)) = 3*y(end-R/3+(1:R/3));
 
% Display difference signal to verify perfect reconstruction
figure,plot((1:N)/fs,x-y)
title('Reconstruction error')
xlabel('Time (sec.)') 
xlim([0 N/fs])
% ylim([-1 1])
