clear all
clc

x = 5;

s = notorious_BIG(x, 10, 5)


function sumtingwong = notorious_BIG(x, N, alpha)
    [nodes, dt] = eqDistNodes(0, x, N) 
    sumtingwong = 0;
    for n = 1:N
        for i = 1:N
            sum = 0;
            
        end
    end
end


function ry = y(t)
    ry = sqrt(t);
end

function rf = f(x)
    rf = x^2+1;
end

function rk = k(v)
    rk = v;
end


% Separate interval into n pieces, return their borders and width
function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    for i = 0:n
        nodes(i+1) = a + (b-a)*i/n;
    end
    dist = (b-a)/n;
end
