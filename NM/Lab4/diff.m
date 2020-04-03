clear all
clc
n = 1
x = 0
h = 0.01

%{
a=0;
b=10;
pts = a:((b-a)/100):b;
hold on
axis equal
ys = arrayfun(@(x) f(x), pts);
plot(pts, ys);
ys = arrayfun(@(x) forwdiff1(n, h, x), pts);
plot(pts, ys);
%ys = arrayfun(@(x) Reversediff1(n, h, x), pts);
%plot(pts, ys);
ys = arrayfun(@(x) forwdiff2(n, h, x), pts);
plot(pts, ys);
%ys = arrayfun(@(x) Reversediff2(n, h, x), pts);
%plot(pts, ys);
hold off
%}

d = forwdiff1(n, h, x)

[d, h] = variateH(n, h, x, 0.00000001)


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
function dydx =  revdiff1(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n
        mtrx(i+1, 1) = f(z-i*h);
    end
    for x = 1:n
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+1, x)-mtrx(i+2, x));
        end
    end
    
    suma = 0;
    for i = 2:(n+1)
        suma = suma + 1/(i-1)*mtrx(1,i);
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
        suma = suma + (12-i+3)/12*(-1)^(i-1)*mtrx(1,i);
    end
    dydx=1/h^2*suma;
end
function dydx =  revdiff2(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n
        mtrx(i+1, 1) = f(z-i*h);
    end
    for x = 1:n
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+1, x)-mtrx(i+2, x));
        end
    end
    
    suma = 0;
    for i = 3:(n+1)
        suma = suma + (12-i+3)/12*mtrx(1,i);
    end
    dydx =1/h^2*suma;
end
