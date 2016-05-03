% 4. Use the STFT and thresholding to reduce the noise level in a noisy
% speech signal. Try to use your own speech signal recorded using a 
% computer (most audio recordings with consumer equipment contain some hiss;
% try to reduce the sound of the hiss).
clc;clear all;close all
[s, fs] = audioread('noise_audio.mp3');
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

% STFT of noisy speech signal

 soundsc(x, fs);     % Play the audio file

% half-cycle sine window
n = (1:R) - 0.5;
w  = sin(pi*n/R);
figure,plot(w)
xlim([0 R])
title('Half-cycle sine window')
xlabel('n')

pr = w(1:R/2).^2 + w(R/2+(1:R/2)).^2;
figure,plot(pr)
title('Verify perfect reconstruction property of window function')
ylim([0 1.2])
xlim([1 R/2])

%  FORWARD STFT
X = zeros(R, Nb);
i = 0;

for k = 1:Nb
    X(:,k) = x(i+(1:R)).*w';
    i = i + R/2;
end
X = fft(X)./sqrt(R);                  % Compute the FFT of each block
X3 = fft(X)./sqrt(R);
Tr = R/fs;                   % Duration of each block (in seconds)

% plot spectrogram
figure,imagesc([0 N/fs], [0 fs/2], 20*log10(abs(X(1:R/2, :)))); 
cmap = flipud(gray);
colormap(cmap);
colorbar
axis xy 
xlabel('Time (sec.)') 
ylabel('Frequency (Hz)') 
caxis([-20 30])
title('Spectrogram of noisy speech signal') 


% Apply threshold in STFT domain

Y = X;
Threshold = 0.35;
k = abs(Y) < Threshold;
Y(k) = 0;
Y(:,1) = 0;   % remove start transients
Y(:,end) = 0;   % remove end transients
 
% display STFT
figure,imagesc([0 N/fs], [0 fs/2], 20*log10(abs(Y(1:R/2, :)))); 
colormap(cmap);
caxis([-20 30])
colorbar
axis xy 
xlabel('Time (sec.)') 
ylabel('Frequency (Hz)') 
title('Spectrogram after thresholding') 

%% Denoised speech signal

% y = my_istft(Y);
Y1 = ifft(Y);
Y3 = ifft(Y).*sqrt(R);        % inverse FFT of each column of X
y = zeros(size(x));
i = 0;
for k = 1:Nb
    y(i + (1:R)) = y(i + (1:R)) + w' .* Y1(:,k);
    i = i + R/2;
end
% Take care of first half-block
y(1:R/2) = y(1:R/2) ./ (w(1:R/2).^2)';
% Take care of last half-block
y(end-R/2+(1:R/2)) = y(end-R/2+(1:R/2)) ./ (w(R/2+1:R).^2)';
% Display difference signal to verify perfect reconstruction
figure,plot((1:N)/fs,x-y)
title('Reconstruction error')
xlabel('Time (sec.)') 
xlim([0 N/fs])
% ylim([-1 1])


y = y(1:N);
audiowrite('processed_speech.wav', y, fs);

figure,plot((1:N)/fs, y)
xlabel('Time (sec.)') 
title('Processed signal') 


soundsc(y, fs)
 
%% Compare noisy and processed speech fragments

% 

n = 8401:9800;
figure,subplot(2, 1, 1)
plot(n/fs, x(n))
title('Noisy speech - One segment')
axis tight

subplot(2, 1, 2)
plot(n/fs, y(n))
title('Processed speech - One segment')
axis tight

%% Proving Parseval Identity
signal_sum=sum(x.^2)
stftcoeff_sum=abs(sum(sum(abs(X3).^2)))
invstft_sum=sum(sum(Y3.^2))



