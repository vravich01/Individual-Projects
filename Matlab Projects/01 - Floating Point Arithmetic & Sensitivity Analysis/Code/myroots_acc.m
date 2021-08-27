% This function is provided by Dr. Eric Hallman, from NCSU MA Department

function [x_1,x_2] = myroots_acc(a,b,c)
format long
if b < 0
    sign_b = -1;
else
    sign_b = 1;
end
x_1 = ((-b - sign_b * (sqrt(b.^2 - 4.*a.*c)))/(2.*a));
x_2 = (c/(a * x_1));
end
