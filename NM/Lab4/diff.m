
n = 3
x = 2
[dydx1, dydx2] = diff(n, 1e-6, x) % 0 = f, 1 = f', 2 = f" etc
der = df(n, x)

function y = f(x)
    y = sin(x);
end

function ypr = df(n, x)
    n = mod(n, 4);
    switch n
        case 0
            ypr = sin(x);
        case 1
            ypr = cos(x);
        case 2
            ypr = -sin(x);
        case 3
            ypr = -cos(x);
    end
end

function [dydx1, dydx2] = diff(n, h, z)
    mtrx = zeros(n+1, n+1);
    for y = 0:n
        mtrx(y+1, 1) = f(z+y*h)
    end
    for x = 1:n
        for y = 0:(n-x)
            mtrx(y+1, x+1) = (mtrx(y+2, x)-mtrx(y+1, x))/(x*h);
        end
    end
    mtrx
    dydx1 = mtrx(1, n+1)*factorial(n)*power(h, n);
    
    dydx2 = 0;
    for i = n:-1:0
        fprintf("dydx = %f\n(-1)^(n-i) = %i\nnchoosek(n, i) = %i\nf(z+i*x) = %f", dydx2, (-1)^(n-i), nchoosek(n, i), f(z+i*x));
        dydx2 = dydx2 + (-1)^(n-i) * nchoosek(n, i) * f(z+i*h)% / power(h, n)
    end
    
end
