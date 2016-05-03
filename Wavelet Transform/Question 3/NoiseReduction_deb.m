% C) Create examples of noise reduction using your wavelet transform programs with
% nonlinear thresholding. Compare Haar filters and Daubechies length-4 filters for noise
% reduction. Daubechies length 4

clc;clear all;close all;

% Reading a file
X = dlmread('skyline.txt');
l=length(X);    %Calculating the length of file
X=5.*X;
dup_X=X;
% X=5.*X;
% Padding if odd length
if (mod(l,2)~=0)
        X(l+1,1)=0;
         l=l+1;    %New length is increased by 1
end 

% Adding zero mean white gaussian noise to signal with sqrt(1) standard deviation
noise=0.1*randn(size(X));
XN=X+noise;
dup_XN=XN;
dup_noise=noise;

%  the number of level-operation
m=4;

% Definng the multipliers h0, h1, h2, h3
h0=(1+sqrt(3))/(4*sqrt(2));
h1=(3+sqrt(3))/(4*sqrt(2));
h2=(3-sqrt(3))/(4*sqrt(2));
h3=(1-sqrt(3))/(4*sqrt(2));

%%
% For Noise free signal 
% For 4-Level Operation forward transform
p=l/2;
for j=1:m
% For a single block operation
for i=1:p
    if i==p
        c(i,j)= h0*X(2*i-1)+h1*X(2*i)+h2*X(2*i)+h3*X(2*i);
        d(i,j)= h3*X(2*i-1)-h2*X(2*i)+h1*X(2*i)-h0*X(2*i); 
    else
        c(i,j)= h0*X(2*i-1)+h1*X(2*i)+h2*X((2*i)+1)+h3*X((2*i+2));
        d(i,j)= h3*X(2*i-1)-h2*X(2*i)+h1*X((2*i)+1)-h0*X((2*i+2));  
    end
end
posd(j)=i;
clearvars X;
X=c(:,j);
p=p/2;
end
% 
%%
% For only Noise signal 
% For 4-Level Operation forward transform
p=l/2;
for j=1:m
% For a single block operation
for i=1:p;
    if i==p
        cnoise(i,j)= h0*noise(2*i-1)+h1*noise(2*i)+h2*noise(2*i)+h3*noise(2*i);
        dnoise(i,j)= h3*noise(2*i-1)-h2*noise(2*i)+h1*noise(2*i)-h0*noise(2*i); 
    else
        cnoise(i,j)= h0*noise(2*i-1)+h1*noise(2*i)+h2*noise((2*i)+1)+h3*noise((2*i+2));
        dnoise(i,j)= h3*noise(2*i-1)-h2*noise(2*i)+h1*noise((2*i)+1)-h0*noise((2*i+2));  
    end
end
clearvars noise;
noise=cnoise(:,j);
p=p/2;
end
% 
% Here we can see that the wavelet representation of the noisy signal is itself noisy.
% Plotting of decomposition d1, d2, d3... dn , cn
figure('Name','Decomposition (Original_noise free and noise signal)','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),plot(1:posd(m-j+1),d(1:posd(m-j+1),m-j+1),'b',1:posd(m-j+1),dnoise(1:posd(m-j+1),m-j+1),'r');
end
     subplot(m+1,1,1),plot(1:posd(m),c(1:posd(m),m),'b',1:posd(m),cnoise(1:posd(m),m),'r');
%%
% For Noise free+Noise signal
% For M-Level Operation forward transform

p=l/2;
for j=1:m
% For a single block operation
for i=1:p
    if i==p
        cN(i,j)= h0*XN(2*i-1)+h1*XN(2*i)+h2*XN(2*i)+h3*XN(2*i);
        dN(i,j)= h3*XN(2*i-1)-h2*XN(2*i)+h1*XN(2*i)-h0*XN(2*i); 
        devp(i,j)=2*sqrt(1);
        devn(i,j)=-2*sqrt(1);
    else
        cN(i,j)= h0*XN(2*i-1)+h1*XN(2*i)+h2*XN((2*i)+1)+h3*XN((2*i+2));
        dN(i,j)= h3*XN(2*i-1)-h2*XN(2*i)+h1*XN((2*i)+1)-h0*XN((2*i+2)); 
        devp(i,j)=2*sqrt(1);
        devn(i,j)=-2*sqrt(1);
    end
end
posd(j)=i;
clearvars XN;
XN=cN(:,j);
p=p/2;
end
% 
% the standard deviation of the noise in the wavelet representation is the same as the standard deviation of the noise that was added
% to the signal. The red lines displayed in this noisy wavelet representation indicates ±2 !n
% Plotting of decomposition d1, d2, d3... dn , cn
figure('Name','Decomposition (Original_noise free + noise signal in one signal)','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),plot(1:posd(m-j+1),dN(1:posd(m-j+1),m-j+1),'b',1:posd(m-j+1),devp(1:posd(m-j+1),m-j+1),'r',1:posd(m-j+1),devn(1:posd(m-j+1),m-j+1),'r');
end
%      subplot(m+1,1,1),bar(1,cN(1:posd(m),m));
    subplot(m+1,1,1), plot(1:posd(m),cN(1:posd(m),m),'b',1:posd(m),devp(1:posd(m),m),'r',1:posd(m),devn(1:posd(m),m),'r');


%%
% Nonlinear Thresholding(Hard threshold method)
thr=2*0.1;
dN_thresh = wthresh(dN,'h',thr);
% cN_thresh = wthresh(cN,'h',thr);
cN_thresh = cN;
% Coefficient after thresholding
figure('Name','Decomposition after thresholding','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),bar(1:posd(m-j+1),dN_thresh(1:posd(m-j+1),m-j+1));
end
    subplot(m+1,1,1),bar(1:posd(m),cN_thresh(1:posd(m),m));
%%  
% For M-Level Operation inverse transform


c1=cN_thresh(1:posd(m),m);
d1=dN_thresh;
k=m;
while k>=1
for i=1:posd(k)
    j=1;
    if i==1
    y((2*i)-1,1)=h0*c1(i)+h2*c1(i)+h3*d1(i,k)+h1*d1(i,k);
    y((2*i),1)=h1*c1(i)+h3*c1(i)-h2*d1(i,k)-h0*d1(i,k);
    else
    y((2*i)-1,1)=h0*c1(i)+h2*c1(i-1)+h3*d1(i,k)+h1*d1(i-1,k);
    y((2*i),1)=h1*c1(i)+h3*c1(i-1)-h2*d1(i,k)-h0*d1(i-1,k);
    end
end
c1=y;
k=k-1;
end

%%
%Diplay
figure,
subplot(3,1,1),bar(dup_X), title('Original signal');
subplot(3,1,2),bar(dup_XN), title('Addded noise signal');
% subplot(3,1,3),bar(y), title('Inverted back signal from decomposition');
subplot(3,1,3),bar(c1), title('Inverted back NOISE free signal from decomposition');
