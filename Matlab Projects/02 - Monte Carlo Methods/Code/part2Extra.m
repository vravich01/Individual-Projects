hold on
format long

figure

%%% Initial set up
% Certain fixed values of theta, hand picked from (0, 2pi)
fixedTheta1 = pi ./ 3;
fixedTheta2 = 7 * pi ./ 8;
fixedTheta3 = 5 * pi ./ 4;
fixedTheta4 = 3 * pi ./ 2;
% Values of theta, generated linearly from [0, 2pi]
fixedThetaVals = linspace(0, 2*pi, 9999);

%%% Graphing
% Draws heart H, Area(H) ~=~ 12.5230317
heartLine = plot(xCoord(fixedThetaVals, heartRadius(fixedThetaVals)), yCoord(fixedThetaVals, heartRadius(fixedThetaVals)), 'r');
heartLine.LineWidth = 2;
% Draws approximating circles Ai, Area(Ai) = pi * heartRadius(thetaFixedi)
approxCircle1Line = line(xCoord(fixedThetaVals, heartRadius(fixedTheta1)), yCoord(fixedThetaVals, heartRadius(fixedTheta1)), 'Color', '#7E2F8E', 'LineStyle', '--');
approxCircle1Line.LineWidth = 2;
approxCircle2Line = line(xCoord(fixedThetaVals, heartRadius(fixedTheta2)), yCoord(fixedThetaVals, heartRadius(fixedTheta2)), 'Color', '#4DBEEE', 'LineStyle', '--');
approxCircle2Line.LineWidth = 2;
approxCircle3Line = line(xCoord(fixedThetaVals, heartRadius(fixedTheta3)), yCoord(fixedThetaVals, heartRadius(fixedTheta3)), 'Color', '#77AC30', 'LineStyle', '--');
approxCircle3Line.LineWidth = 2;
approxCircle4Line = line(xCoord(fixedThetaVals, heartRadius(fixedTheta4)), yCoord(fixedThetaVals, heartRadius(fixedTheta4)), 'Color', '#EDB120', 'LineStyle', '--');
approxCircle4Line.LineWidth = 2;
% Draws line segments for each approximating circle
approxCircle1Seg = line([0, xCoord(fixedTheta1, heartRadius(fixedTheta1))],[0, yCoord(fixedTheta1, heartRadius(fixedTheta1))], 'Color', '#7E2F8E', 'LineStyle', '--');
approxCircle1Seg.LineWidth = 1.25;
approxCircle2Seg = line([0, xCoord(fixedTheta2, heartRadius(fixedTheta2))],[0, yCoord(fixedTheta2, heartRadius(fixedTheta2))], 'Color', '#4DBEEE', 'LineStyle', '--');
approxCircle2Seg.LineWidth = 1.25;
approxCircle3Seg = line([0, xCoord(fixedTheta3, heartRadius(fixedTheta3))],[0, yCoord(fixedTheta3, heartRadius(fixedTheta3))], 'Color', '#77AC30', 'LineStyle', '--');
approxCircle3Seg.LineWidth = 1.25;
approxCircle4Seg = line([0, xCoord(fixedTheta4, heartRadius(fixedTheta4))],[0, yCoord(fixedTheta4, heartRadius(fixedTheta4))], 'Color', '#EDB120', 'LineStyle', '--');
approxCircle4Seg.LineWidth = 1.25;
% Graphing preferences
xlim([-4, 4]);
ylim([-4, 4]);
xlabel('\fontsize{12.5}x');
ylabel('\fontsize{12.5}y');
title({'\fontsize{15}Heart H &';'Approximating Circles for Selected Angles'});

%%% Polar curves
% H function
function [heartRadius] = heartRadius(theta)
    heartRadius = 2 - 2 .* sin(theta) + (sin(theta) .* sqrt(abs(cos(theta)))) ./ (sin(theta) + 1.4);
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