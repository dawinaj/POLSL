clear all
clc

regulafalsi(-10, 1, 0.01)

function y = f(x) 
    y = x^4 - 625;
end

function x = regulafalsi(a, b, acc)
    if sign(f(a)) ~= sign(f(b))
        while 1
            x = a - f(a)/(f(b)-f(a))*(b-a)
            if sign(f(x)) == sign(f(a))
                a = x
            elseif sign(f(x)) == sign(f(b))
                b = x
            end
            if abs(f(x)) < acc
                break;
            end
            if abs(b-a) < acc
                break;
            end
        end
	else
        error("The same signs!");
    end
end
