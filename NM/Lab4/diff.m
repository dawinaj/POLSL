clear all
clc
n = 2
x = 0
h = 0.01


a=0;
b=10;
pts = a:((b-a)/100):b;
hold on
axis equal
ys = arrayfun(@(x) f(x), pts);
plot(pts, ys);
ys = arrayfun(@(x) forwdiff1(n, h, x), pts);
plot(pts, ys);
ys = arrayfun(@(x) forwdiff2(n, h, x), pts);
plot(pts, ys);
hold off


d = forwdiff2(n, h, x)



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

function [dydx, n] = variateN(n, h, z, acc)
    while true
        mtrx = zeros(n+2, n+2);
        for i = 0:(n+1)
            mtrx(1+i, 1) = f(z+i*h);
        end
        for x = 1:(n+1)
            for i = 0:(n+1-x)
                mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
            end
        end
        suma = 0;
        for i = 2:(n+1)
            suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
        end
        dydx = 1/h*suma;
        
        err = mtrx(1, n+2) / h / factorial(n)
        if abs(err) < acc
            break;
        end
        n = n+1;
    end
end

function [dydx, h] = variateH(n, h, z, acc)
    while true
        mtrx = zeros(n+2, n+2);
        for i = 0:(n+1)
            mtrx(1+i, 1) = f(z+i*h);
        end
        for x = 1:(n+1)
            for i = 0:(n+1-x)
                mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
            end
        end
        suma = 0;
        for i = 2:(n+1)
            suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
        end
        dydx = 1/h*suma;
        
        err = mtrx(1, n+2) / h / factorial(n)
        if abs(err) < acc
            break;
        end
        h = h/10
    end
end

function dydx = forwdiff1(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n
        mtrx(1+i, 1) = f(z+i*h);
    end
    for x = 1:n
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
        end
    end
    
    suma = 0;
    for i = 2:(n+1)
        suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
    end
    dydx = 1/h*suma;
    
end

function dydx = forwdiff2(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n
        mtrx(1+i, 1) = f(z+i*h);
    end
    for x = 1:n
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
        end
    end
    
    suma = 0;
    for i = 3:(n+1)
        suma = suma + coefficients(i)*(-1)^(i)*mtrx(1,i);
    end
    dydx=1/h^2*suma;
end

function coeffs = coefficients(n)
    mtrx = zeros(2*(n-1), 2);
    mtrx(1,1) = 1;
    mtrx(2*(n-1),1) = 1;
    for i=2:(n-1)
        mtrx(n-1-(i-2), 1) = 1/i*(-1)^(i+1);
        mtrx(n+(i-2), 1)   = 1/i*(-1)^(i+1);
    end
    for i = 1:(n-1)
        mtrx(i,2)= mtrx(2*(i-1)+1,1)*mtrx(2*(i-1)+2,1);
    end
    coeffs = 0;
    for i=1:n
        coeffs = coeffs + mtrx(i,2);
    end
end
