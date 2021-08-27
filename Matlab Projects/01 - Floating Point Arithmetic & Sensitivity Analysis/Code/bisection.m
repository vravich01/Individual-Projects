% This function is provided by Dr. Eric Hallman, from NCSU MA Department

function x = bisection(f,lo,hi)
    % Uses the bisection method to find a
    %  zero of the function f in the interval [lo,hi].
    % To work properly, f(lo) and f(hi) must have opposite signs
    
    flo = f(lo); 
    fhi = f(hi); 
    if sign(flo)*sign(fhi) > 0
        %error('Function has the same sign at the inputs!'); 
        x = -0;
        return
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
    
end
