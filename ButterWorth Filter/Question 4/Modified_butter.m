clear all;close all;
x=input('Enter the order of the filter');
y=input('Enter the w (0 to 1) for null freq')

for i=1:x
    x1(i)=-1;
    x2(i)=1;
end
w=pi*y;
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

