clear all
clc

e = 0.01;

Wa = [1 13  16  -228    -432];

roots = Bernoulli(Wa, e)


function [xi, m, xik] = Bernoulli(Wa, y0, e)
    n = length(y0);
    m = 0;
    xik = 0;
    xi = 0;
    while 1
        tempy = 0;
        for i = 1:n
            tempy = tempy + Wa(i+1) * y(i);
        end
        tempy = - tempy/Wa(1);
        for i = n:-1:2
            y(i) = y(i-1);
        end
        y(1) = tempy;
        xi = y(1)/y(2);
        if abs(polyval(Wa, xi)) < e
            break;
        end
        m = m + 1;
    end
end
