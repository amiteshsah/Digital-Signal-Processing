function [x_out] = leja(x_in)
% function [x_out] = leja(x_in)
%
% Input: x_in
%
% Output: x_out
%
% Program orders the values x_in (supposed to be the roots of a
% polynomial) in such a way that computing the polynomial coefficients
25
% by using the m-file poly yields most accurate results.
% Try, e.g.,
% z=exp(j*(1:100)*2*pi/100);
% and compute
% p1 = poly(z);
% p2 = poly(leja(z));
% which both should lead to the polynomial x^100-1. You will be
% surprised!
%
% ref.: Nachtigal, Reichel, Trefethen. "A Hybrid GMRES Algorithm for
% Nonsymmetric Linear Systems. SIAM J. Matr. Anal. and Appl., 13,
% 796-825, July 1992.
%File Name: leja.m
%Last Modification Date: %G% %U%
%Current Version: %M% %I%
%File Creation Date: Mon Nov 8 09:53:56 1993
%Author: Markus Lang <lang@dsp.rice.edu>
%
%Copyright: All software, documentation, and related files in this distribution
% are Copyright (c) 1993 Rice University
%
%Permission is granted for use and non-profit distribution providing that this
%notice be clearly maintained. The right to distribute any portion for profit
%or as part of any commercial product is specifically reserved for the author.
%
%Change History:
%
x = x_in(:).'; n = length(x);
a = x(ones(1,n+1),:);
a(1,:) = abs(a(1,:));
[dum1,ind] = max(a(1,1:n));
dum2 = a(:,1); a(:,1) = a(:,ind); a(:,ind) = dum2;
x_out(1) = a(n,ind);
a(2,2:n) = abs(a(2,2:n)-x_out(1));
for l=2:n-1
[dum1,ind] = max(prod(a(1:l,l:n))); ind = ind+l-1;
if l~=ind
dum2 = a(:,l); a(:,l) = a(:,ind); a(:,ind) = dum2;
end
x_out(l) = a(n,l);
a(l+1,(l+1):n) = abs(a(l+1,(l+1):n)-x_out(l));
end
x_out = a(n+1,:);