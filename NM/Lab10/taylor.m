clear all
clc
a = -5.8;
    b = 4.7;
    c = -0.9;
e = 9;   % Upper boundaryof 0 <= x <= e
h = 0.1; % step of our calculations
d = 1.9; % the initial value of y => y(x0) = y0 = d

%[Xs, Ys, Fxys, Dys] = Euler(0, e, d, h);

[Xs, Ys] = Taylor_series(0, a, b, c, d, e, h) 

hold on
plot(Xs, Ys)
hold off


function [Xs, Ys] = Taylor_series(x0,a,b,c,d,e,h)
    Xs = x0:h:e;
    y0 = d;
    Ys  = zeros(1, length(Xs));
    y10 = a*y0 + b + 2*c*x0;
    y20 = a*y10 + 2*c;
    
    for i = 2:length(Xs)
        Ys(i) = y0 + y10*Xs(i) + y20*Xs(i).^2/2;
    end
end
