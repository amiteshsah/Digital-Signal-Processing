clear all;close all;

% load ECG signal
Fs=256;
x=ecgsyn(Fs,10);
n=0:length(x)-1;
t=n/Fs;

% Noise signal
N=length(x);
sigma=0.2;                    % sigma : noise standard deviation
noise=sigma*randn(N, 1);    % noise : white Gaussian noise
g1=x+noise;                 % g1 : noisy ECG (white noise)
g2=x+cos(0.2*pi*n');        % g2 : ECG with white noise and tonal noise
g3=x+cos(0.2*pi*n');       % g3 : ECG with tonal noise
figure,plot(t,g2);
title('Noisy ECG signal')
xlabel('Time in sec');
xlim([4 7]);

% Fourier Transform of noise signal

ff=fftshift(fft(g2,N));%Fourier Transform of noise signal
t1=(-N/2:N/2-1)/N;
f2=fftshift(fft(x,N))% Fourier transform of original signal
figure,plot(t1,abs(ff),t1,abs(f2));
legend('noisy ecg','true ecg');
xlabel('Normalized Frequency');
ylabel('Magnitude');
title('Double Sided FFT - with FFTShift of noise signal');

Order=input('Enter the order of the filter');
fre=input('Enter the w (0 to 1) for null freq')

for i=1:Order
    x1(i)=-1;
    x2(i)=1;
end
w=pi*fre;
j=sqrt(-1);
e1=exp(j*w);
e1conj=exp(-j*w);
om = linspace(-pi, pi, 201);
b=poly([x1 e1 e1conj]);

f1=poly([x1 x1 e1 e1conj])
f2=poly([x2 x2 0 0]);

k=100;
p=f1+k*f2;
% zplane(p);
r2=roots(p)
r=r2( abs(r2) < 1 )   % select roots inside unit circle for stability
a=poly(r)

% Impulse Response
imp=[1 zeros(1,100)];
h=filter(b,a,imp);
figure,stem(h)
xlabel('samples n');
ylabel('Amplitude');
title('Impulse Response of the filter');

%Frequency Response
m=(polyval(b,1))/(polyval(a,1));
Hf=(polyval(b,exp(j*om))./polyval(a,exp(j*om)))/m;
figure,plot(om./(2*pi),abs(Hf));
title('|H^f(\omega)|')
xlabel('\omega/(2\pi)')


% Pole zero diagram
figure,zplane(b,a)
title('Pole zero diagram of butterworth filter of order n and null freq')


% Filter using inbult butterworth filter
[b1,a1]=butter(3,0.08); %Third order filter with 0.3pi radian/sec as cutoff freq
y1=filter(b1,a1,g3);

% Apply low pass filter to noisy ECG signal
y=filter(b,a,g3);
figure,plot(t,y/8,t,y1)
legend('using modified butterworth filter','using inbuilt butterworth filter')
title('Filter output signal')
xlabel('Time (seconds)')
xlim([4 6]);

