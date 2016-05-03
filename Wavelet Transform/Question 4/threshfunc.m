function f = threshfunc(dN,thr,delta,alpha)
[c r]=size(dN);
maxi=max(max(dN));
dN=dN/maxi
 range1=thr-(delta/2);
 range2=thr+(delta/2);
 %for hard thresholding 
 r1=0;
if range1==range2
     r1=thr;
end
%  slope after r2
teta=atan((1-(range2-range1)^2)/(1-range2))
slope=tan(teta*alpha);

[c,r]=size(dN);

for i=1:c
    for j=1:r
       if dN(i,j)>=0 
           if dN(i,j)<range1
           dNthreshf(i,j)=0;
           else if dN(i,j)>=range1 && dN(i,j)<=range2
               dNthreshf(i,j)=((dN(i,j)-range1)^2);
           else if  dN(i,j)>range2
                   dNthreshf(i,j)=r1+slope*(dN(i,j)-range2)+((range2-range1)^2);
               end
               end
           end
       else if dN(i,j)<0 
           if dN(i,j)>-range1
           dNthreshf(i,j)=0;
           else if dN(i,j)<=-range1 && dN(i,j)>=-range2
               dNthreshf(i,j)=-((dN(i,j)-(-range1))^2);
           else if  dN(i,j)<range2
                   dNthreshf(i,j)=-r1+(slope*(dN(i,j)-(-range2))-(range2-range1)^2);
               end
               end
           end
           end
       end
    end
end
f=dNthreshf.*maxi;
end
