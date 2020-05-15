clear all
clc

a = -7;
b = 13;

pts = a:((b-a)/100):b;
[cs, sigma] = approximate(a, b, 20)
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
    Ai = integral(@(x)f(x).*Qi(x, i, a, b), a, b);
end

function Sigma = Sigma(As, a, b)
    Sigma = integral(@(x)f(x).*f(x), a, b) - sum(As.^2);
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
