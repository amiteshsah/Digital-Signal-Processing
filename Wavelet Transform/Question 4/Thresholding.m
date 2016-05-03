% D) Design your own threshold function. Use it to perform denoising in the wavelet
% domain. Compare your threshold function with soft and hard thresholding. Can you
% improve upon hard and soft thresholding? (Daubichies transform)


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

%  the number of level-operation
m=4;

% Definng the multipliers h0, h1, h2, h3
h0=(1+sqrt(3))/(4*sqrt(2));
h1=(3+sqrt(3))/(4*sqrt(2));
h2=(3-sqrt(3))/(4*sqrt(2));
h3=(1-sqrt(3))/(4*sqrt(2));


%%
% For Noise free+Noise signal
% For 4-Level Operation forward transform

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
figure('Name','Decomposition (Original_noise free + noise signal mixed in one signal)','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),plot(1:posd(m-j+1),dN(1:posd(m-j+1),m-j+1),'b',1:posd(m-j+1),devp(1:posd(m-j+1),m-j+1),'r',1:posd(m-j+1),devn(1:posd(m-j+1),m-j+1),'r');
end
%      subplot(m+1,1,1),bar(1,cN(1:posd(m),m));
    subplot(m+1,1,1), plot(1:posd(m),cN(1:posd(m),m),'b',1:posd(m),devp(1:posd(m),m),'r',1:posd(m),devn(1:posd(m),m),'r');


%%
% Nonlinear Thresholding(Hard threshold method)
thrh=2*sqrt(1);
dN_threshh = wthresh(dN,'h',thrh);
% cN_threshh = wthresh(cN,'h',thr);
cN_threshh = cN;
% Coefficient after thresholding
figure('Name','Coefficients after thresholding','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),bar(1:posd(m-j+1),dN_threshh(1:posd(m-j+1),m-j+1));
end
    subplot(m+1,1,1),bar(1:posd(m),cN_threshh(1:posd(m),m));
    
%% Nonlinear Thresholding(Soft threshold method)
thrs=2*sqrt(1);
dN_threshs = wthresh(dN,'s',thrs);
% cN_threshs = wthresh(cN,'h',thrs);
cN_threshs = cN;
% Coefficient after thresholding
figure('Name','Coefficients after thresholding','NumberTitle','off')
for j=1:m
    subplot(m+1,1,j+1),bar(1:posd(m-j+1),dN_threshs(1:posd(m-j+1),m-j+1));
end
    subplot(m+1,1,1),bar(1:posd(m),cN_threshs(1:posd(m),m));
%%
%User defined function threshfunc() for thresholding
% This function will also smoothen the image and preserve the edges too
thr=2*sqrt(1);    %Threshold between 0 to 1 where 1 represents max value of signal
delta=0.2;  %Width to be taken consideration at threshold, for soft thresh around thresh
alpha=1;% Alpha should be between 0 to 1 for 1 to be hardthreshold, 0.5 to be approx soft thresh, 
dN_threshf=threshfunc(dN,thrs,delta,alpha);
cN_threshf=cN;

%%
% For M-Level Operation inverse transform (after Hard Thresholding)
c1h=cN_threshh(1:posd(m),m);
d1h=dN_threshh;
k=m;
while k>=1
for i=1:posd(k)
    j=1;
    if i==1
    yh((2*i)-1,1)=h0*c1h(i)+h2*c1h(i)+h3*d1h(i,k)+h1*d1h(i,k);
    yh((2*i),1)=h1*c1h(i)+h3*c1h(i)-h2*d1h(i,k)-h0*d1h(i,k);
    else
    yh((2*i)-1,1)=h0*c1h(i)+h2*c1h(i-1)+h3*d1h(i,k)+h1*d1h(i-1,k);
    yh((2*i),1)=h1*c1h(i)+h3*c1h(i-1)-h2*d1h(i,k)-h0*d1h(i-1,k);
    end
end
c1h=yh;
k=k-1;
end
%%
% For M-Level Operation inverse transform (after Soft Thresholding)
c1s=cN_threshs(1:posd(m),m);
d1s=dN_threshs;
k=m;
while k>=1
for i=1:posd(k)
    j=1;
    if i==1
    ys((2*i)-1,1)=h0*c1s(i)+h2*c1s(i)+h3*d1s(i,k)+h1*d1s(i,k);
    ys((2*i),1)=h1*c1s(i)+h3*c1s(i)-h2*d1s(i,k)-h0*d1s(i,k);
    else
    ys((2*i)-1,1)=h0*c1s(i)+h2*c1s(i-1)+h3*d1s(i,k)+h1*d1s(i-1,k);
    ys((2*i),1)=h1*c1s(i)+h3*c1s(i-1)-h2*d1s(i,k)-h0*d1s(i-1,k);
    end
end
c1s=ys;
k=k-1;
end
%%% For M-Level Operation inverse transform (after User Defined function Thresholding)
c1f=cN_threshf(1:posd(m),m);
d1f=dN_threshf;
k=m;
while k>=1
for i=1:posd(k)
    j=1;
    if i==1
    yf((2*i)-1,1)=h0*c1f(i)+h2*c1f(i)+h3*d1f(i,k)+h1*d1f(i,k);
    yf((2*i),1)=h1*c1f(i)+h3*c1f(i)-h2*d1f(i,k)-h0*d1f(i,k);
    else
    yf((2*i)-1,1)=h0*c1f(i)+h2*c1f(i-1)+h3*d1f(i,k)+h1*d1f(i-1,k);
    yf((2*i),1)=h1*c1f(i)+h3*c1f(i-1)-h2*d1f(i,k)-h0*d1f(i-1,k);
    end
end
c1f=yf;
k=k-1;
end
%%
%Diplay
figure,
subplot(2,1,1),bar(dup_X), title('Original signal');
subplot(2,1,2),bar(dup_XN), title('Addded noise signal');

figure,
subplot(3,1,1),bar(yh), title('Inverted After Hard Thresholding');
subplot(3,1,2),bar(ys), title('Inverted After Soft Thresholding');
subplot(3,1,3),bar(yf), title('Inverted After Userfunction Thresholding');
