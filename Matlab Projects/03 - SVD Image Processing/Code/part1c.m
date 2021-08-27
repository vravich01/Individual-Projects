%%Header
figure;
hold on;
format long;
load("data.mat");

%%Set up
kMax = 45;
inc = 5;
[U, Z, V] = svd(An, 'econ');

%%Computation & Results
sgtitle({'Lower Rank Truncations of A_n'});
i = 1;
for k = inc:inc:kMax
    [Uk, Zk, Vk] = truncSVD(U, Z, V, k);
    Ak = Uk * Zk * Vk.';
    subplot(3,3,i);
    imshow(Ak);
    title(sprintf('k = %d', k));
    i = i + 1;
end

%%Functions
function [Uk, Zk, Vk] = truncSVD(U, Z, V, k)
    Uk = U(:, 1:k);
    Zk = Z(1:k, 1:k);
    Vk = V(:, 1:k); 
end