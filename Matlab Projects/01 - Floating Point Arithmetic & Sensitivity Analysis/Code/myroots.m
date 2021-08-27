function [X_1, X_2] = myroots(a,b,c)
format long
X_1 = (-b + (sqrt(b.^2 - 4.*a.*c)))/(2.*a);
X_2 = (-b - (sqrt(b.^2 - 4.*a.*c)))/(2.*a);
end

