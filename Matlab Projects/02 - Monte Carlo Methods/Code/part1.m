hold on
format long

%%% Initial set up
% # Trials
numTrials = 500;
% Control constant
ccAlpha = -0.4;

%%% Graphing
% Values of theta to draw curves
thetaVals = linspace(0, 2*pi, 9999);
% Draws heart H, Area(H) ~=~ 12.5230317 and draws circle C, Area(C) ~=~ 12.5663706 
heartLine = line(xCoord(thetaVals, heartRadius(thetaVals)), yCoord(thetaVals, heartRadius(thetaVals)), 'Color', 'r');
heartLine.LineWidth = 2;
circleLine = line(xCoord(thetaVals, limaconRadius(thetaVals)), yCoord(thetaVals, limaconRadius(thetaVals)), 'Color', 'b');
circleLine.LineWidth = 2;
% Randomly generates and scatters points
xVals = (5 * rand(numTrials, 1) - 2.5)';
yVals = (5 * rand(numTrials, 1) - 4)';
%randomPointsScatter = scatter(xVals, yVals, 'k', 'x');
% Graphing preferences
xlim([-2.5, 2.5]);
ylim([-4, 1]);
xlabel('\fontsize{12.5}x');
ylabel('\fontsize{12.5}y');
%title({'\fontsize{15}Heart H & Control Variate Circle C';sprintf('%d Randomly Generated Points', numTrials)});
title({'\fontsize{15}Heart H &';'Control Variate Cardioid C2'});

%%% Important values (X)
% Estimate of E[X], average value of X over numTrials
estimateEX = randomVarBarX(xVals, yVals);
% Estimate of Std[X], using values of X over numTrials
stdX = std(randomVarX(xVals, yVals));
% Standard Error of X, using values of X over numtrials
steX = stdX ./ sqrt(numTrials);
% 99.7% confidence interval for E[X]
confIntX = [estimateEX - 3 .* steX, estimateEX + 3 .* steX];

%%% Important values (Z)
% Estimate of E[Z], average value of Z over numTrials
estimateEZ = randomVarBarZ(xVals, yVals, ccAlpha);
% Estimate of Std[Z], using values of Z over numTrials
stdZ = std(randomVarZ(xVals, yVals, ccAlpha));
% Standard Error of Z, using values of Z over numtrials
steZ = stdZ ./ sqrt(numTrials);
% 99.7% confidence interval for E[Z]
confIntZ = [estimateEZ - 3 .* steZ, estimateEZ + 3 .* steZ];

%%% Polar curves
% H function
function [heartRadius] = heartRadius(theta)
    heartRadius = 2 - 2 .* sin(theta) + (sin(theta) .* sqrt(abs(cos(theta)))) ./ (sin(theta) + 1.4);
end
% H function
function [circleRadius] = circleRadius(theta)
    circleRadius = sqrt(4 - cos(theta) .^ 2) - sin(theta);
end
% L[imacon] function
function [limaconRadius] = limaconRadius(theta)
    limaconRadius = 2 .* sqrt(1 - sin(theta));
end

%%% Indicator functions
% Determines if x,y is in H
function [inHeart] = inHeart(x, y)
    xyTheta = theta(x, y);
    xyRadius = radius(x, y);
    actualRadius = heartRadius(xyTheta);    
    inHeart = xyTheta; % Only for sizing!!!
    for i = 1:numel(inHeart)
        if (xyRadius(i) <= actualRadius(i))
            inHeart(i) = true;
        else
            inHeart(i) = false;
        end
    end
end
% Determines if x,y is in C
function [inCircle] = inCircle(x, y)
    xyTheta = theta(x, y);
    xyRadius = radius(x, y);
    actualRadius = circleRadius(xyTheta);
    inCircle = xyTheta; % Only for sizing!!!
    for i = 1:numel(inCircle)
        if (xyRadius(i) <= actualRadius(i))
            inCircle(i) = true;
        else
            inCircle(i) = false;
        end
    end
end

%%% Random variables
% Creates random variable X from {0,25} depending on whether x,y is in H
function [X] = randomVarX(x, y)
    withinHeartTracker = inHeart(x, y);
    X = theta(x,y); % Only for sizing!!!
    for i = 1:numel(X)
        if (withinHeartTracker(i))
           X(i) = 25;
        else
           X(i) = 0;
        end
    end
end
% Creates random variable Y from {0,25} depending on whether x,y is in C
function [Y] = randomVarY(x, y)
    withinCircleTracker = inCircle(x, y);
    Y = theta(x,y); % Only for sizing!!!
    for i = 1:numel(Y)
        if (withinCircleTracker(i))
           Y(i) = 25;
        else
           Y(i) = 0;
        end
    end
end
% Creates random variable Z = X + a(Y - E[Y])
function [Z] = randomVarZ(x, y, a)
    Z = randomVarX(x, y) + a .* (randomVarY(x, y) - (pi .* 2 .^ 2 ));
end

%%% Expected value estimators
% Creates random variable barX (average of numTrials of X)
function [barX] = randomVarBarX(x, y)
    barX = sum(randomVarX(x, y), 'all') ./ numel(randomVarX(x, y));
end
% Creates random variable barZ (average of numTrials of Z)
function [barZ] = randomVarBarZ(x, y, a)
    barZ = sum(randomVarZ(x, y, a), 'all') ./ numel(randomVarZ(x, y, a));
end

%%% Coordinate Conversions
% theta,r --> x
function [xCoord] = xCoord(theta, radius)
    xCoord = radius .* cos(theta);
end
% theta,r --> y
function [yCoord] = yCoord(theta, radius)
    yCoord = radius .* sin(theta);
end
% x,y --> theta
function [theta] = theta(x, y)
    theta = atan2(y, x);
end
% x,y --> r
function [radius] = radius(x, y)
    radius = sqrt(x.^2 + y.^2);
end