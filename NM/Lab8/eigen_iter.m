clear all
clc

A = [-7	-5	2
     -5 0   15
     2  15  -7]

k = 30;

if symmetric(A)
    [l, x] = symposeval(A, k)
end


function bool = symmetric(M)
    bool = isequal(M, M.');
end

function [l, x] = symposeval(A, k)
    n = size(A, 1);
    x = ones(n, 1);
    for K = 1:k %which iteration
        l = 0;
        for j=1:n % which value from vector x(novec)
            l= l + A(n, j)*x(j, 1);
        end      
        copyx = x;
        for i = 1:n
            x(i, 1) = 0;
            for j = 1:n
                x(i, 1) = x(i, 1) + copyx(j, 1) * A(i, j);
            end
                x(i, 1) = x(i, 1)/l(1, 1);
        end            
    end
end
