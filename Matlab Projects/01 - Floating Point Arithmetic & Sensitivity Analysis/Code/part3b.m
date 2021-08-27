%% Interval values [lo, hi]
lo = -5;
hi = 5;

%% Choose the function you want: 
% for f_1(x): 
% flo = f1(lo);     or however you named your function
% fhi = f1(hi);     or however you named your function

% for f_2(x):
flo = f2(lo);       % or however you named your function
fhi = f2(hi);       % or however you named your function

%% bisection code:
if sign(flo)*sign(fhi) > 0
    error('Function has the same sign at the inputs!');
end
if flo == 0, x = lo; return, end
if fhi == 0, x = hi; return, end

x = (lo + hi)/2;
while x > lo && x < hi
    fx = f(x);
    if fx == 0, return, end
    
    if sign(flo)*sign(fx) > 0
        lo = x;
    else
        hi = x;
    end
    x = (lo + hi)/2;
end