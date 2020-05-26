clear all
clc
e = 9;   % Upper boundaryof 0 <= x <= e
h = 0.2; % step of our calculations
d = 1.9; % the initial value of y => y(x0) = y0 = d


hold on
[Xs, Ys, Fxys, Dys] = Runge_Kutta(0, e, d, 1)
plot(Xs, Ys)
[Xs, Ys, Fxys, Dys] = Runge_Kutta(0, e, d, .1)
plot(Xs, Ys)
[Xs, Ys, Fxys, Dys] = Runge_Kutta(0, e, d, .01)
plot(Xs, Ys)
hold off

%Given function
function fxy = f(x, y)
    %Parameters for our function fxy
    a = -5.8;
    b = 4.7;
    c = -0.9;
    fxy = a * y + b * x + c * x * x; % formula

end


function [Xs, Ys, K, Dys] = Runge_Kutta(a, b, y0, h) 
    %Initialisation of values
    Xs  = (a:h:b).';
    Ys  = zeros(length(Xs), 1);
    K   = zeros(length(Xs), 4);
    Dys = zeros(length(Xs), 1);
    
    Ys(1) = y0;
    K(1) = h* f(Xs(1, 1),     Ys(1));
    K(2) = h*(f(Xs(1, 1)+h/2, Ys(1)+K(1, 1)/2));
    K(3) = h*(f(Xs(1, 1)+h/2, Ys(1)+K(1, 2)/2)); 
    K(4) = h*(f(Xs(1, 1)+h,   Ys(1)+K(1, 3)));
    Dys(1) = (K(1, 1)+2*K(1, 2)+2*K(1, 3) + K(1, 4))/6;
    
    %Main loop
    for j =2: length(Xs)
        Ys(j) = Ys(j-1)+ Dys(j-1);
        K(j-1, 1) = h*f(Xs(j), Ys(j));
        K(j-1, 2) = h*(f(Xs(j)+h/2, Ys(j)+K(j-1, 1)/2));
        K(j-1, 3) = h*(f(Xs(j)+h/2, Ys(j)+K(j-1, 2)/2)); 
        K(j-1, 4) = h*(f(Xs(j)+h,   Ys(j)+K(j-1, 3)));
        Dys(j) = (K(j-1, 1)+2*K(j-1, 2)+2*K(j-1, 3) + K(j-1, 4))/6;
    end
    
   
end
