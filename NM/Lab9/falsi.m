clear all
clc

regulafalsi(1, 5, 0.000001)

function y = f(x) 
    y = -9/x+5;
end

function x = regulafalsi(a, b, acc)
    if sign(f(a)) == 0
        x = a;
    elseif sign(f(b)) == 0
        x = b;
    elseif sign(f(a)) ~= sign(f(b))
        while 1
            x = a - f(a)/(f(b)-f(a))*(b-a);
            if sign(f(x)) == sign(f(a))
                a = x;
            elseif sign(f(x)) == sign(f(b))
                b = x;
            else
                a = x;
                b = x;
            end
            if abs(b-a) < acc
               break; 
            end
        end
        x = (a+b)/2;
	else
        error("The same signs!");
    end
end
