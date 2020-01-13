clear all
clc

func = @(x, y) sin(x-0.2)^2+sin(y+0.3)^2;

Min = [-1 -1];
Max = [ 1  1];

p0 = [1 -1];

%==============================================
funchelper = @(p) func(p(1), p(2));
iters = 0;
steps = 0;

fprintf('Current point: (%f, %f)\n', p0);
d1 = [1 0];
d2 = [0 1];
fprintf('Current dir:   [%f, %f]\n', d2);

aMin = nanmax((Min-p0)./d2);
aMax = nanmin((Max-p0)./d2);
alpha = 0;
if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
    alpha = fminbnd(@(a) funchelper(p0+a*d2), aMin, aMax);
end
fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
p0 = p0 + alpha*d2;
steps = steps+1;

while true
    fprintf('Current point: (%f, %f)\n', p0);
    fprintf('Current dir:   [%f, %f]\n', d1);
    aMin = nanmax(((Min(1)-p0(1))/d1(1))*(d1(1)>=0)+((Max(1)-p0(1))/d1(1))*(d1(1)<=0), ((Min(2)-p0(2))/d1(2))*(d1(2)>=0)+((Max(2)-p0(2))/d1(2))*(d1(2)<=0));
    aMax = nanmin(((Min(1)-p0(1))/d1(1))*(d1(1)<=0)+((Max(1)-p0(1))/d1(1))*(d1(1)>=0), ((Min(2)-p0(2))/d1(2))*(d1(2)<=0)+((Max(2)-p0(2))/d1(2))*(d1(2)>=0));
    alpha = 0;
    if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
        alpha = fminbnd(@(a) funchelper(p0+a*d1), aMin, aMax);
    end
    fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
    p1 = p0+alpha*d1;
    steps = steps+1;
    
    fprintf('Current point: (%f, %f)\n', p1);
    fprintf('Current dir:   [%f, %f]\n', d2);
    aMin = nanmax(((Min(1)-p1(1))/d2(1))*(d2(1)>=0)+((Max(1)-p1(1))/d2(1))*(d2(1)<=0), ((Min(2)-p1(2))/d2(2))*(d2(2)>=0)+((Max(2)-p1(2))/d2(2))*(d2(2)<=0));
    aMax = nanmin(((Min(1)-p1(1))/d2(1))*(d2(1)<=0)+((Max(1)-p1(1))/d2(1))*(d2(1)>=0), ((Min(2)-p1(2))/d2(2))*(d2(2)<=0)+((Max(2)-p1(2))/d2(2))*(d2(2)>=0));
    alpha = 0;
    if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
        alpha = fminbnd(@(a) funchelper(p1+a*d2), aMin, aMax);
    end
    fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
    p2 = p1+alpha*d2;
    steps = steps+1;
    
    d3 = p2 - p0;
    fprintf('Current point: (%f, %f)\n', p2);
    fprintf('Current dir:   [%f, %f]\n', d3);
    aMin = nanmax(((Min(1)-p2(1))/d3(1))*(d3(1)>=0)+((Max(1)-p2(1))/d3(1))*(d3(1)<=0), ((Min(2)-p2(2))/d3(2))*(d3(2)>=0)+((Max(2)-p2(2))/d3(2))*(d3(2)<=0));
    aMax = nanmin(((Min(1)-p2(1))/d3(1))*(d3(1)<=0)+((Max(1)-p2(1))/d3(1))*(d3(1)>=0), ((Min(2)-p2(2))/d3(2))*(d3(2)<=0)+((Max(2)-p2(2))/d3(2))*(d3(2)>=0));
    alpha = 0;
    if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
        alpha = fminbnd(@(a) funchelper(p2+a*d3), aMin, aMax);
    end
    fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
    p3 = p2+alpha*d3;
    steps = steps+1;
    iters = iters+1;
    
    if (sqrt(sum((p3-p0).^2)) < 0.001)
        break
    end
    p0 = p3;
    d1 = d2;
    d2 = d3;
end

fprintf('Final point: (%f, %f)\n', p3);
fprintf('Minimization took %i iterations and %i steps.\n', iters, steps);
