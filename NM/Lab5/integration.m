clear all
clc

a = 0;
b = pi;
n = 1000;

pts = eqDistNodes(a, b, n);
fs = arrayfun(@(x) Sf(x)-Sf(pts(1)), pts);
is = zeros(length(pts), 1);

%{
area = simpson_splitted(a, b, n)

is = zeros(length(pts), 1);
for i = 1:length(pts)
    is(i) = simpson_integr(a, pts(i));
end
Min = min(is)
Max = max(is)
%}


figure(1)
subplot(2, 6, 1)
hold on
axis equal
title('MiddlePoint')
for i = 1:length(pts)
    is(i) = middlept_integr(a, pts(i));
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 7)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('MiddlePoint err')
plot(pts, is)
hold off

subplot(2, 6, 2)
hold on
axis equal
title('Trapezoid')
for i = 1:length(pts)
    is(i) = trapezoid_integr(a, pts(i));
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 8)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('Trapezoid err')
plot(pts, is)
hold off

subplot(2, 6, 3)
hold on
axis equal
title('Simpson')
for i = 1:length(pts)
    is(i) = simpson_integr(a, pts(i));
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 9)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('Simpson err')
plot(pts, is)
hold off


subplot(2, 6, 4)
hold on
axis equal
title('Comp MiddlePoint')
for i = 1:length(pts)
    is(i) = middlept_splitted(a, pts(i), i);
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 10)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('Comp MP err')
plot(pts, is)
hold off

subplot(2, 6, 5)
hold on
axis equal
title('Comp Trapezoid')
for i = 1:length(pts)
    is(i) = trapezoid_splitted(a, pts(i), i);
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 11)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('Comp Trapezoid err')
plot(pts, is)
hold off

subplot(2, 6, 6)
hold on
axis equal
title('Comp Simpson')
for i = 1:length(pts)
    is(i) = simpson_splitted(a, pts(i), i);
end
plot(pts, fs)
plot(pts, is)
legend('Sf(x)', 'Num int')
fprintf("Area = %f\n", is(length(pts)))
hold off
subplot(2, 6, 12)
for i = 1:length(pts)
    is(i) = abs(Sf(pts(i)) - Sf(pts(1)) - is(i));
end
hold on
title('Comp Simpson err')
plot(pts, is)
hold off





function y = f(x)
    y = sin(x);
end

function Sf = Sf(x)
    Sf = -cos(x);
end

% 5.4 Composite quadrature formulae

function area = middlept_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + middlept_integr(pts(i), pts(i+1));
    end
end

% 5.4.1 Composite Trapezoid formula
function area = trapezoid_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + trapezoid_integr(pts(i), pts(i+1));
    end
end

% 5.4.2 Composite Simpson formula
function area = simpson_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + simpson_integr(pts(i), pts(i+1));
    end
end


% 5.2 Newton-Cotes method
function area = middlept_integr(a, b)
    area = f((a + b) / 2) * (b - a);
end

% 5.2.1 Trapezoid formula
function area = trapezoid_integr(a, b)
    area = (f(a) + f(b)) * (b - a) / 2;
end

% 5.2.2 Simpson formula
function area = simpson_integr(a, b)
    area = (f(a) + 4*f((a+b)/2) + f(b)) * (b - a) / 6;
end


% Separate interval into n pieces, return their borders and width
function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    for i = 0:n
        nodes(i+1) = a + (b-a)*i/n;
    end
    dist = (b-a)/n;
end
