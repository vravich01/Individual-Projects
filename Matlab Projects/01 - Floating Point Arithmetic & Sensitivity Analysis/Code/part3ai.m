xVals = linspace(1.75, 2.25);

figure
hold on
f1Scat = scatter(xVals, f1(xVals), 20, 'k', 'x');
f2Scat = scatter(xVals, f2(xVals), 20, 'm', 'x');
xlim([1.75, 2.25]);
%ylim([,]);
xlabel('\fontsize{12.5}x (n = 100)');
ylabel('\fontsize{12.5}y');
title({'\fontsize{15}y=f1(x) & a 2nd Implementation, f2(x)';'\fontsize{15}for selected x-values'});
led = legend('f1(x)', 'f2(x)');

function [f1] = f1(x)
    f1 = (x - 2).^13;
end

function [f2] = f2(x)
    p = [1, -26, 312, -2288, 11440, -41184, 109824, -219648, 329472, -366080,  292864, -159774, 53248, -8192];
    f2 = polyval(p, x);
end