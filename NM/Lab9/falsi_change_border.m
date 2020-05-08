clear all
clc

[x, d] = regulafalsi(-10, 1, 0.0000001)

function y = f(x) 
    y = x^4 - 625;
end

function [x, n] = regulafalsi(a, b, acc)
    n = 0;
    if sign(f(a)) ~= sign(f(b))
        while 1
            n = n+1;
            x = a - f(a)/(f(b)-f(a))*(b-a);
            if sign(f(x)) == sign(f(a))
                a = x;
            elseif sign(f(x)) == sign(f(b))
                b = x;
            end
            if abs(f(x)) < acc
                break;
            end
            if abs(b-a) < acc
                break;
            end
        end
    else
        error("The same signs!");
    end
end
