% 2. Find another window satisfying the perfect reconstruction condition
% for 50% overlapping, use it with your STFT program, and verify
%  that it reconstructs a test signal.

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

% half-cycle cosine window
n = (1:R) - 0.5;
w  = cos(pi*n/R);
figure,plot(w)
xlim([0 R])
title('Half-cycle cosine window')
xlabel('n')

% perfect reconstruction (PR) property:
% w(n)^2 + w(n+R/2)^2 = 1.
pr = w(1:R/2).^2 + w(R/2+(1:R/2)).^2;
figure,plot(pr)
title('Verify perfect reconstruction property of window function')
ylim([0 1.2])
xlim([1 R/2])

%  FORWARD STFT
X = zeros(R, Nb);
i = 0;
for k = 1:Nb
    X(:,k) = w'.*x(i + (1:R));
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
    y(i + (1:R)) = y(i + (1:R)) + w' .* Y(:,k);
    i = i + R/2;
end
% Take care of first half-block
y(1:R/2) = y(1:R/2) ./ (w(1:R/2).^2)';
% Take care of last half-block
y(end-R/2+(1:R/2)) = y(end-R/2+(1:R/2)) ./ (w(R/2+1:R).^2)';
% Display difference signal to verify perfect reconstruction
figure,plot((1:N)/fs,x-y)
title('Reconstruction error (using a sine window)')
xlabel('Time (sec.)') 
xlim([0 N/fs])
% ylim([-1 1])


    