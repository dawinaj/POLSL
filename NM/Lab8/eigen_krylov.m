clear all
clc
%{
A=[1 1 1
   1 2 3
   1 3 6];
%}
A =[-2  -4  2
    -2  1   2
    4   2   5]

y0 = [1 0 0];

%==============={ SOLVE }===============%
if size(A, 1) ~= size(A, 2)
    error("Gimme square matrix!");
end
dim = size(A, 1);

Y = zeros(dim, dim+1);
Y(:, dim) = y0;
[p, Y] = pcoeffs(A, Y);

[vects, vals] = eigenvectors(Y, p);
vals = transpose(vals)
vects = normalize(vects)

%Krylov Method
%1. Determining characteristic polynomial coefficients 

function [p, Y] = pcoeffs(A, Y)
    n = size(Y, 1);
    for i = 2:n
        Y(:, n+1-i) = A*Y(:, n+2-i);
    end
    Y(:, n+1) = -A*Y(:, 1);
    p = linsolve(Y(:, 1:n), Y(:, n+1));
end

%2. Calculating Eigenvectors
function [x, eval] = eigenvectors(Y, p)
    n = size(Y, 1);
    x = zeros(n, n);
    vec = ones(1, size(Y, 2));
    vec(1, 2:(n+1)) = p;
    eval = flip(roots(vec));
    for j = 1:n
        g = ones(1, n);
        for i = 1:(n-1)
            g(1, n-i) = eval(j)*g(1, n-i+1) + p(i)*g(1, n);
        end
        for i = 1:n
        x(:, j) = x(:, j) + Y(:, n+1-i)*g(1, i);
        end
    end
end

function x = normalize(x)
    for i = 1:size(x, 2)
        if max(x(:, i)) >= max(abs(x(:, i)))
             x(:, i) = x(:, i)/max(x(:, i));
        else
             x(:, i) = x(:, i)/min(x(:, i));
        end
    end
end
