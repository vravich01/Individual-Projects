xVals = linspace(1.75, 2.25);

figure
hold on
f1AbsErrScat = scatter(xVals, absError(f1(xVals), f2(xVals)), 20, 'm', 'o');
xlim([1.75, 2.25]);
xlabel('\fontsize{12.5}x (n = 100)');
ylabel('\fontsize{12.5}y');
title({'\fontsize{15}Absolute Error of 2nd Implementation';'for selected x-values'});
led = legend('Abs. Error for f2(x), f1(x) expected');

function [f1] = f1(x)
    f1 = (x - 2).^13;
end

function [f2] = f2(x)
    p = [1, -26, 312, -2288, 11440, -41184, 109824, -219648, 329472, -366080,  292864, -159774, 53248, -8192];
    f2 = polyval(p, x);
end

function [AE] = absError(exp, act)
    AE = abs(act-exp);
end