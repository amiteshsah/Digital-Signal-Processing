clc;clear all;close all;
%  B) Like for (A) but for Daubechies length-4 filter. See the lecture notes for the filter
% coefficients and filter equations. Write Matlab programs to implement forward and
% inverse transform with length-4 Daubechies filters. Verify perfect reconstruction in
% Matlab.  

% Reading a file
% X = dlmread('pwsmooth.txt');
X=[1 2 3 4 5 6 7 8 9 10 11 12];
% X = dlmread('skyline.txt');
l=length(X);    %Calculating the length of file
dup_X=X;
% Padding if odd length
if (mod(l,2)~=0)
        X(l+1,1)=0;
         l=l+1;    %New length is increased by 1
end 

%  the number of level-operation
m=4;

% Definng the multipliers h0, h1, h2, h3
h0=(1+sqrt(3))/(4*sqrt(2));
h1=(3+sqrt(3))/(4*sqrt(2));
h2=(3-sqrt(3))/(4*sqrt(2));
h3=(1-sqrt(3))/(4*sqrt(2));

% For 4-Level Operation forward transform
p=l/2;
for j=1:m
% For a single block operation
for i=1:p;
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
% % Locating the position at right where 0 starts
% for j=1:m
%     f=find(d(:,j));
%     posd(j)=f(length(f),1);
% end

figure,
for j=1:m
    subplot(m+1,1,j+1),bar(1:posd(m-j+1),d(1:posd(m-j+1),m-j+1));
end
     subplot(m+1,1,1),bar(1:posd(m),c(1:posd(m),m));

% For M-Level Operation inverse transform
c1=c(1:posd(m),m);
d1=d;
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

figure,
subplot(2,1,1),bar(dup_X), title('Original signal');
subplot(2,1,2),bar(y), title('Inverted back signal from decomposition');

