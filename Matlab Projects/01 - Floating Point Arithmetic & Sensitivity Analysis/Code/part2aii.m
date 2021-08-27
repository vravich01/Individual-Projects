xVals = linspace(0, 1);
hFixed = 0.3;

figure
hold on
approx1ErrorScat = scatter(xVals, relError(trueDeriv(xVals), approx1(xVals, hFixed)), 20, 'r', 'o');
approx2ErrorScat = scatter(xVals, relError(trueDeriv(xVals), approx2(xVals, hFixed)), 20, 'b', 'o');
xlim([0, 1]);
ylim([0, 0.2]);
xlabel('\fontsize{12.5}x (n = 100)');
ylabel('\fontsize{12.5}Relative Error');
title({'\fontsize{15}Relative Errors of Approximations of y=log(1+x)';'\fontsize{15}for selected x-values'});
led = legend('Rel. Error for One-Sided Approximation', 'Rel. Error for Two-Sided Approximation');

function [func] = f(x)
    func = log(1 + x);
end

function [TD] = trueDeriv(x)
    TD = (1 + x) .^ (-1);
end

function [A1] = approx1(x, h)
    A1 = (f(x+h)-f(x))./(h);
end

function [A2] = approx2(x, h)
    A2 = (f(x+h)-f(x-h))./(2*h);
end

function [RE] = relError(exp, act)
    RE = abs(act-exp)./abs(exp);
end