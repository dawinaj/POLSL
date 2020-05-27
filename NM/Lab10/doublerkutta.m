clear all
clc
e = 10;   % Upper boundaryof 0 <= x <= e
c = 8; % the initial value of y => y(x0) = y0 = c
d = 11; % the initial value of y' => y'(x0) = y'0 = d

%[Xs, Ys, Fxys, Dys] = Euler(0, e, d, h);



hold on
[Xs, Ys, Zs, K, Dys] = Second_order_Runge_Kutta(0, e, c, d, 1);
plot(Xs, Ys)
[Xs, Ys, Zs, K, Dys] = Second_order_Runge_Kutta(0, e, c, d, .1);
plot(Xs, Ys)
[Xs, Ys, Zs, K, Dys] = Second_order_Runge_Kutta(0, e, c, d, .01);
plot(Xs, Ys)
hold off

%Given function
function fxy = f(x, y)
    %Parameters for our function fxy
    a = 2;
    b = 30;
    fxy = b*cos(x) -a*y;
    
end

function [Xs, Ys, Zs, K, Dys] = Second_order_Runge_Kutta(a, b, y0, y10, h)
    Xs  = (a:h:b).';
    Zs  = zeros(length(Xs), 4);
    K   = zeros(length(Xs), 4);
    Dzs = zeros(length(Xs), 1);
    
    %Finding solutions for Z
    Zs(1,1) = y10;
    K(1,1) = h* f(Xs(1, 1),Zs(1,1));
    Zs(1,2) = Zs(1,1) + +K(1, 1)/2;
    K(1,2) = h*( f(Xs(1, 1)+h/2, Zs(1,2)) );
    Zs(1,3) = Zs(1,1) + +K(1, 2)/2;
    K(1,3) = h*(f(Xs(1, 1)+h/2, Zs(1,3))); 
    Zs(1,4) = Zs(1,1) + +K(1, 3);
    K(1,4) = h*(f(Xs(1, 1)+h,   Zs(1,4)));
    Dzs(1) = (K(1, 1)+2*K(1, 2)+2*K(1, 3) +K(1, 4))/6;

    %Loop for finding solutions for first order z solutions.
    for j =2: length(Xs)
        Zs(j,1) = Zs(j-1,1)+ Dzs(j-1);
        K(j,1) = h* f(Xs(j),Zs(j,1));

        Zs(j,2) = Zs(j,1) + +K(j, 1)/2;
        K(j,2) = h*( f(Xs(j)+h/2, Zs(1,2)) );

        Zs(j,3) = Zs(j,1) + +K(j, 2)/2;
        K(j,3) = h*(f(Xs(j)+h/2, Zs(1,3))); 

        Zs(j,4) = Zs(j,1) + +K(j, 3);
        K(j,4) = h*(f(Xs(j)+h,   Zs(1,4)));

        Dzs(j) = (K(1, 1)+2*K(1, 2)+2*K(1, 3) +K(1, 4))/6;
    end
    
    K   = zeros(length(Xs), 4); %Reseting K
    Ys  = zeros(length(Xs), 1);
    Dys = zeros(length(Xs), 1);
    
    %Function, using calculated values of z, in order to find values of y
    Ys(1,1) = y0;
    K(1,1) = h*Zs(1,1);
    K(1,2) = h*Zs(1,2);
    K(1,3) = h*Zs(1,3);
    K(1,4) = h*Zs(1,4);
    Dys(1) = (K(1, 1)+2*K(1, 2)+2*K(1, 3) +K(1, 4))/6;
    
    for j =2: length(Xs)
       Ys(j) = Ys(j-1)+ Dys(j-1);
       K(j,1) = h*Zs(j,1);
       K(j,2) = h*Zs(j,2);
       K(j,3) = h*Zs(j,3);
       K(j,4) = h*Zs(j,4);
       Dys(j) = (K(j-1, 1)+2*K(j-1, 2)+2*K(j-1, 3) + K(j-1, 4))/6;
    end
    
end
