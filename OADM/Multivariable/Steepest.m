clear all
clc

func = @(x, y) sin(x-0.2)^2+sin(y+0.3)^2;
grad = @(x, y) [-2*sin(0.2-x)*cos(0.2-x) 2*sin(y+0.3)*cos(y+0.3)];

Min = [-1 -1];
Max = [ 1  1];

p0 = [0 0];

%==============================================
funchelper = @(p) func(p(1), p(2));
gradhelper = @(p) grad(p(1), p(2));

iters = 0;

while true
    fprintf('Current point: (%f, %f)\n', p0);
    d1 = -(gradhelper(p0));
    fprintf('Current dir:   [%f, %f]\n', d1);
    aMin = nanmax(((Min(1)-p0(1))/d1(1))*(d1(1)>=0)+((Max(1)-p0(1))/d1(1))*(d1(1)<=0), ((Min(2)-p0(2))/d1(2))*(d1(2)>=0)+((Max(2)-p0(2))/d1(2))*(d1(2)<=0));
    aMax = nanmin(((Min(1)-p0(1))/d1(1))*(d1(1)<=0)+((Max(1)-p0(1))/d1(1))*(d1(1)>=0), ((Min(2)-p0(2))/d1(2))*(d1(2)<=0)+((Max(2)-p0(2))/d1(2))*(d1(2)>=0));
    alpha = 0;
    if aMin <= aMax && ~isinf(aMin) && ~isinf(aMax)
        alpha = fminbnd(@(a) funchelper(p0+a*d1), min(aMax, aMin), max(aMax, aMin));
    end
    fprintf('\nAlpha: %f E <%f, %f>\n\n', alpha, aMin, aMax);
    p0 = p0+alpha*d1;
    
    iters = iters + 1;
    
    if (sqrt(sum((alpha*d1).^2)) < 0.001)
        break
    end
end

fprintf('Final point: (%f, %f)\n', p0);
fprintf('Minimization took %i iterations.\n', iters);
