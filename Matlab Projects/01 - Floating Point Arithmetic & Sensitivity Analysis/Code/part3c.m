% Choose a value for N.
% Any integer greater than 649 will result in an error.
N = 649;

r = 2*ones(1,N);
p = poly(r); 
rts = roots(p)