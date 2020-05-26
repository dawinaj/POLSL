clear all
clc

e = 9;
d = 1.9;



hold on
[Xs, Ys, Fxys, Dys] = diffeq(0, e, d, 1)
plot(Xs, Ys)
[Xs, Ys, Fxys, Dys] = diffeq(0, e, d, .1)
plot(Xs, Ys)
[Xs, Ys, Fxys, Dys] = diffeq(0, e, d, .01)
plot(Xs, Ys)
hold off


function fxy = f(x, y)
    a = -5.8;
    b = 4.7;
    c = -0.9;
    fxy = a * y + b * x + c * x * x;
end


function [Xs, Ys, Fxys, Dys] = diffeq(a, b, y0, h)
    Xs = a:h:b;
    Ys   = zeros(1, length(Xs));
    Fxys = zeros(1, length(Xs));
    Dys  = zeros(1, length(Xs));
    
    Ys(1) = y0;
    Fxys(1) = f(Xs(1), Ys(1));
    Dys(1) = h * Fxys(1);
    
    for i = 2:length(Xs)
        Ys(i)   = Ys(i-1)+Dys(i-1);
        Fxys(i) = f(Xs(i), Ys(i));
        Dys(i)  = h * Fxys(i);
    end
end
