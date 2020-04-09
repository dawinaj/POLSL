clear all
clc

a = 0;
b = pi;
n = 1000;

pts = a:((b-a)/n):b;

area = middlept_integration(a, b, n)

ys = arrayfun(@(x) f(x), pts);
is = zeros(length(pts), 1);
for i = 1:length(pts)
    is(i) = middlept_integration(a, pts(i), i);
end
Min = min(is)
Max = max(is)
hold on
axis equal
plot(pts, ys)
plot(pts, is)
hold off

function y = f(x)
    y = sin(x);
end


function area = middlept_integration(a, b, n)
    if a == b
        area = 0;
    else
        if a > b
            t = a;
            a = b;
            b = t;
        end
        [pts, dist] = eqDistNodes(a, b, n);
        area = 0;
        for i = 1:(length(pts)-1)
           area = area + dist * f((pts(i)+pts(i+1))/2);
        end
    end
end


function area = trapezoid_integration(a, b, n)
    if a == b
        area = 0;
    else
        if a > b
            t = a;
            a = b;
            b = t;
        end
        [pts, dist] = eqDistNodes(a, b, n);
        area = 0;
        for i = 1:(length(pts)-1)
           area = area + dist * (f(pts(i)) + f(pts(i+1))) / 2;
        end
    end
end

function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    if a < b
        for i = 0:n
            nodes(i+1) = a + (b-a)*i/n;
        end
    else
        error('a must be smaller than b!')
    end
    dist = (b-a)/n;
end
