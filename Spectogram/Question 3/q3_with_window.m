% 3. Find the perfect reconstruction (PR) condition for an STFT 
% with 2/3 overlapping. Find a window that satisfies your PR condition. 
% Write a MATLAB program to implement the STFT and its inverse with 2/3 
% overlapping and verify the reconstruction of a test signal.

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

% half-cycle cosine window
n = (1:R) - 0.5;
w  = 2*sin(pi*n/R)/sqrt(6);
figure,plot(w)
xlim([0 R])
title('Half-cycle sine window')
xlabel('n')

% perfect reconstruction (PR) property:
% w(n)^2 + w(n+R/2)^2 = 1.
pr = w(1:R/3).^2 + w(R/3+(1:R/3)).^2+w(2*R/3+(1:R/3)).^2;
figure,plot(pr)
title('Verify perfect reconstruction property of window function')
ylim([0 1.2])
xlim([1 R/3])

%  FORWARD STFT
X1 = zeros(R, Nb);
i = 0;
for k = 1:Nb-1
%     X1(:,k) = w'.*x(i + (1:R));
X1(:,k) = w'.*x(i + (1:R));
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
 y(i + (1:R)) = y(i + (1:R)) + w'.*Y(:,k)./3;
    i = i + R/3;
end
% Take care of first half-block
y(1:R/3) = 3*y(1:R/3)./ (w(1:R/3).^2)';
y(R/3+1:2*R/3) = (3*y(R/3+1:2*R/3)/2)./(w(R/3+1:2*R/3).^2)';

% Take care of last half-block
y(end-2*R/3+(1:R/3)) = (3*y(end-2*R/3+(1:R/3))/2)./(w(R/3+(1:R/3)).^2)';
y(end-R/3+(1:R/3)) = (3*y(end-R/3+(1:R/3)))./(w(2*R/3+(1:R/3)).^2)';


% Display difference signal to verify perfect reconstruction
figure,plot((1:N)/fs,x-y)
title('Reconstruction error')
xlabel('Time (sec.)') 
xlim([0 N/fs])
ylim([-1 1])


    