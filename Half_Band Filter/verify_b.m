clc;clear all; close all;
% for d=1
d=3;
% q=[0.5 0]
q=[-1/4 1 1/4];
% q=[3/38 -9/19 1 -9/19 3/38] 
p=[1 1];
p1=[1 1];
for i=1:d
    p=conv(p,p1);
end
hn=conv(q,p)

% Input signal
x=[1 2 3 5 3 2 1];

% x=dlmread('skyline.txt');
% Performing interpolation by 2
l=length(x);
if mod(length(x),2)==0
  x(l+1)=0;
end
l=length(x)-1;
j=l+1;
for i=l/2:-1:1
    x1(j)=0;
    x1(j-1)=x(i);
    j=j-2;
end

j=l+2;
for i=l/2+1:l+1
    x1(j)=x(i);
    x1(j+1)=0;
    j=j+2;
end
% Interpolation figure
figure,
subplot(1,2,1),stem(x);title('Original signal');
subplot(1,2,2),stem(x1);title('Interpolation by 2 upsampling')

% Output
yn=conv(x1,hn);
figure,
subplot(1,2,1),stem(x);title('Original signal');
subplot(1,2,2),stem(yn);title(['Output signal for d=' num2str(d)]);



% % Stem plot
% figure,subplot(1,2,1), stem(hn);
% title(['Impuse response of hn for d=' num2str(d)]);
% 
% % Pole zero diagram
% subplot(1,2,2), zplane(b,a)
% title(['Pole zero diagram for d=' num2str(d)]);
% 
% % Frequency Response
% j=sqrt(-1);
% om=linspace(-pi,pi,200);
% Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
% figure,plot(om/(2*pi),abs(Hf))
% title(['Frequency Response |H^f(\omega)|for d=',num2str(d)]);
% xlabel('\omega/2\pi');
