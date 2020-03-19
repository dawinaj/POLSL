clear all
clc

A = [1 3 2
     2 7 7
     2 5 2];

b = [2
     -1
     7];

[A, b, x] = GaussElimSolve(A, b)


function [rA, rb, X] = GaussElimSolve(A, b)
    %====={ sanity check }=====%
    h = size(A, 1);
    w = size(A, 2);
    if w ~= h
        error('A is not square?')
    end
    if h ~= length(b)
        error('Length of b isnt equal to height of A')
    end
    
    %====={ vectors }=====%
    Xpos = (1:w)';      %stores positions during pivoting
    Xtmp = zeros(w, 1); %stores values
    X = Xtmp;           %return values
    
    %====={ Gauss elimination }=====%
    for p = 1:(h-1)
        [maxY, maxX] = maxelem(abs(A), p, h, p, w); %find coords of max abs el in nonreduced part
        
        %====={ Swap pivot row }=====%
        if maxY ~= p
            temp = A(p, :);       % \
            A(p, :) = A(maxY, :); %  } swap rows in A
            A(maxY, :) = temp;    % /
            temp = b(p);    % \
            b(p) = b(maxY); %  } swap values in b
            b(maxY) = temp; % /
        end
        
        %====={ Swap pivot col }=====%
        if maxX ~= p
            temp = A(:, p);       % \
            A(:, p) = A(:, maxX); %  } swap cols in A
            A(:, maxX) = temp;    % /
            temp = Xpos(p);       % \
            Xpos(p) = Xpos(maxX); %  } swap order of vars
            Xpos(maxX) = temp;    % /
        end
        
        %====={ Actual eliminaton }=====%
        for y = (p+1):h
            ratio = A(y, p)/A(p, p); % find ratio of rows
            for x = p:w
                A(y, x) = A(y, x) - ratio*A(p, x); % subtract rows
            end
            b(y) = b(y) - ratio*b(p);
        end
    end
    
    %====={ Solve the system }=====%
    for p = h:-1:1
        if A(p, p) == 0 % cannot divide by 0
            warning("Diagonal element is 0, system cannot be solved");
            break;
        end
        temp = b(p); % store free element
        for i = (p+1):w 
            temp = temp - A(p, i)*Xtmp(i); % subtract all previously solved vars
        end
        Xtmp(p) = temp/A(p, p); % divide by var coeff
    end
    
    %====={ Assign in correct order }=====%
    for p = 1:h
        X(Xpos(p)) = Xtmp(p);
    end
    
    %====={ Return }=====%
    rA = A;
    rb = b;
end

%====={ Function for finding max element in matrix with given boundaries }=====%
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
