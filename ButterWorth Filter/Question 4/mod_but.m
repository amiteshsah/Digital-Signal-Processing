
w=pi/4;
j=sqrt(-1);
e1=exp(j*w);
e2=exp(-j*w);
om = linspace(-pi, pi, 201);
b=poly([-1 -1 -1 -e1 -e2]);
f1=poly([-1 -1 -1 -1 -1 -1 -e1 -e2 -e1 -e2]);
f2=poly([1 1 1 1 1 1 e1 e2 e1 e2]);

k=50;
p=f1+k*f2;

SN = 0.0001; % Small Number (criterion for deciding if a
% root is on the unit circle).
rts = roots(p);
% The roots INSIDE the unit circle
irts = rts(abs(rts)<(1-SN));
% The roots ON the unit circle
orts = rts((abs(rts)>=(1-SN)) & (abs(rts)<=(1+SN)));
% N = length(orts);
% if rem(N,2) == 1
% disp(?Sorry, but there is a problem (1) in seprts.m?)
% r = [];
% return
% end
% Sort roots on the unit circle by angle
[a,k] = sort(angle(orts));
orts = orts(k(1:2:end));
% Make final list of roots
r = [irts; orts]
a=poly(r);
Hf=polyval(b,exp(j*om))./polyval(a,exp(j*om));
figure,plot(om./(2*pi),abs(Hf));
title('|H^f(\omega)|')
xlabel('\omega/(2\pi)')
figure,zplane(b,a)
% % Form the polynomial from the roots
% r = leja(r);
% h = poly(r);
% if isreal(p)
% h = real(h);
% end
% % normalize
% h = h*sqrt(max(p)/sum(abs(h).^2));