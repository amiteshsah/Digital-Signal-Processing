clc;clear all;close all
N = 300;
n = (0:N-1)';                               % n : discrete-time index

w = 5;
n1 = 70;
n2 = 130;
x = 2.1 * exp(-0.5*((n-n1)/w).^2) - 0.5*exp(-0.5*((n-n2)/w).^2).*(n2 - n);    % x : input signal

h = n .* (0.9 .^n) .* sin(0.2*pi*n);        % h : impulse response

figure(1)
clf
subplot(2, 1, 1)
plot(x)
title('Input signal');
YL1 = [-2 3];
ylim(YL1);

subplot(2, 1, 2)
plot(h)
title('Impulse response');
randn('state', 0);                          % Set state for reproducibility

y = conv(h, x);
y = y(1:N);                                 % y : output signal (noise-free)

yn = y + 0.2 * randn(N, 1);                 % yn : output signal (noisy)

figure(2)
clf
subplot(2, 1, 1)
plot(y);
YL2 = [-7 13];
ylim(YL2);
title('Output signal');

subplot(2, 1, 2)
plot(yn);
title('Output signal (noisy)');
ylim(YL2);

H = convmtx(h, N);
H = H(1:N, :);                              % H : convolution matrix
e = ones(N, 1);
D = spdiags([e -2*e e], 0:2, N-2, N);

N = 100;
lambda = 0.1;
alpha = 1;
beta=max(eig(D'*D));
Nit = 700;

J = zeros(1, Nit); % Objective function
x = 0*H'*y; % Initialize x
T = lambda/(2*(alpha+lambda*beta));
for k = 1:Nit
Hx = H*x;
Dx= D*x;
J(k) = sum(abs(Hx(:)-y(:)).^2) + lambda*sum(abs(Dx(:)).^2);
x = wthresh(x*alpha + (H'*(y - Hx))/(alpha+lambda*beta),'s',T);
end
figure,subplot(2,1,1),plot(J),title('objective function');
subplot(2,1,2),plot(x),title('Restored signal');