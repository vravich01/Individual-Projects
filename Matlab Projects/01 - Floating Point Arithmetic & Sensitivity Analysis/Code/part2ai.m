xVals = linspace(0, 1);
hFixed = 0.3;

figure
hold on
trueDerivScat = scatter(xVals, trueDeriv(xVals), 20, 'k', 'x');
approx1Scat = scatter(xVals, approx1(xVals, hFixed), 20, 'r', 'x');
approx2Scat = scatter(xVals, approx2(xVals, hFixed), 20, 'b', 'x');
xlim([0, 1]);
ylim([0.4, 1.1]);
xlabel('\fontsize{12.5}x (n = 100)');
ylabel('\fontsize{12.5}y');
title({'\fontsize{15}Derivative of y=log(1+x) & Approximations';'\fontsize{15}for selected x-values'});
led = legend('True/Symbolic Derivative', 'One-Sided Approximation', 'Two-Sided Approximation');

function [func] = f(x)
    func = log(1 + x);
end

function [TD] = trueDeriv(x)
    %syms x;
    %syms h;
    %TD = limit((f(x + h)-f(x))/(h), h, 0);
    
    TD = (1 + x) .^ (-1);
end

function [A1] = approx1(x, h)
    A1 = (f(x+h)-f(x))./(h);
end

function [A2] = approx2(x, h)
    A2 = (f(x+h)-f(x-h))./(2*h);
end