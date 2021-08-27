%%Header
figure;
hold on;
format long;
load("data.mat");

%%Set up
kMax = 45;
kVals = linspace(1, kMax, kMax)';

%%Computation
[U, Z, V] = svd(An, 'econ');
relErrArray = zeros(kMax, 1);
for i = 1:kMax
    [Uk, Zk, Vk] = truncSVD(U, Z, V, i);
    Ak = Uk * Zk * Vk.';
    e = relError(Ak, A);
    relErrArray(i) = e;
end

%%Results
relErrMin = min(relErrArray);
relErrPlot = plot(kVals, relErrArray, 'g');
xlabel({'k'});
ylabel({'Relative Error of A_k'});
title({'Error of A_k, Relative to A'});

%%Functions
function [Uk, Zk, Vk] = truncSVD(U, Z, V, k)
    Uk = U(:, 1:k);
    Zk = Z(1:k, 1:k);
    Vk = V(:, 1:k); 
end

function [e] = relError(Ak, A)
    num = norm(Ak - A, 'fro');
    denom = norm(A, 'fro');
    e = num / denom;
end