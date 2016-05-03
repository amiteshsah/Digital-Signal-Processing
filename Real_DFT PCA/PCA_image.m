% Principle component analysis (PCA)
% Use PCA to calculate an optimal orthogonal (non-separable) transform for 4x4
% image blocks. To do this, take all 4x4 image blocks from an image, create a data matrix,
% then create a covariance matrix, and then perform eigenvector decomposition. The
% covariance matrix should be of size 16x16 and the eigenvectors should be of length 16.
% Each eigenvector is a vectorized set of 16 pixels in block of size 4x4. For reference, see
% the Matlab demo from class PCA_from_image_data.m which calculated an optimal
% transform for 8x1 image vectors.
%  Show the two-dimensional basis functions of 4x4 blocks. For example, my result is
% shown in the file two-dimensional PCA.pdf
%  Use your PCA to reconstruct an image from only four coefficients in each 4x4 block
% (i.e., set 12 of the 16 coefficients to zero).
% Reading: 'A Tutorial on Principal Component Analysis' by Jonathon Shlens
% http://arxiv.org/abs/1404.1100

clc;
clear all; close all
a=imread('lena_gray.bmp');
a = double(a);
[r,c]=size(a);
p=1;q=1;
for i=1:4:r
    for j=1:4:c
d{p,q,:}=a(i:4,j:4);
q=q+1;
    end
p=p+1;
end

%% Center the data (remove mean from each component)

p=1;q=1;
for i=1:4:r
    for j=1:4:c
res=a(i:i+4-1,j:j+4-1)-mean(mean(a(i:i+4-1,j:j+4-1)));
x3{p,q,:}=reshape(res,16,1);
q=q+1;
    end
p=p+1;
end


%% Compute covariance matrix
p=1;q=1;
for i=1:4:r
    for j=1:4:c
        z=x3{p,q,:};
N = size(z,2);
R{p,q,:} = (1/N) * z * (z');
q=q+1;
    end
p=p+1;
end
size(R{1,1,:})


%% Compute covariance matrix
p=1;q=1;
for i=1:4:r
    for j=1:4:c
        R1=R{p,q,:};
        [V, D] = eig(R1);
        % eigenvalues
        D1{p,q,:}=diag(D);
        V1{p,q,:}=V;
        q=q+1;
    end
    p=p+1;
end

%% Display PCA basis vectors
% Notice how similar the PCA basis vectors are to the DCT basis vectors!
% The first vector is a constant vector (approximately);
% the 2nd vector is like a half-cycle of a cosine waveform;
% the 3rd vector is like a whole cycle of a cosine waveform; etc.
%%
figure(4)
clf
p=1;q=1;
for k = 1:16
    subplot(8,2,k)
    plot(0:15, V1{p,q,:}, '.-', 'markersize', 12)
    box off
    xlim([0 15])
    ylim([-1 1])
    q=q+1;
    
end
orient landscape
print -dpdf PCA_from_image_data



