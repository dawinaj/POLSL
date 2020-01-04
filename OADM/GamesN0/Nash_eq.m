clear all
clc

Payoff1 = [
    15  0
    30  -15
]

Payoff2 = [
    20  30
    10  0
]

if size(Payoff1) ~= size(Payoff2)
    disp 'Cant touch this'
    return
end

hght = size(Payoff1, 1);
wdth = size(Payoff1, 2);

for y = 1:hght
    for x = 1:wdth
        if Payoff1(y, x) == min(Payoff1(1:hght, x))
            if Payoff2(y, x) == min(Payoff2(y, 1:wdth))
                fprintf('i=%i, j=%i is Nash eq., outcome is (%f, %f)\n', y, x, Payoff1(y, x), Payoff2(y, x))
            end
        end
    end
end

