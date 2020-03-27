clear all
clc

a = -10;
b = 10;
n = 6;
z = 3;

pts = a:((b-a)/100):b;
    
figure;
subplot(2,4,1) % equidistant monomial approximation
hold on
title('Monomial eqDist:')
plot(pts, arrayfun(@(x) f(x), pts))
vals = pts;
for i = 1:length(pts)
   [~, vals(i)] = eqDistMonomial(a, b, n, pts(i));
end
plot(pts, vals)
hold off
subplot(2,4,5) % equidistant monomial approximation error
hold on
title('Monomial eqDist E:')
for i = 1:length(pts)
   vals(i) = abs(vals(i)-f(pts(i)));
end
plot(pts, vals)
hold off

subplot(2,4,2) % chebyshev monomial approximation
hold on
title('Monomial Cheb:')
plot(pts, arrayfun(@(x) f(x), pts))
vals = pts;
for i = 1:length(pts)
   [~, vals(i)] = ChebyshevMonomial(a, b, n, pts(i));
end
plot(pts, vals)
hold off
subplot(2,4,6) % chebyshev monomial approximation error
hold on
title('Monomial Cheb E:')
for i = 1:length(pts)
   vals(i) = abs(vals(i)-f(pts(i)));
end
plot(pts, vals)
hold off

subplot(2,4,3) % equidistant lagrange approximation
hold on
title('Lagrange eqDist:')
plot(pts, arrayfun(@(x) f(x), pts))
vals = pts;
for i = 1:length(pts)
   [~, vals(i)] = eqDistLagrange(a, b, n, pts(i));
end
plot(pts, vals)
hold off
subplot(2,4,7) % equidistant lagrange approximation error
hold on
title('Lagrange eqDist E:')
for i = 1:length(pts)
   vals(i) = abs(vals(i)-f(pts(i)));
end
plot(pts, vals)
hold off

subplot(2,4,4) % chebyshev lagrange approximation
hold on
title('Lagrange Cheb:')
plot(pts, arrayfun(@(x) f(x), pts))
vals = pts;
for i = 1:length(pts)
   [~, vals(i)] = ChebyshevLagrange(a, b, n, pts(i));
end
plot(pts, vals)
hold off
subplot(2,4,8) % chebyshev lagrange approximation error
hold on
title('Lagrange Cheb E:')
for i = 1:length(pts)
   vals(i) = abs(vals(i)-f(pts(i))); 
end
plot(pts, vals)
hold off



function y = f(x)
    y = abs(x);
end

function [Xs, Wn] = eqDistLagrange(a, b, n, zeta)
    Xs = eqDistNodes(a, b, n);    % get nodes
    Ys = arrayfun(@(x) f(x), Xs); % get values at nodes
    Wn = sum(arrayfun(@(i) lagrPolyn(i, zeta, Xs)*Ys(i+1), 0:n)); % value of interpolation at zeta
end

function [Xs, Wn] = ChebyshevLagrange(a, b, n, zeta)
    Xs = ChebyshevNodes(a, b, n); % get nodes
    Ys = arrayfun(@(x) f(x), Xs); % get values at nodes
    Wn = sum(arrayfun(@(i) lagrPolyn(i, zeta, Xs)*Ys(i+1), 0:n)); % value of interpolation at zeta
end

function Pin = lagrPolyn(i, x, Xs)
    if i > length(Xs)
       error('i must be inside nodes interval')
    end
    Pin = 1;
    for it = [0:(i-1), (i+1):(length(Xs)-1)]
        Pin = Pin * (x-Xs(it+1)) / (Xs(i+1)-Xs(it+1));
    end
end

function [Xs, Wn] = eqDistMonomial(a, b, n, zeta)
    Xs = eqDistNodes(a, b, n);    % get nodes
    Ys = arrayfun(@(x) f(x), Xs); % get values at nodes
    A = vander(Xs);               % create vandermonde matrix
    coeffs = linsolve(A, Ys');    % solve A*coeffs = Ys
    Wn = polyval(coeffs, zeta);   % value of interpolation at zeta
end
function [Xs, Wn] = ChebyshevMonomial(a, b, n, zeta)
    Xs = ChebyshevNodes(a, b, n); % get nodes
    Ys = arrayfun(@(x) f(x), Xs); % get values at nodes
    A = vander(Xs);               % create vandermonde matrix
    coeffs = linsolve(A, Ys');    % solve A*coeffs = Ys
    Wn = polyval(coeffs, zeta);   % value of interpolation at zeta
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
