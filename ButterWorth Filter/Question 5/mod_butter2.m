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
l=length(b);
p=conv(b,b(l:-1:1));
h=sfact(p);
p2=p-conv(h,h(l:-1:1))
% 
% f1=poly([x1 x1 e1 e1conj])
% % f2=poly([x2 x2 0 0]);
% 
% k=100;
% p=f1+k*f2;
