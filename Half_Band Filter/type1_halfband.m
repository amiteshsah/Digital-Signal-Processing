clc;clear all; close all;
% for d=1
hn=[0 1 2 1 0];
b=poly(hn);
a=1;

% Stem plot
figure,stem(hn);
title('Impuse response of hn');

% Pole zero diagram
figure,zplane(b,a)
title('Pole zero diagram')

% Frequency Response
j=sqrt(-1);
om=linspace(-pi,pi,200);
Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
figure,plot(om/(2*pi),abs(Hf))
title('Frequency Response |H^f(\omega)|');
xlabel('\omega/2\pi');
