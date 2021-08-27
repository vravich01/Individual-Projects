%%Header
figure;
hold on;
format long;
load("deblur.mat");

%%Set up
dimen = 64;
kMax = 3600;
inc = 400;
[U, Z, V] = svd(A, 'econ');

%%Computation & Results
sgtitle({'Lower Rank Truncations of x'});
i = 1;
for k = inc:inc:kMax
    [Uk, Zk, Vk] = truncSVD(U, Z, V, k);
    xk = Vk * (Zk \ Uk') * bn;
    subplot(3,3,i);
    imshow(reshape(xk, [dimen, dimen]));
    title(sprintf('k = %d', k));
    i = i + 1;
end

%%Functions
function [Uk, Zk, Vk] = truncSVD(U, Z, V, k)
    Uk = U(:, 1:k);
    Zk = Z(1:k, 1:k);
    Vk = V(:, 1:k); 
end