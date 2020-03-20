clear all
clc

A = [5,  1, -3
     2,  8,  2
    -2,  1,  7];

b = [-3
     5
    -10];

X = IterSolve(A, b, 1e-4, 20)

function X = IterSolve(A, b, eps, n)
    %====={ sanity check }=====%
    h = size(A, 1);
    w = size(A, 2);
    if w ~= h
       error('A is not square?')
    end
    if h ~= length(b)
       error('Length of b isnt equal to height of A')
    end
    if rank(A) < h
       error('Infinitely many solutions')
    end
    if rank(A) < rank([A,b])
      error('Inconsistent matrix')
    end
    
    %====={ create g and H }=====%
    H = zeros(h, w);
    g = zeros(h, 1);
    for y = 1:h
        g(y) = b(y)/A(y, y);
        for x = 1:w
            if y == x
                H(y, x) = 0;
            else
                H(y, x) = -A(y, x)/A(y, y);
            end
        end
    end
    
    %====={ final tests }=====%
    X = g;
    if norm(H) >= 1
        error('Norm >= 1, does not converge!');
    end
    
    %====={ iteration }=====%
    for it = 1:n
        Xtmp = X;
        X = g + H * X;
        if (norm(X - Xtmp) < eps)
            break;
        end
    end
    return;
end
