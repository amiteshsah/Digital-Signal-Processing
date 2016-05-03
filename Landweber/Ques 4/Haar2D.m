clc;
clear all;
close all;
I=imread('lena_gray.bmp');
I=im2double(I);
[r,c]=size(I);

% 2D Forward HAAR Wavelet transform
S=zeros(r,c);
for i=1:r
    L{i,:}=Haar(I(i,:),1);
end

for i=1:r
    S(i,1:c/2)=[L{i,1}{1,2}];
    S(i,c/2+1:end)=[L{i,1}{1,1}];
end

for i=1:c
    L1{:,i}=Haar(S(:,i),1);
end

S1=zeros(r,c);
for i=1:c
    S1(1:r/2,i)=[L1{1,i}{1,2}];
    S1(r/2+1:end,i)=[L1{1,i}{1,1}];
end

LL=S1(1:r/2,1:c/2);
LH=S1(r/2+1:end,1:c/2);
HL=S1(1:r/2,c/2+1:end);
HH=S1(r/2+1:end,c/2+1:end);

figure,
subplot(2,2,1),imshow(LL,[]),title('LL');
subplot(2,2,2),imshow(HL,[]),title('HL');
subplot(2,2,3),imshow(LH,[]),title('LH');
subplot(2,2,4),imshow(HH,[]),title('HH');



