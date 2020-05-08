clear all
clc

e = 0.0001;

Wa = [1 13  16  -228    -432];

roots = Bern_mult(Wa, e)


function roots = Bern_mult(Wa, e)
    n = 1;
    while length(Wa) > 1 % as long as the polynomial is not just a free element
        roots(n) = Bern_modified(Wa, e) % find root using Bernoulli
        Wa = deconv(Wa, [1, -roots(n)]) % divide polynomial by (x - root)
        n = n + 1;
    end
end

function xi = Bern_modified(Wa, e)
    n = length(Wa)-1;
    if n == 1 % special case for linear functions, because they break the main function
        xi = -Wa(2)/Wa(1);
    else
        y = zeros(1, n); % create starting vector
        y(1) = 1;
        while 1 % following code is the same as in Bernoulli function
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
        end
    end
end
