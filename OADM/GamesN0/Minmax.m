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

MaxLosses = max(Payoff1, [], 2);
MinLossP1 = min(MaxLosses);
ChoicesP1 = find(MaxLosses==MinLossP1);
MaxLosses = max(Payoff2, [], 1);
MinLossP2 = min(MaxLosses);
ChoicesP2 = find(MaxLosses==MinLossP2);
fprintf('Player 1:\n')
fprintf('MinLoss = %f for decisions:\n', MinLossP1)
for y = 1:length(ChoicesP1)
    fprintf('i=%i\n', ChoicesP1(y))
end
fprintf('Player 2:\n')
fprintf('MinLoss = %f for decisions:\n', MinLossP2)
for x = 1:length(ChoicesP2)
    fprintf('j=%i\n', ChoicesP2(x))
end
fprintf('\n')
for y = 1:length(ChoicesP1)
    for x = 1:length(ChoicesP2)
        fprintf('i=%i, j=%i; outcome=(%f, %f)\n', ChoicesP1(y), ChoicesP2(x), MinLossP1, MinLossP2)
    end
end
