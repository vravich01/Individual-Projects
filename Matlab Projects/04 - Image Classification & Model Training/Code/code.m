%%Part 1A
format long
load("mnistSmall.mat");

%%Part 1B
trainX = double(trainX);
testX = double(testX);

%%Part 1C
trainXcenter = trainX;
trainXcenter = centerMatrix(trainXcenter);
trainX = trainXcenter;
testXcenter = testX;
testXcenter = centerMatrix(testXcenter);
testX = testXcenter;

%%Part 1D
k = 2;
[U, S, V] = svd(trainX, 'econ');
[Uk, Sk, Vk] = truncSVD(U, S, V, k);
trainXk = trainX * Vk;
%trainXk = Uk * Sk;
testXk = testX * Vk;

%%Part 1E
figure;
hold on;
gscatter(trainXk(:, 1), trainXk(:, 2), trainY, ['r','b'], ['x', 'x']);
title({'Decision Boundary','4 or 6'});

%%Part 2A
trainZ = grp2idx(trainY);
trainZ = 2*trainZ - 3;
trainZ = -1 * trainZ;

%%Part 2B
trainXkpad = [ones(size(trainXk, 1), 1), trainXk];
constants = trainXkpad \ trainZ;
zi = constants(1) + constants(2)*trainXk(:, 1) + constants(3)*trainXk(:, 2);

%%Part 2C
zSign = sign(zi);
ConfusionMatrixTrain = confusionmat(trainZ, zSign);

%%Part 2D
xVals = linspace(-1500, 1500);
yVals = -1 * ((constants(1) + constants(2)*xVals) / constants(3));
plot(xVals, yVals, 'k', 'DisplayName', 'Decision Boundary');
ylim([-1500, 2000]);

%%Part 2E
testZ = grp2idx(testY);
testZ = 2*testZ - 3;
testZ = -1 * testZ;
ziTest = constants(1) + constants(2)*testXk(:, 1) + constants(3)*testXk(:, 2);
zSignTest = sign(ziTest);
ConfusionMatrixTest = confusionmat(testZ, zSignTest);

%%Accuracy Rates
AccuracyRateTrain = (ConfusionMatrixTrain(1, 1) + ConfusionMatrixTrain(2, 2))/ sum(ConfusionMatrixTrain, 'all');
AccuracyRateTest = (ConfusionMatrixTest(1, 1) + ConfusionMatrixTest(2, 2))/ sum(ConfusionMatrixTest, 'all');

%%Functions
% Column mean helper function
function [colMean] = colMean(A, c)
    sum = 0;
    for i = 1:size(A, 1) %%Iterating through each row in a specific col c
        sum = sum + A(i, c);
    end
    colMean = sum / size(A, 1);
end

% Matrix centering function
function [A] = centerMatrix(A)
    for c = 1:size(A, 2) %%Iterating through each col c
    colMeanTemp = colMean(A, c);
        for i = 1:size(A, 1)
            A(i, c) = A(i, c) - colMeanTemp;
        end
    end
end

% SVD trunction function
function [Uk, Sk, Vk] = truncSVD(U, S, V, k)
    Uk = U(:, 1:k);
    Sk = S(1:k, 1:k);
    Vk = V(:, 1:k); 
end