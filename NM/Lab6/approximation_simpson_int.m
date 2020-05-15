clear all
clc

a = 0;
b = 6;

pts = a:((b-a)/100):b;
[cs, sigma] = approximate(a, b, 10)
hold on
plot(pts, arrayfun(@(x) f(x), pts))
plot(pts, approximator(pts, cs, a, b))
hold off

function y = f(x)
	d = 5;
    y = sqrt(2/d) * sin(4*pi*x/d);
%    y = 5*abs(x-d/2);
end

function [c, sigma] = approximate(a, b, n)
    c = zeros(1, n);
    for i = 1:n
        c(i) = Ai(i, a, b);
    end
    sigma = Sigma(c, a, b);
end

function Qi = Qi(x, i, a, b)
    Qi = sqrt(2/(b-a)) * sin(i*pi*(x-a)/(b-a));
end

function Ai = Ai(i, a, b)
    Ai = simpson_splitted_modified(@(x)f(x).*Qi(x, i, a, b), a, b);
end

function Sigma = Sigma(As, a, b)
    Sigma = simpson_splitted_modified(@(x)f(x).*f(x), a, b) - sum(As.^2);
end


function vals = approximator(Xs, As, a, b)
    vals = zeros(1, length(Xs));
    for i = 1:length(Xs)
        vals(i) = 0;
        for j = 1:length(As)
            vals(i) = vals(i) + As(j)*Qi(Xs(i), j, a, b);
        end
    end
end


function area = simpson_splitted_modified(f, a, b)
    n = 1000;
    [pts, ~] = eqDistNodes(a, b, n);
    area = 0;
    for i = 1:(length(pts)-1)
       area = area + simpson_integr(f, pts(i), pts(i+1));
    end
end
function area = simpson_integr(f, a, b)
    area = (f(a) + 4*f((a+b)/2) + f(b)) * (b - a) / 6;
end
function [nodes, dist] = eqDistNodes(a, b, n)
    nodes = zeros(1, n);
    for i = 0:n
        nodes(i+1) = a + (b-a)*i/n;
    end
    dist = (b-a)/n;
end
