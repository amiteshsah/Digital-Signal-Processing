function w = Haar(x, J)
% w = Haar(x, J)
% Haar Transform
%
% INPUT
%   x : input signal (row vector)
%   J : number of levels
%
% OUTPUT
%   w : cell array of wavelet coefficients
%
% Note: input signal x need not be a power of 2 in length
%
% % Example
% N = 100;                  % N: signal length
% x = rand(1,N);            % x: signal
% w = Haar(x, 4);           % w: wavelet coefficients
% y = InverseHaar(w, 4, N); % y: reconstructed signal
% max(abs(x - y))           % reconstruction error

w = cell(1, J+1);
for j = 1:J
    [x, w{j}] = AveDiff(x);
end
w{J+1} = x;

end

% Local function

function [c, d] = AveDiff(x)

N = length(x);
if mod(N, 2) == 0
    % x is even length
    c = ( x(1:2:N-1) + x(2:2:N) ) / sqrt(2);
    d = ( x(1:2:N-1) - x(2:2:N) ) / sqrt(2);
else
    % x is odd length
    c = ( x(1:2:N) + [x(2:2:N-1) 0] ) / sqrt(2);
    d = ( x(1:2:N) - [x(2:2:N-1) 0] ) / sqrt(2);
end

end

% Ivan Selesnick
% selesi@nyu.edu



