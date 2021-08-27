format long

%%% Initial set up
% # Trials
numTrials = 500;
% Values of theta, generated randomly from a uniform(0, 2pi) distribution
randThetaVals = (2 * pi * rand(numTrials, 1));
% Control constant
ccAlpha = -0.4;

%%% Important values (X)
% Estimate of E[X], average value of X over numTrials
estimateEX = randomVarBarX(randThetaVals);
% Estimate of Std[X], using values of X over numTrials
stdX = std(randomVarX(randThetaVals));
% Standard Error of X, using values of X over numtrials
steX = stdX ./ sqrt(numTrials);
% 99.7% confidence interval for E[X]
confIntX = [estimateEX - 3 .* steX, estimateEX + 3 .* steX];

%%% Important values (Z)
% Estimate of E[Z], average value of Z over numTrials
estimateEZ = randomVarBarZ(randThetaVals, ccAlpha);
% Estimate of Std[Z], using values of Z over numTrials
stdZ = std(randomVarZ(randThetaVals, ccAlpha));
% Standard Error of Z, using values of Z over numtrials
steZ = stdZ ./ sqrt(numTrials);
% 99.7% confidence interval for E[Z]
confIntZ = [estimateEZ - 3 .* steZ, estimateEZ + 3 .* steZ];

%%% Important values (ZZ)
% Estimate of E[ZZ], average value of ZZ over numTrials
estimateEZZ = randomVarBarZZ(randThetaVals, ccAlpha);
% Estimate of Std[ZZ], using values of ZZ over numTrials
stdZZ = std(randomVarZZ(randThetaVals, ccAlpha));
% Standard Error of ZZ, using values of ZZ over numtrials
steZZ = stdZZ ./ sqrt(numTrials);
% 99.7% confidence interval for E[ZZ]
confIntZZ = [estimateEZZ - 3 .* steZZ, estimateEZZ + 3 .* steZZ];

%%% Important value (ccAlpha)
% Estimate of best value of control constant ccAlpha
bestCcAlphaZ = optimize(randThetaVals, -1.2, 1.2);
% Standard Error of Z, using values of Z over numtrials, using ccAlphaBest
bestSteZ = std(randomVarZ(randThetaVals, bestCcAlphaZ)) ./ sqrt(numTrials);
% Estimate of best value of control constant ccAlpha
bestCcAlphaZZ = optimize(randThetaVals, -1.2, 1.2);
% Standard Error of Z, using values of Z over numtrials, using ccAlphaBest
bestSteZZ = std(randomVarZZ(randThetaVals, bestCcAlphaZZ)) ./ sqrt(numTrials);

%%% Polar curves
% H function
function [heartRadius] = heartRadius(theta)
    heartRadius = 2 - 2 .* sin(theta) + (sin(theta) .* sqrt(abs(cos(theta)))) ./ (sin(theta) + 1.4);
end
% C function
function [circleRadius] = circleRadius(theta)
    circleRadius = sqrt(4 - cos(theta) .^ 2) - sin(theta);
end
% L[imacon] function
function [limaconRadius] = limaconRadius(theta)
    limaconRadius = 2 .* sqrt(1 - sin(theta));
end

%%% Random variables
% Creates random variable X = pi * heartRadius(theta) .^ 2, 
function [X] = randomVarX(theta)
    X = pi * heartRadius(theta) .^ 2;
end
% Creates random variable Y = pi * circleRadius(theta) .^ 2, 
function [Y] = randomVarY(theta)
    Y = pi * circleRadius(theta) .^ 2;
end
% Creates random variable Z = X + a(Y - E[Y])
function [Z] = randomVarZ(theta, a)
    Z = randomVarX(theta) + a .* (randomVarY(theta) - (pi .* 2 .^ 2 ));
end
% Creates random variable Y2 = pi * circleRadius(theta) .^ 2, 
function [Y2] = randomVarY2(theta)
    Y2 = pi * limaconRadius(theta) .^ 2;
end
% Creates random variable Z = X + a(Y - E[Y])
function [ZZ] = randomVarZZ(theta, a)
    ZZ = randomVarX(theta) + a .* (randomVarY2(theta) - (pi .* 2 .^ 2 ));
end

%%% Expected value estimators
% Creates random variable barX (average of numTrials of X)
function [barX] = randomVarBarX(theta)
    barX = sum(randomVarX(theta), 'all') ./ numel(randomVarX(theta));
end
% Creates random variable barZ (average of numTrials of Z)
function [barZ] = randomVarBarZ(theta, a)
    barZ = sum(randomVarZ(theta, a), 'all') ./ numel(randomVarZ(theta, a));
end
% Creates random variable barZZ (average of numTrials of ZZ)
function [barZZ] = randomVarBarZZ(theta, a)
    barZZ = sum(randomVarZZ(theta, a), 'all') ./ numel(randomVarZ(theta, a));
end

%%% Coefficent estimators
% Estimates the best possible value of ccAlpaa for Z
function [optimize] = optimize(theta, min, max)
    possibleVals = linspace(min, max, 9999);
    idxMin = 1;
    minSteZ = 100;
    for i = 1:numel(possibleVals)
        steZTemp = std(randomVarZ(theta, possibleVals(i))) / sqrt(numel(randomVarZ(theta, possibleVals(i))));
        if (steZTemp < minSteZ)
            minSteZ = steZTemp;
            idxMin = i;
        end
    end
    optimize = possibleVals(idxMin);
end