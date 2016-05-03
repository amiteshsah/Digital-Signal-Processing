% Matrix free method
function [x_deconv_LW_NonNeg, J2] = deconv_landweber_nonneg1(y, h, lambda, Nit);
N = 256;
H = @(x) conv(h,x);
Ht = @(y) convt(h,y);                             % H : convolution matrix
e = ones(N, 1);
D = spdiags([e -2*e e], 0:2, N-2, N);

alpha = 1;
beta=max(eig(D'*D));

J2 = zeros(1, Nit); % Objective function
x_deconv_LW_NonNeg = 0*Ht(y); % Initialize x
T = lambda/(2*(alpha+lambda*beta));
for k = 1:Nit
Hx = H(x_deconv_LW_NonNeg);
Dx= D*x_deconv_LW_NonNeg;
J2(k) = sum(abs(Hx(:)-y(:)).^2) + lambda*sum(abs(Dx(:)).^2);
x_deconv_LW_NonNeg= wthresh(x_deconv_LW_NonNeg*alpha + (Ht(y - Hx))/(alpha+lambda*beta),'s',T);
x_deconv_LW_NonNeg(x_deconv_LW_NonNeg<0)=0;
end