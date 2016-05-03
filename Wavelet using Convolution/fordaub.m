function [c,d]=fordaub(x,level)
% x=[1 2 3 4 5 6 7 8 9 10 11 12];
%  x = dlmread('pwsmooth.txt');
% level=4;

% padding of zero if the signal is odd length 
if mod(length(x),2)~=0
    x(1,end+1)=0;
end
    
k=2;
p1=[1 1];
p2=p1;
for i=1:2*k-1
    p2=conv(p2,p1);
end

q=[-1/16 1/4 -1/16];
p=conv(p2,q);
r=seprts(p);
h=poly(r);
h=real(h); % (discard zero imag part)
h=h*sqrt(max(p)/sum(abs(h).^2))

c=cell(1,level);
d=cell(1,level);
xin=x;

l=length(h);
l1=1;
h1=h(end:-1:1);
for n=1:l
h1(n)=power(-1,n-l1+1)*h1(n);
end

for i =1:level   
c{1,i}=downsample(conv(xin,h,'same'),2);
d{1,i}=downsample(conv(xin,h1,'same'),2);
xin=c{1,i};
end

