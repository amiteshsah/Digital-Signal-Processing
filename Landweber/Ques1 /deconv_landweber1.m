% Matrix free method
function [x_deconv_LW, J1] = deconv_landweber1(y, h, lambda, Nit)
N = 256;
H = @(x) conv(h,x);
Ht = @(y) convt(h,y);                              % H : convolution matrix
e = ones(N, 1);
D = spdiags([e -2*e e], 0:2, N-2, N);

alpha = 1;
beta=max(eig(D'*D));

J1 = zeros(1, Nit); % Objective function
x_deconv_LW = 0*Ht(y); % Initialize x
T = lambda/(2*(alpha+lambda*beta));
for k = 1:Nit
Hx = H(x_deconv_LW);
Dx= D*x_deconv_LW;
J1(k) = sum(abs(Hx(:)-y(:)).^2) + lambda*sum(abs(Dx(:)).^2);
x_deconv_LW = wthresh(x_deconv_LW*alpha + (Ht(y - Hx))/(alpha+lambda*beta),'s',T);
end