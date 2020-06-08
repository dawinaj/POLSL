clear all
clc

x = 3;
alpha = 2;
N = 10;  % intervals
I = 10; % iterations


iters = [2, 3, 4, 6, 8, 11, 16, 23, 32]
steps = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]

errors = zeros(2, length(iters));

[xs, ~] = solve_rectangle(x, I, N, alpha);
lapl = laplace(xs);

figure(1)
subplot(2, 3, 1)
hold on
plot(xs, lapl, 'DisplayName', 'Laplace')
subplot(2, 3, 2)
hold on
plot(xs, lapl, 'DisplayName', 'Laplace')

for i = 1:length(iters)
	[~, y1] = solve_rectangle(x, iters(i), N, alpha);
    [~, y2] = solve_trapezoid(x, iters(i), N, alpha);
    errors(1, i) = abs(lapl(end)-y1(end));
    errors(2, i) = abs(lapl(end)-y2(end));
    subplot(2, 3, 1)
    plot(xs, y1,   'DisplayName', int2str(iters(i)))
    subplot(2, 3, 2)
    plot(xs, y2,   'DisplayName', int2str(iters(i)))
end

errors
subplot(2, 3, 3)
semilogx(iters, errors(1, :),   'DisplayName', 'Rectangular')
hold on
semilogx(iters, errors(2, :),   'DisplayName', 'Trapezoid')

legend
title('Error by # of iterations')
xlabel('# iterations (log)')
ylabel('Absolute error')
hold off

subplot(2, 3, 1)
legend
title('Plot of function vs rectangular estimators')
xlabel('X')
ylabel('Y(X)')
hold off

subplot(2, 3, 2)
legend
title('Plot of function vs trapezoid estimators')
xlabel('X')
ylabel('Y(X)')
hold off


errors = zeros(2, length(steps));
[xs, ~] = solve_rectangle(x, I, N, alpha);
lapl = laplace(xs);

figure(1)
subplot(2, 3, 4)
hold on
plot(xs, lapl, 'DisplayName', 'Laplace')
subplot(2, 3, 5)
hold on
plot(xs, lapl, 'DisplayName', 'Laplace')

for i = 1:length(steps)
	[xs, y1] = solve_rectangle(x, I, steps(i), alpha);
    [~,  y2] = solve_trapezoid(x, I, steps(i), alpha);
    errors(1, i) = abs(lapl(end)-y1(end));
    errors(2, i) = abs(lapl(end)-y2(end));
    subplot(2, 3, 4)
    plot(xs, y1,   'DisplayName', int2str(steps(i)))
    subplot(2, 3, 5)
    plot(xs, y2,   'DisplayName', int2str(steps(i)))
end

errors
subplot(2, 3, 6)
semilogx(steps, errors(1, :),   'DisplayName', 'Rectangular')
hold on
semilogx(steps, errors(2, :),   'DisplayName', 'Trapezoid')
legend
title('Error by # of steps')
xlabel('# steps (log)')
ylabel('Absolute error')
hold off

subplot(2, 3, 4)
legend
title('Plot of function vs rectangular estimators')
xlabel('X')
ylabel('Y(X)')
hold off

subplot(2, 3, 5)
legend
title('Plot of function vs trapezoid estimators')
xlabel('X')
ylabel('Y(X)')
hold off










function y = laplace(t)
    y = zeros(1, length(t));
    for i = 1:length(t)
        y(i) = exp(-t(i))/2 - t(i)*exp(-t(i))+exp(t(i))/2;
    end
end



function [x, ret] = solve_rectangle(x, I, N, alpha)
    [x, dx] = eqDistNodes(0, x, N); % divide intrerval <0, x> into N pieces
    y = ones((I+1), (N+1));         % matrix for storing all iterations (subN, Xi)
    for i = 2:(I+1)                 % loop through iterations
        for n = 2:(N+1)             % loop through Xs
            sum = 0;
            for m = 1:(n-1)         % approximate integral by sum of rectangular pieces
                sum = sum + k(x(n)-x(m)) * y(i-1, m) * dx;
            end
            y(i, n) = alpha * sum + f(x(n));
        end
    end
    ret = y((I+1), :);              % return last row (last iteration)
end

function [x, ret] = solve_trapezoid(x, I, N, alpha)
    [x, dx] = eqDistNodes(0, x, N);
    y = ones((I+1), (N+1));
    for i = 2:(I+1)
        for n = 2:(N+1)
            sum = 0;
            for m = 1:(n-1)         % approximate integral by sum of rectangular pieces
                sum = sum + (k(x(n)-x(m)) * y(i-1, m) + k(x(n)-x(m+1)) * y(i-1, m+1))/2 * dx;
            end
            y(i, n) = alpha * sum + f(x(n));
        end
    end
    ret = y((I+1), :);
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
