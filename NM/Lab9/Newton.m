clear all
clc

a = -10;
b = 1;
e = 0.001;

[x, n, c] = Newton(a, b, e)

function y = f(x) % function
    y = x^4 - 625;
end

function dy = df(x) % first der
    dy = 4 * x^3;
end

function ddy = ddf(x) % second der
    ddy = 12 * x^2;
end

function [x, n] = Newton(a, b, e)
    if f(a) * ddf(a) > 0 % choose beginning
        tempx = a;
    else
        tempx = b;
    end
    x = tempx - f(tempx)/df(tempx);  % 1st iteration
    n=1;
    while abs(x-tempx) > e % repeat until desired accuracy is reached
        tempx = x;
        x = tempx - f(tempx)/df(tempx); % nth iterations
        n = n + 1;
    end
end
