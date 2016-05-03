% The cost function to minimized is
% F(w) = 0.5 || y - H invW w ||_2^2 + lambda || w ||_1
% where
% y - observed noisy blurry signal
% H - convolution operator
% invW - inverse Haar wavelet transform 
% w - Haar wavelet coefficients

function [x_deconv_sparswlet, cost_sparswlet, w] = deconv_sparse_Haar(y, h, J, lambda, Nit)
N = 256;
H = @(x) conv(h,x);
Ht = @(y) convt(h,y);                              % H : convolution matrix
e = ones(N, 1);
D = spdiags([e -2*e e], 0:2, N-2, N);
alpha = 1;
% Haar  and Inverse Transform
 w = Haar(y, J);           % w: wavelet coefficients
invW = InverseHaar(w, J, N); % invW: reconstructed signal
cost_sparswlet = zeros(1, Nit); % Objective function
x_deconv_sparswlet = 0*Ht(y); % Initialize x
p=zeros(1,length(y));
ck=Haar(p,J);
% x_deconv_sparswlet=H(invW);
T = lambda/(2*(alpha));
S = [w{:}];
for k = 1:Nit
% Hx = H(invW'*x_deconv_sparswlet);
S = [ck{:}];
invW = InverseHaar(w, J, N);
cost_sparswlet(k) = 0.5*sum(abs(y-H(invW)).^2) + lambda*sum(abs(S));
pk=Haar(Ht(y-H(invW)),J);
    for i=1:4
        ck{1,i}=wthresh(ck{1,i} + pk{1,i}/alpha,'s',T);
    end   
x_deconv_sparswlet=InverseHaar(ck, J, N);
ck=Haar(H(x_deconv_sparswlet), J); 
w=ck;
end
figure,plot(x_deconv_sparswlet);
figure,plot(cost_sparswlet);