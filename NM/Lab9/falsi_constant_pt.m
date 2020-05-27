clear all
clc

a = -10;
b = 1;
e = 0.001;

[x, n, c] = regula_falsi(a, b, e)

function y = f(x)
    y = x^4 - 625;
end

function dy = df(x)
    dy = 4 * x^3;
end

function ddy = ddf(x)
    ddy = 12 * x^2;
end

function [x, n, c] =  regula_falsi(a, b, e)
    n = 1;
    if f(a)*ddf(a) > 0 % check which border point should be assumed as constant
        c = a;
        tempx = b;
    else
        c = b;
        tempx = a;
    end
    x = tempx - f(tempx)/(f(c) - f(tempx)) * (c - tempx); % 1st iteration
    while abs(x - tempx) > e % repeat as long as desired accuracy is not satisfied
        n = n + 1;
        tempx = x;
        x = tempx - f(tempx)/(f(c) - f(tempx)) * (c-tempx); % nth iterations
    end
end

