clear all
clc

A = [1 3 2
     2 7 7
     2 5 2];

b = [2
     -1
     7];

[A, b, x] = GaussElim(A, b)


function [rA, rb, X] = GaussElim(A, b)
    h = size(A, 1);
    w = size(A, 2);
    if w ~= h
        error('A is not square?')
    end
    if h ~= length(b)
        error('Length of b isnt equal to height of A')
    end
    Xpos = (1:w)';
    Xtmp = zeros(w, 1);
    X = Xtmp;
    for p = 1:(h-1)
%        disp(A)
%        disp(Xpos)
%        disp(b)
        [maxY, maxX] = maxelem(abs(A), p, h, p, w);
        %swap row
        if maxY ~= p
            temp = A(p, :);
            A(p, :) = A(maxY, :);
            A(maxY, :) = temp;
            temp = b(p);
            b(p) = b(maxY);
            b(maxY) = temp;
        end
        %swap col
        if maxX ~= p
            temp = A(:, p);
            A(:, p) = A(:, maxX);
            A(:, maxX) = temp;
            temp = Xpos(p);
            Xpos(p) = Xpos(maxX);
            Xpos(maxX) = temp;
        end
%        disp(A)
%        disp(Xpos)
%        disp(b)
        for y = (p+1):h
            ratio = A(y, p)/A(p, p);
            for x = p:w
                A(y, x) = A(y, x) -ratio*A(p, x);
            end
            b(y) = b(y) - ratio*b(p);
        end
%        fprintf('======================================================\n');
    end
    for p = h:-1:1
        if A(p, p) == 0
            warning("Diagonal element is 0, system cannot be solved");
            break;
        end
        temp = b(p);
        for i = (p+1):w
            temp = temp - A(p, i)*Xtmp(i);
        end
        Xtmp(p) = temp/A(p, p);
    end
    for p = 1:h
        X(Xpos(p)) = Xtmp(p);
    end
    rA = A;
    rb = b;
end

function [ry, rx] = maxelem(Arr, miny, maxy, minx, maxx)
    ty = miny;
    tx = maxy;
    for y = miny:maxy
        for x = minx:maxx
            if Arr(y, x) > Arr(ty, tx)
                ty = y;
                tx = x;
            end
        end
    end
    ry = ty;
    rx = tx;
end
