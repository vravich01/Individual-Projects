format long

a = [1, 3, 10^(-14), 1, (10^8 + 1)];
b = [-2, 10^(14), 9, 2, (2 * (10^8))];
c = [3, -1, -3, -10^(-14), ((10^8) - 1)];

fprintf('First Implementation: \n\n');

for i = 1:5
    [X_1, X_2] = myroots(a(i), b(i), c(i));
    fprintf("Trial: %d\n", i);
    disp(X_1);
    fprintf("\n");
    disp(X_2);
end

fprintf('\n\nSecond Implementation: \n\n');

for i = 1:5
    [x_1, x_2] = myroots_acc(a(i), b(i), c(i));
    fprintf("Trial: %d\n", i);
    disp(x_1);
    fprintf("\n");
    disp(x_2);
end

fprintf('\n\nThird Implementation: \n\n');

for i = 1:5
    p = [a(i) b(i) c(i)];
    root = roots(p);
    fprintf("Trial: %d\n", i);
    disp(root(1));
    fprintf("\n");
    disp(root(2));
end