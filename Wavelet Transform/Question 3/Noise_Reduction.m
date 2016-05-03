% C) Create examples of noise reduction using your wavelet transform programs with
% nonlinear thresholding. Compare Haar filters and Daubechies length-4 filters for noise
% reduction. 

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
noise=sqrt(1)*randn(size(X));
XN=X+noise;
dup_XN=XN;
dup_noise=noise;

% To find the number of level-operation
k=l;
m=1;
while k~=2
    k=k/2;
    m=m+1;
end
%%
% For Noise free signal 
% For M-Level Operation forward transform
p=l;
for j=1:m
% For a single block operation
for i=1:(p/2);
    c(i,j)= 0.5*X(2*i-1)+0.5*X((2*i));
    d(i,j)= 0.5*X(2*i-1)-0.5*X((2*i));    
end
posd(j)=i;
clearvars X;
X=c(:,j);
p=p/2;
end
% 
%%
% For only Noise signal 
% For M-Level Operation forward transform
p=l/2;
for j=1:m
% For a single block operation
for i=1:p;
    cnoise(i,j)= 0.5*noise(2*i-1)+0.5*noise((2*i));
    dnoise(i,j)= 0.5*noise(2*i-1)-0.5*noise((2*i));    
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
     subplot(m+1,1,1),plot(1,c(1:posd(m),m),'b',1,cnoise(1:posd(m),m),'r');
%%
% For Noise free+Noise signal
% For M-Level Operation forward transform
p=l;

for j=1:m
% For a single block operation
for i=1:(p/2);
    cN(i,j)= 0.5*XN(2*i-1)+0.5*XN((2*i));
    dN(i,j)= 0.5*XN(2*i-1)-0.5*XN((2*i)); 
    devp(i,j)=2*sqrt(1);
    devn(i,j)=-2*sqrt(1);
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
%     hold on
%     subplot(m+1,1,j+1),plot(1:posd(m-j+1),2*sqrt(1),'r');
%     subplot(m+1,1,j+1),plot(1:posd(m-j+1),-2*sqrt(1),'r');
%     hold off
% subplot(m+1,1,j+1),
%     [ax,b,p] = plotyy(1:posd(m-j+1),dN(1:posd(m-j+1),m-j+1),1:posd(m-j+1),2*sqrt(1),'bar','plot');
% %     p.Color=[1,0,0];
end
%      subplot(m+1,1,1),bar(1,cN(1:posd(m),m));
    subplot(m+1,1,1), plot(1:posd(m),cN(1:posd(m),m),'b',1:posd(m),devp(1:posd(m),m),'r',1:posd(m),devn(1:posd(m),m),'r');


%%
% Nonlinear Thresholding(Hard threshold method)
thr=2*sqrt(1);
dN_thresh = wthresh(dN,'h',thr);
% cN_thresh = wthresh(cN,'h',thr);
cN_thresh =cN;
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
    y((2*i)-1,1)=c1(i)+d1(i,k);
    y((2*i),1)=c1(i)-d1(i,k);
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
