clear all
clc

f = @(x) sin(x(1)-0.2)^2+sin(x(2)+0.3)^2;
gf = @(x) [-2*sin(0.2-x(1))*cos(0.2-x(1)); 2*sin(x(2)+0.3)*cos(x(2)+0.3)];

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

x0 = [1; 1]

d1 = [1; 0];
d2 = [0; 1];

avect = sort([(xMin-x0(1))/d2(1), (yMin-x0(2))/d2(2), (xMax-x0(1))/d2(1), (yMax-x0(2))/d2(2)]);
alpha = fminbnd(@(a) f(x0+a*d2), avect(2), avect(3))
x0 = x0 + alpha*d2;

iterations=0;
while true
    
    x0
    
    avect = sort([(xMin-x0(1))/d1(1), (yMin-x0(2))/d1(2), (xMax-x0(1))/d1(1), (yMax-x0(2))/d1(2)]);
    alpha = fminbnd(@(a) f(x0+a*d1), avect(2), avect(3))
    x1 = x0+alpha*d1
    
    avect = sort([(xMin-x0(1))/d2(1), (yMin-x0(2))/d2(2), (xMax-x0(1))/d2(1), (yMax-x0(2))/d2(2)]);
    alpha = fminbnd(@(a) f(x1+a*d2), avect(2), avect(3))
    x2 = x1+alpha*d2
    
    d3 = x2 - x0
    avect = sort([(xMin-x0(1))/d3(1), (yMin-x0(2))/d3(2), (xMax-x0(1))/d3(1), (yMax-x0(2))/d3(2)]);
    alpha = fminbnd(@(a) f(x2+a*d3), avect(2), avect(3))
        
    x3 = x2+alpha*d3
    
    iterations = iterations+1;
    
    if (sqrt(sum(abs(x3-x0).^2)) < 0.001)
        break
    end
    x0 = x3;
    d1 = d2;
    d2 = d3;
end

iterations
