format long
xFixed = 0;
hVals = logspace(-15, -1, 15);

figure
hold on
trueDerivFixedMatrix = zeros(1,15)+trueDeriv(xFixed);
approx1ErrorScat = scatter(hVals, relError(trueDerivFixedMatrix, approx1(xFixed, hVals)), 20, 'r', 'o');
approx2ErrorScat = scatter(hVals, relError(trueDerivFixedMatrix, approx2(xFixed, hVals)), 20, 'b', 'o');
set(gca,'xscale','log');
set(gca,'yscale','log');
xlim([0, 1]);
ylim([0, 1]);
xlabel('\fontsize{12.5}h-intervals (n = 15)');
ylabel('\fontsize{12.5}Relative Error');
title({'\fontsize{15}Relative Errors of Approximations of y=log(1+x)';'\fontsize{15}over various h-intervals'});
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