clear all
clc

e = 0.00001;

Wa = [1 13  16  -228    -432];

roots = Bern_mult(Wa, e)


function roots = Bern_mult(Wa, e)
    n = 1;
    while length(Wa) > 1
        [roots(n), ~, ~] = Bernoulli(Wa, e)
        Wa = deconv(Wa, [1, -roots(n)])
        n = n + 1;
    end
end

function [xi, m, xik] = Bernoulli(Wa, e)
    n = length(Wa)-1;
    m = 0;
    xik = 0;
    if n == 1
        xi = -Wa(2)/Wa(1);
    else
        y = zeros(1, n);
        y(1) = 1;
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
end
