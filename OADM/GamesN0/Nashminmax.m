clear all
clc

Payoff1 = [
   1    0
   0    1
]

Payoff2 = [
    0   1
    1   0
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

NashY = [];
NashX = [];
index = 1;
for y = 1:hght
    for x = 1:wdth
        if Payoff1(y, x) == min(Payoff1(1:hght, x))
            if Payoff2(y, x) == min(Payoff2(y, 1:wdth))
                NashY(index) = y;
                NashX(index) = x;
                index = index+1;
            end
        end
    end
end
for i = 1:length(NashY)
    y = NashY(i);
    x = NashX(i);
    feasible = true;
    for t = 1:length(NashY)
        if Payoff1(NashY(t), NashX(t)) < Payoff1(y, x) && Payoff2(NashY(t), NashX(t)) < Payoff2(y, x)
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
fprintf('Safety = %f for decisions:\n', MinLossP1)
for y = ChoicesP1
    fprintf('i=%i\n', y)
end
fprintf('Player 2:\n')
fprintf('Safety = %f for decisions:\n', MinLossP2)
for x = ChoicesP2
    fprintf('j=%i\n', x)
end
fprintf('\n')
for y = ChoicesP1.'
    for x = ChoicesP2
        fprintf('i=%i, j=%i; safety=(%f, %f)\n', y, x, MinLossP1, MinLossP2)
    end
end
