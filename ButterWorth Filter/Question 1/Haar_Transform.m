clc;clear all;close all;
% A) Haar wavelet transform: Write Matlab programs to implement forward and inverse
% Haar transform. The equations in lecture notes should be sufficient. Verify perfect
% reconstruction in Matlab. 

% Reading a file
X = dlmread('skyline.txt');
l=length(X);    %Calculating the length of file
dup_X=X;
% Padding if odd length
if (mod(l,2)~=0)
        X(l+1,1)=0;
         l=l+1;    %New length is increased by 1
end 

%
% To find the number of level-operation
k=l;
m=1;
while k~=2
    k=k/2;
    m=m+1;
end
% 

% For M-Level Operation forward transform
p=l;
coef=1/2;
for j=1:m
% For a single block operation
for i=1:(p/2);
    c(i,j)= coef*X(2*i-1)+coef*X((2*i));
    d(i,j)= coef*X(2*i-1)-coef*X((2*i));    
end
posd(j)=i;
clearvars X;
X=c(:,j);
p=p/2;
end
% 

figure,
for j=1:m
    subplot(m+1,1,j+1),bar(1:posd(m-j+1),d(1:posd(m-j+1),m-j+1));
end
     subplot(m+1,1,1),bar(1,c(1:posd(m),m));

% For M-Level Operation inverse transform
c1=c(1:posd(m),m);
d1=d;
k=m;
while k>=1
for i=1:posd(k)
    y((2*i)-1,1)=c1(i)+d1(i,k);
    y((2*i),1)=c1(i)-d1(i,k);
end
c1=y;
k=k-1;
end

figure,
subplot(2,1,1),bar(dup_X), title('Original signal');
subplot(2,1,2),bar(y), title('Inverted back signal from decomposition');

% Proving Parseval Identity
x_sum=sum(dup_X.^2)
c_sum=sum(sum(c.^2));
d_sum=sum(sum(d.^2));
wavelet_sum=c_sum+d_sum
y_sum=sum(y.^2)

