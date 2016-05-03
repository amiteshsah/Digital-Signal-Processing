function [y,yi]=myupsample(up,x)
l=length(x);
% If even length,make it odd length for indexing convinance
if mod(l,2)~=0
    li=l-1;
end
xi=-li/2:1:li/2;

% Upsampling index
y_len=l*up+up-1;

if mod(y_len,2)~=0
    y_leni=y_len-1;
end
yi=-y_leni/2:1:y_leni/2

j=1;k=1;
while j<=y_leni-up
   for i=1:1:up-1
       y(j)=0;
       j=j+1;
   end
   y(j)=x(k);
   j=j+1;k=k+1;
end
  for i=1:1:up-1
       y(j)=0;
       j=j+1;
  end
  figure,
    subplot(1,2,1),stem(xi,x), title('input signal');
   subplot(1,2,2),stem(yi,y);title(['Output signal upsampled by:',num2str(up)])
end

   
   