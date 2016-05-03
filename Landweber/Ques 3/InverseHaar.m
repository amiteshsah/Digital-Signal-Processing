function y = InverseHaar(w, J, N)

% y = InverseHaar(w, J);
% Inverse Haar Transform
% See Haar.m

y = w{J+1};
for j = J:-1:1
    y = Inverse(y, w{j});
end
y = y(1:N);

end

% Local function

function y = Inverse(c, d)

% Ensure c and d are of equal length
N1 = length(c);
N2 = length(d);
N = max(N1, N2);
c = [c zeros(1, N-N1)];
d = [d zeros(1, N-N2)];

y = zeros(1, 2*N);
y(1:2:end) = ( c + d ) / sqrt(2);
y(2:2:end) = ( c - d ) / sqrt(2);

end
