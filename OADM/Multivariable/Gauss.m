clear all
clc

f  = @(p) sin(p(1)-0.2)^2+sin(p(2)+0.3)^2;
gf = @(p) [-2*sin(0.2-p(1))*cos(0.2-p(1))   2*sin(p(2)+0.3)*cos(p(2)+0.3)];

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

p0 = [0 0];

%==============================================
temp = sort([xMin, xMax]);
[xMin, xMax] = deal(temp(1), temp(2));
temp = sort([yMin, yMax]);
[yMin, yMax] = deal(temp(1), temp(2));

iters = 0;
steps = 0;

while true
    p1 = p0;
    for i = 1:length(p0)
        fprintf('Current point: (%f, %f)\n', p0(1), p0(2));
        d0 = zeros(1, length(p0));
        d0(i) = 1;
        fprintf('Current dir:   [%f, %f]\n', d0(1), d0(2));
        aMin = nanmax((xMin-p1(1))/d0(1), (yMin-p1(2))/d0(2));
        aMax = nanmin((xMax-p1(1))/d0(1), (yMax-p1(2))/d0(2));
        if aMin <= aMax
            alpha = fminbnd(@(a) f(p1+a*d0), aMin, aMax);
        else
            alpha = 0;
        end
        fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
        p1 = p1+alpha*d0;
        steps = steps + 1;
    end
    iters = iters + 1;
    
    if (sqrt(sum(abs(p1-p0).^2)) < 0.001)
        break
    end
    p0 = p1;
end

fprintf('Minimization took %i iterations and %i steps.\n', iters, steps);
