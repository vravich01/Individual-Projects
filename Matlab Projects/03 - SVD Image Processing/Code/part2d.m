%%Header
figure;
hold on;
format long;
load("deblur.mat");

%%Set up
numVals = 4096;
xVals = linspace(1, numVals, numVals);

%%Computation
[U, Z, V] = svd(A);
singValsA = diag(Z);
singValsA = singValsA(1:numVals, 1:1);
conditionNum = singValsA(1) / singValsA(numVals);

%%Results
singValPlotA = plot(xVals, singValsA, 'm');
set(gca,'XLim',[0, numVals]);
xlabel({'n'});
ylabel({'Singular Values (Sigma_n)'});
title({'Singular Values of A (Blurring Operator)'});