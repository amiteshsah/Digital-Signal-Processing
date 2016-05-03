% 1. Write a MATLAB program to implement the STFT with 50% overlapping
% and a second pro- gram to implement its inverse. 
% Verify numerically that the inverse program reconstructs a test signal

clc;clear all; close all

% Read a signal or audio file
[s,fs]=audioread('sp1.wav');

% Length of audio signal
N=length(s);

% Block length
R=512;

% Overlapping is 50% , Number of block calculation
Nb=floor(N/(R/2))-1;  

% Plotting the speech signal
x=s(1:(Nb+1)*(R/2));
N = length(x);
figure,plot((1:N)/fs, x)
title('Speech signal')
xlabel('Time (seconds)')

soundsc(x, fs);     % Play the audio file

%  FORWARD STFT
X = zeros(R, Nb);
i = 0;
for k = 1:Nb
    X(:,k) = x(i + (1:R));
    i = i + R/2;
end
X = fft(X);                  % Compute the FFT of each block
Tr = R/fs;                   % Duration of each block (in seconds)

% plot spectrogram
figure,imagesc([0 N/fs], [0 fs/2], 20*log10(abs(X(1:R/2, :)))); 
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
for k = 1:Nb
    y(i+(1:R),1)=y(i+(1:R),1)+0.5*Y(:, k);
    i = i + R/2;
end
% Take care of first half-block
y(1:R/2) = 2*y(1:R/2);
% Take care of last half-block
y(end-R/2+(1:R/2)) = 2*y(end-R/2+(1:R/2));
z=x-y;
% Display difference signal to verify perfect reconstruction
figure,plot((1:N)/fs,z)
title('Reconstruction error')
xlabel('Time (sec.)') 
xlim([0 N/fs])
% ylim([-1 1])


    