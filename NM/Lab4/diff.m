clear all
clc

n = 2
h = 1e-10
%x = 0

% plot the function, 1st and 2nd derivative
a=-5;
b=5;
pts = a:((b-a)/100):b;

figure
subplot(1,3,1)
hold on
%axis equal
dys = arrayfun(@(x) df(x), pts); % function
plot(pts, dys);
eys = arrayfun(@(x) forwdiff1(n, h, x), pts); % 1st der
plot(pts, eys);
legend("analyt. f'(x)","approx. f'(x)")
hold off
subplot(1,3,2)
hold on
rys = abs(eys-dys);
plot(pts, rys);
legend("abs error")
[v, x] = max(rys);
fprintf("Max error: %f, at x=%f\n", v, pts(x))
hold off
subplot(1,3,3)
hold on
rys = rys./abs(dys);
plot(pts, rys);
legend("rel error")
[v, x] = max(rys);
fprintf("Max rel error: %f, at x=%f\n", v, pts(x))
hold off



function dydx = df(x)
    dydx = cos(x);
end

function y = f(x) 
    y = sin(x);
end

% change N so that the error is smaller than accuracy
function [dydx, n] = variateN(n, h, z, acc)
    while true
        mtrx = zeros(n+2, n+2);
        for i = 0:(n+1) % fill 1st column with values of function
            mtrx(1+i, 1) = f(z+i*h);
        end
        for x = 1:(n+1) % create next column iteratively from previous column
            for i = 0:(n+1-x)
                mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
            end
        end
        suma = 0; % sum the coefficients
        for i = 2:(n+1)
            suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
        end
        dydx = 1/h*suma;
        
        err = mtrx(1, n+2) / h / factorial(n); % calculate and check error
        if abs(err) < acc
            break;
        end
        n = n+1; % increase order of op
    end
end

% change H so that the error is smaller than accuracy
function [dydx, h] = variateH(n, h, z, acc)
    while true
        mtrx = zeros(n+2, n+2);
        for i = 0:(n+1) % fill 1st column with values of function
            mtrx(1+i, 1) = f(z+i*h);
        end
        for x = 1:(n+1) % create next column iteratively from previous column
            for i = 0:(n+1-x)
                mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
            end
        end
        suma = 0; % sum the coefficients
        for i = 2:(n+1)
            suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
        end
        dydx = 1/h*suma;
        
        err = mtrx(1, n+2) / h / factorial(n); % calculate and check error
        if abs(err) < acc
            break;
        end
        h = h/10; % decrease step
    end
end

% calculate 1st derivative of f(x) at z
function dydx = forwdiff1(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n % fill 1st column with values of function
        mtrx(1+i, 1) = f(z+i*h);
    end
    for x = 1:n % create next column iteratively from previous column
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
        end
    end
    
    suma = 0; % sum the coefficients
    for i = 2:(n+1)
        suma = suma + 1/(i-1)*mtrx(1,i)*(-1)^i;
    end
    dydx = 1/h*suma;
    
end

% calculate 2nd derivative of f(x) at z
function dydx = forwdiff2(n, h, z)
    mtrx = zeros(n+1, n+1);
    for i = 0:n % fill 1st column with values of function
        mtrx(1+i, 1) = f(z+i*h);
    end
    for x = 1:n % create next column iteratively from previous column
        for i = 0:(n-x)
            mtrx(i+1, x+1) = (mtrx(i+2, x)-mtrx(i+1, x));
        end
    end
    
    suma = 0; % sum the coefficients
    for i = 3:(n+1)
        suma = suma + coefficients(i)*(-1)^(i)*mtrx(1,i);
    end
    dydx=1/h^2*suma;
end

% calculate coefficients for 2nd derivative
function coeffs = coefficients(n)
    mtrx = zeros(2*(n-1), 2);
    mtrx(1,1) = 1;
    mtrx(2*(n-1),1) = 1;
    for i=2:(n-1)
        mtrx(n-1-(i-2), 1) = 1/i*(-1)^(i+1);
        mtrx(n+(i-2), 1)   = 1/i*(-1)^(i+1);
    end
    for i = 1:(n-1)
        mtrx(i,2)= mtrx(2*(i-1)+1,1)*mtrx(2*(i-1)+2,1);
    end
    coeffs = 0;
    for i=1:n
        coeffs = coeffs + mtrx(i,2);
    end
end
