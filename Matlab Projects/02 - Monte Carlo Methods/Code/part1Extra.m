format long

%%% Initial set up
% # Trials
numTrials = 5000;
% Control constant
ccAlpha = 3 * rand - 1.5;

% Randomly generates points
xVals = (5 * rand(numTrials, 1) - 2.5)';
yVals = (5 * rand(numTrials, 1) - 4)';

%%% Important value (ccAlpha)
% Estimate of best value of control constant ccAlpha
ccAlphaBest = optimize(xVals, yVals, -1, 1);
% Standard Error of Z, using values of Z over numtrials, using ccAlphaBest
steZ = std(randomVarZ(xVals, yVals, ccAlpha)) ./ sqrt(numTrials);

  
  %%% Polar curves
% H function
function [heartRadius] = heartRadius(theta)
    heartRadius = 2 - 2 .* sin(theta) + (sin(theta) .* sqrt(abs(cos(theta)))) ./ (sin(theta) + 1.4);
end
% H function
function [circleRadius] = circleRadius(theta)
    circleRadius = sqrt(4 - cos(theta) .^ 2) - sin(theta);
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

%%% Estimators
% Estimates the best possible value of ccAlpaa for Z
function [optimize] = optimize(x, y, min, max)
    possibleVals = linspace(min, max, 9999);
    idxMin = 1;
    minSteZ = 100;
    for i = 1:numel(possibleVals)
        steZTemp = std(randomVarZ(x, y, possibleVals(i))) / sqrt(numel(randomVarZ(x, y, possibleVals(i))));
        if (steZTemp < minSteZ)
            minSteZ = steZTemp;
            idxMin = i;
        end
    end
    optimize = possibleVals(idxMin);
end

%%% Coordinate Conversions
% x,y --> theta
function [theta] = theta(x, y)
    theta = atan2(y, x);
end
% x,y --> r
function [radius] = radius(x, y)
    radius = sqrt(x.^2 + y.^2);
end