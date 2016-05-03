function y=invdaub(c,d,level)   
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

l=length(h);
l1=1;
h1=h(end:-1:1);
for n=1:l
h1(n)=power(-1,n-l1+1)*h1(n);
end

h_inv=fliplr(h);
h1_inv=fliplr(h1);
for i =level:-1:1  
y0{1,i}=conv(upsample(c{1,i},2),h_inv,'same');
y1{1,i}=conv(upsample(d{1,i},2),h1_inv,'same');
end

y=y0{1,1}+y1{1,1};

