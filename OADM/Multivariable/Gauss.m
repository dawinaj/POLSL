clear all
clc

func = @(x, y) sin(x-0.2)^2+sin(y+0.3)^2;

Min = [-1 -1];
Max = [ 1  1];

p0 = [0 1];
%==============================================
funchelper = @(p) func(p(1), p(2));

iters = 0;
steps = 0;

while true
    p1 = p0;
    for i = 1:length(p0)
        fprintf('Current point: (%f, %f)\n', p1);
        d1 = zeros(1, length(p0));
        d1(i) = 1;
        fprintf('Current dir:   [%f, %f]\n', d1);
        aMin = nanmax((Min-p1)./d1);
        aMax = nanmin((Max-p1)./d1);
        alpha = 0;
        if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
            alpha = fminbnd(@(a) funchelper(p1+a*d1), aMin, aMax);
        end
        fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
        p1 = p1+alpha*d1;
        steps = steps + 1;
    end
    iters = iters + 1;
    
    if (sqrt(sum(abs(p1-p0).^2)) < 0.001)
        break
    end
    p0 = p1;
end

fprintf('Minimization took %i iterations and %i steps.\n', iters, steps);
