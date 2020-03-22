clear all
clc

[Xi, Yi] = interpolate(0, 2*pi, 5, 2)

function [Xs, Ys] = interpolate(a, b, n, zeta)
    Xs = eqDistNodes(a, b, n);    % get nodes
    Ys = arrayfun(@(x) f(x), Xs); % get values at nodes
    A = vander(Xs)                % create vander-someone matrix
    coeffs = linsolve(A, Ys')     % solve A*coeffs = Ys
    pts = a:0.1:b;
    plot(pts, arrayfun(@(x) polyval(coeffs, x), pts))
    hold on
    plot(pts, arrayfun(@(x) f(x), pts))
    hold off
end

function y = f(x)
    y = cos(x);
end

function nodes = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    if a < b
        for i = 0:n
            nodes(i+1) = a + (b-a)*i/n;
        end
    else
        error('a must be smaller than b!')
    end
end

function nodes = ChebyshevNodes(a, b, n)
    nodes = zeros(1, n);
    if a < b
        for i = 0:n
            x = cos((2*i+1)/(2*n+2)*pi);
            nodes(i+1) = ((b-a)*x + a + b)/2;
        end
        nodes = flip(nodes);
    else
        error('a must be smaller than b!')
    end
end
