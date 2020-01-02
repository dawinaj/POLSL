clear all
clc

f = @(x) sin(x(1)-0.2)^2+sin(x(2)+0.3)^2;
gf = @(x) [-2*sin(0.2-x(1))*cos(0.2-x(1)); 2*sin(x(2)+0.3)*cos(x(2)+0.3)];

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

x0 = [0; 0];

iterations=0;
while true
    
    x0
    x1 = x0;
    for i = 1:size(x0)
        d1 = zeros(size(x0));
        d1(i) = 1;
        
        avect = sort([(xMin-x0(1))/d1(1), (yMin-x0(2))/d1(2), (xMax-x0(1))/d1(1), (yMax-x0(2))/d1(2)]);
        alpha = fminbnd(@(a) f(x0+a*d1), avect(2), avect(3))
        
        x1 = x1+alpha*d1
    end
    
    iterations = iterations+1;
    
    if (sqrt(sum(abs(x1-x0).^2)) < 0.001)
        break
    end
    x0 = x1;
end

iterations
