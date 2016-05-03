% Use Matlab to make the 7/9 symmetric biorthogonal Daubechies filters. Use the
% same product filter P(z) as for the design of orthonormal wavelet filters (i.e., a half-band
% Type 1 FIR filter of length 2N-1 with N zeros at z = -1). Use N = 8 to get the product filter
% P(z) needed here.
%  Implement a perfect reconstruction filter bank using the filter you create. Verify the
% filter bank has the perfect reconstruction propertyclc;

clear all;
close all;
Qz=[0.0024 -0.0195 0.0640 -0.1016 0.0640 -0.0195 0.0024];
hp=poly([-1 -1 -1 -1 -1 -1 -1 -1]);
p=conv(Qz,hp);
r=roots(p);
r0=zeros(6,1);
j=1;
for i=1:length(r)
if 0.9< abs(r(i,1)) && abs(r(i,1))<1
    r0(j,1)=r(i,1);
    j=j+1;
end
if imag(r(i,1))==0
    r0(j,1)=r(i,1);
    j=j+1;
end
end
h0=-poly(r0);
r1=setdiff(r,r0);
g0=poly(r1);
figure,
subplot(3,2,1),zplane(p),title('Product filter');
subplot(3,2,2),zplane(h0),title('HO Low pass filter');
subplot(3,2,3),zplane(g0),title('G0 Low Pass filter');
subplot(3,2,4),stem(h0),title('H0 Impulse Response');
subplot(3,2,5),stem(g0),title('G0 Impulse Response');

%% For high pass filter

rh=-r;
ph=poly(rh);
r2=zeros(6,1);
j=1;
for i=1:length(rh)
if 0.9< abs(rh(i,1)) && abs(rh(i,1))<1
    r2(j,1)=rh(i,1);
    j=j+1;
end
if imag(rh(i,1))==0
    r2(j,1)=rh(i,1);
    j=j+1;
end
end
g1=poly(r2);
r3=setdiff(rh,r2);
h1=poly(r3);
figure,
subplot(3,2,1),zplane(ph),title('Product filter');
subplot(3,2,2),zplane(h1),title('H1 High pass filter');
subplot(3,2,3),zplane(g1),title('G1 High Pass filter');
subplot(3,2,4),stem(h1),title('H1 Impulse Response');
subplot(3,2,5),stem(g1),title('G1 Impulse Response');

%% Verifying perfect reconstruction property
x=[1 2 3 4];
y1=conv(x,h0);
y1=downsample(y1,2);
y1=upsample(y1,2);
y1=conv(y1,g0);
y2=conv(x,h1);
y2=downsample(y2,2);
y2=upsample(y2,2);
y2=conv(y2,g1);
y=(y1+y2)/414;
figure,
subplot(1,2,1),stem(x);title('input signal');xlim([0 6]);
subplot(1,2,2),stem(y);title('output signal scaled down');
