close all
om=linspace(-pi,pi,201);
[b,a]=butter(3,0.1);
Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
figure,subplot(1,3,1),zplane(b,a)
subplot(1,3,2),plot(om./(2*pi),Hf);
subplot(1,3,3),plot(om./(2*pi),1-Hf);

% diff=(a-b);
% Hf2=polyval(diff,exp(j*om))./polyval(a,exp(j*om));
% figure,subplot(1,3,1),zplane(diff,a)
% subplot(1,3,2),plot(om./(2*pi),abs(Hf2));
% subplot(1,3,3),plot(om./(2*pi),abs(1-Hf2));

num=polyval(b,1)
den=polyval(a,1)
dc=num./den
roots(a)

% clear all;close all;
% w=pi/4;
% j=sqrt(-1);
% e1=exp(j*w);
% % e2=exp(j*(pi-w));
% e1conj=exp(-j*w);
% % e2conj=exp(-j*(pi-w));
% om = linspace(-pi, pi, 201);
% b=poly([-1 -1 -1 -1 -1 -1]);
% c=poly([exp(j*w)]);
% d=conv(c,c(end:-1:1));
% f1=conv(b,d);
% f2=poly([1 1 1 1 1 1 1 1]);
% 
% [b1,a1]=butter(3,0.3);
% 
% k=50;
% p=f1+k*f2;
% zplane(p);
% r2=roots(p)
% r=r2( abs(r2) < 1 )   % select roots inside unit circle for stability
% a=poly(r)
% 
% figure,zplane(r)
% figure,zplane(b,a)
% 
% Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
% figure,plot(om./(2*pi),abs(Hf),om./(2*pi),abs(Hf));
% title('|H^f(\omega)|')
% xlabel('\omega/(2\pi)')
