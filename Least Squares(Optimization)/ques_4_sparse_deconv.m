clc;clear all;close all
X=zeros(100,1);
X(8)=1.4;X(26)=1.6;X(32)=1.8;X(68)=2;X(88)=1.5;
h = [1 2 3 4 3 2 1]/16;
y=conv(X,h);
% adding white Gaussian noise with standard deviation 0.05
sigma = 0.05; N=length(y);
noise = sigma * randn(N,1);
y=y+noise;
N = 100;
H = convmtx(h',N);
lambda = 0.1;
alpha = 1;
Nit = 700;
[x, J] = ista(y, H, lambda, alpha, Nit);
figure,
subplot(2,1,1),stem(X),title('Sparse Signal');
subplot(2,1,2),stem(y),title('Observed Signal');
figure,
subplot(2,1,1),stem(x),title('Estimated signal');
subplot(2,1,2),plot(J),title('Objective function');


