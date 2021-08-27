%%Header
figure;
hold on;
format long;
load("data.mat");

%%Set up
xVals = linspace(1, 100);

%%Computation
[U, Z, V] = svd(A);
[Un, Zn, Vn] = svd(An);
singValsA = diag(Z);
singValsAn = diag(Zn);
singValsA = singValsA(1:100, 1:1);
singValsAn = singValsAn(1:100, 1:1);

%%Results
singValPlotA = plot(xVals, singValsA);
singValPlotAn = plot(xVals, singValsAn);
set(gca, 'yscale', 'log');
set(gca,'XLim',[0, 100]);
xlabel({'n'});
ylabel({'Singular Values (Sigma_n)'});
title({'First 100 Singular Values of A and A_n'});