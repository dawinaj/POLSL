clear all
clc

A = [1 3 2
     2 7 7
     2 5 2];

b = [2
     -1
     7];

[A, b] = GaussElim(A, b)


function [rA, rb] = GaussElim(A, b)
    h = size(A, 1)
    w = size(A, 2)
    if h ~= length(b)
        error('Length of b isnt equal to height of A')
    end
    for p = 1:h
        disp(A)
        fprintf('p=%i\n', p);
        fprintf('P=%f\n', A(p,p));
        for y = (p+1):h
            ratio = A(y, p)/A(p, p);
            for x = p:w
                A(y, x) = A(y, x) -ratio*A(p, x);
            end
            b(y) = b(y) - ratio*b(p);
            fprintf('\n');
        end
    end
    rA = A;
    rb = b;
end

