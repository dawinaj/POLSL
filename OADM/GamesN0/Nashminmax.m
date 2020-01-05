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
% ==================================================

if size(Payoff1) ~= size(Payoff2)
    disp 'Cant touch this'
    return
end
hght = size(Payoff1, 1);
wdth = size(Payoff1, 2);

% ============={ NASH }=============
fprintf(' #   #   #   ###  # #\n ##  #  # #  #    # #\n # # #  ###  ###  ###\n #  ##  # #    #  # #\n #   #  # #  ###  # #\n\n')

Nashes = zeros(0, 0);
index = 1;
for y = 1:hght
    for x = 1:wdth
        if Payoff1(y, x) == min(Payoff1(1:hght, x))
            if Payoff2(y, x) == min(Payoff2(y, 1:wdth))
                Nashes(index, 1) = y;
                Nashes(index, 2) = x;
                index = index+1;
            end
        end
    end
end
for i = 1:size(Nashes, 1)
    y = Nashes(i, 1);
    x = Nashes(i, 2);
    feasible = true;
    for t = 1:size(Nashes, 1)
        if Payoff1(Nashes(t, 1), Nashes(t, 2)) < Payoff1(y, x) && Payoff2(Nashes(t, 1), Nashes(t, 2)) < Payoff2(y, x)
            feasible = false;
            break
        end
    end
    fprintf('i=%i, j=%i; outcome=(%f, %f); feasible: %s\n', y, x, Payoff1(y, x), Payoff2(y, x), mat2str(feasible))
end


% ============={ MIXED NASH }=============
fprintf('\n\n  #   #  ###  # #  ###  ##       #   #   #   ###  # #  \n  ## ##   #   # #  #    # #      ##  #  # #  #    # #  \n  # # #   #    #   ##   # #      # # #  ###  ###  ###  \n  #   #   #   # #  #    # #      #  ##  # #    #  # #  \n  #   #  ###  # #  ###  ##       #   #  # #  ###  # #  \n\n')






% ============={ MINMAX }=============
fprintf('\n\n #   #   #   # #  #   #  ###  #   #  \n ## ##  # #  # #  ## ##   #   ##  #  \n # # #  ###   #   # # #   #   # # #  \n #   #  # #  # #  #   #   #   #  ##  \n #   #  # #  # #  #   #  ###  #   #  \n\n')

MaxLosses = max(Payoff1, [], 2);
MinLossP1 = min(MaxLosses);
ChoicesP1 = find(MaxLosses==MinLossP1);
MaxLosses = max(Payoff2, [], 1);
MinLossP2 = min(MaxLosses);
ChoicesP2 = find(MaxLosses==MinLossP2);
fprintf('Player 1:\n')
fprintf('MinLoss = %f for decisions:\n', MinLossP1)
for y = ChoicesP1
    fprintf('i=%i\n', y)
end
fprintf('Player 2:\n')
fprintf('MinLoss = %f for decisions:\n', MinLossP2)
for x = ChoicesP2
    fprintf('j=%i\n', x)
end
fprintf('\n')
for y = ChoicesP1
    for x = ChoicesP2
        fprintf('i=%i, j=%i; outcome=(%f, %f)\n', y, x, MinLossP1, MinLossP2)
    end
end
