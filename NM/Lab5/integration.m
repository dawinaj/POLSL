clear all
clc

a = 0;
b = pi;
n = 1000;

pts = eqDistNodes(a, b, n);

area = boole_splitted(a, b, n)

is = zeros(length(pts), 1);
for i = 1:length(pts)
    is(i) = boole_splitted(a, pts(i), i);
end
Min = min(is)
Max = max(is)
hold on
axis equal
plot(pts, arrayfun(@(x) f(x), pts))
plot(pts, is)
hold off

function y = f(x)
    y = sin(x);
end


function area = middlept_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + middlept_integr(pts(i), pts(i+1));
    end
end

function area = middlept_integr(a, b)
    area = f((a + b) / 2) * (b - a);
end



function area = trapezoid_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + trapezoid_integr(pts(i), pts(i+1));
    end
end

function area = trapezoid_integr(a, b)
    area = (f(a) + f(b)) * (b - a) / 2;
end



function area = simpson_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + simpson_integr(pts(i), pts(i+1));
    end
end

function area = simpson_integr(a, b)
    area = (f(a) + 4*f((a+b)/2) + f(b)) * (b - a) / 6;
end



function area = boole_splitted(a, b, n)
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + boole_integr(pts(i), pts(i+1));
    end
end

function area = boole_integr(a, b)
    area = (7*f(a) + 32*f((3*a+b)/4) + 12*f((a+b)/2) + 32*f((a+3*b)/4) + 7*f(b)) * (b - a) / 90;
end




function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    for i = 0:n
        nodes(i+1) = a + (b-a)*i/n;
    end
    dist = (b-a)/n;
end
