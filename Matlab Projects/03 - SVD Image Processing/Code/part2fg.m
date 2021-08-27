%%Header
figure;
hold on;
format long;
load("deblur.mat");

%%Set up
inc = 400;
kMax = 3600;
num = kMax / inc;
kVals = linspace(inc, kMax, num)';

%%Computation
[U, Z, V] = svd(A, 'econ');
relErrArray = zeros(num, 1);
i = 1;
for k = inc:inc:kMax
    [Uk, Zk, Vk] = truncSVD(U, Z, V, k);
    xk = Vk * (Zk \ Uk') * bn;
    e = relError(xk, xtrue);
    relErrArray(i) = e;
    i = i + 1;
end

%%Results
relErrMin = min(relErrArray);
relErrPlot = plot(kVals, relErrArray, 'g');
xlabel({'k'});
ylabel({'Relative Error of x_k'});
title({'Error of x_k, Relative to x_t'});

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