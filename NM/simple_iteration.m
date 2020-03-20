clear all
clc

A = [1 3 2
     2 7 7
     2 5 2];

b = [2
     -1
     7];

X = IterSolve(A, b)

function X = IterSolve(A, b)
    h = size(A, 1);
    w = size(A, 2);
    if w ~= h
       error('A is not square?')
    end
    if h ~= length(b)
       error('Length of b isnt equal to height of A')
    end
    TempAug = [A,b];
    if rank(A) < h
       error('Infinitely many solutions')
    end
    if rank(A) < rank(TempAug)
      error('Inconsistent matrix')
    end
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
    X = g;
    disp(g)
    disp(H)
    if norm(H) > 1
        error('No U');
    end
    for it = 1:10
        X = g + H * X;
    end
    return;
end
