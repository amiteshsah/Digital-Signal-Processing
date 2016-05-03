clc;clear all;
close all;
dN=[-1:0.05:1];
% Normalsie
maxi=max(max(dN));
dN=dN./maxi;
% Parameters
thr=0.4;    %Threshold between 0 to 1 where 1 represents max value of signal
delta=0.3;  %Width to be taken consideration at threshold, for soft thresh around thresh
alpha=0.5;% Alpha should be between 0 to 1 for 1 to be hardthreshold, 0.5 to be approx soft thresh, 
% Range
 range1=thr-(delta/2);
 range2=thr+(delta/2);
 r1=0;
if range1==range2
     r1=thr;
end
%  slope after r2
teta=atan((1-(range2-range1)^2)/(1-range2));
slope=tan(teta*alpha);
[r,c]=size(dN);

for i=1:r
    for j=1:c
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
figure,
subplot(1,2,1),plot(dN,dN);title('Original signal');
subplot(1,2,2),plot(dN,dNthreshf);title('threshold signal');grid on

grid on

           
          

                   