% Read DFT
% Construct the transform matrix for a 'real' 8-point DFT in Matlab. The matrix
% should be real-valued and orthonormal. Verify that the matrix is orthonormal (i.e., verify
% that the inverse matrix is the transpose matrix). Display the basis vectors (i.e., the rows
% of the forward transform or the columns of the inverse transform). The basis vectors of
% the 'real' DFT should be the real and imaginary parts of the basis vectors of the DFT
% with appropriate scaling constants for normalization. 

% Real valued DFT is obtained by mirroring N length sequence to form 2N-1 sequence.
% DFT=X1(k)=e^(-j*2*pi*-0.5*k/2N)*sum(x(n)*cos(pi/N *k*(n+0.5)) from 0 to N-1.
% Transform matrix is D(k,n)=sqrt(2/N)*cos(pi/N *k*(n-0.5)) . First row is sqrt(1/N)
clc;clear all;close all
N=8;
D=zeros(N,N);
for k=1:N-1
    for n=1:N
            D(k+1,n)=sqrt(2/N)*cos(pi/N *k*(n-0.5));
    end
end
D(1,:)=sqrt(1/N);

if inv(D)==transpose(D)
    disp('Orthonormal Matrix')
end

%% Basis Vector
b1=D(1,:)
disp('Basis Vector 1');

b2=D(2,:)
disp('Basis Vector 2');

b3=D(3,:)
disp('Basis Vector 3');

b4=D(4,:)
disp('Basis Vector 4');

b5=D(5,:)
disp('Basis Vector 5');

b6=D(6,:)
disp('Basis Vector 6');

b7=D(7,:)
disp('Basis Vector 7');

b8=D(8,:)
disp('Basis Vector 8');
