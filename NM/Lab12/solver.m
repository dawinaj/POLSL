clear all
clc

x = 3;
alpha = 2;
N = 5;  % intervals
z = 10; % iterations

[x, y] = approximate(x, z, N, alpha)

hold on
plot(x, y)
plot(x, laplace(x))
hold off


function y = laplace(t)
    y = zeros(1, length(t));
    for i = 1:length(t)
        y(i) = exp(-t(i))/2 - t(i)*exp(-t(i))+exp(t(i))/2;
    end
end



function [x, ret] = approximate(x, z, N, alpha)
    [x, dt] = eqDistNodes(0, x, N) 
    y = ones((z+1), (N+1)) % subN,  Xi
    for n = 2:(z+1)
        for i = 2:(N+1)
            sum = 0;
            for j = 1:(i-1)
                % rectangle
                sum = sum + k(x(i)-x(j)) * y(n-1, j) * dt;
                % trapezoid
                %sum = sum + (k(x(i)-x(j)) * y(n-1, j) + k(x(i)-x(j+1)) * y(n-1, j+1))/2 * dt;
                
            end
            y(n, i) = alpha * sum + f(x(i));
        end
    end
    y
    ret = y((z+1), :);
end


function rf = f(x)
    rf = exp(-x);
end

function rk = k(v)
    rk = sin(v);
end


% Separate interval into n pieces, return their borders and width
function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    for i = 0:n
        nodes(i+1) = a + (b-a)*i/n;
    end
    dist = (b-a)/n;
end
