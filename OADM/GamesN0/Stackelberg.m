clear all
clc

Payoff1 = [
    1   2   4
    3   2   0
]

Payoff2 = [
    0   1   0
    1   1   2
]
% ==================================================

if size(Payoff1) ~= size(Payoff2)
    disp 'Cant touch this'
    return
end
hght = size(Payoff1, 1);
wdth = size(Payoff1, 2);

% ============={ STACKELBERG }=============

fprintf('  ###  ###   #    ##  # #  ###  #    ##   ###  ###   ##   \n  #     #   # #  #    # #  #    #    # #  #    # #  #     \n  ###   #   ###  #    ##   ##   #    ###  ##   ###  # ##  \n    #   #   # #  #    # #  #    #    # #  #    ##   #  #  \n  ###   #   # #   ##  # #  ###  ###  ##   ###  # #   ##   \n\n')

Safety = zeros(hght, 1);
for y = 1:hght
    MinLossFollower = min(Payoff2(y, 1:wdth));
    Resps = find(Payoff2(y, 1:wdth) == MinLossFollower);
    fprintf('R(%i) = {', y)
    for r = 1:(length(Resps)-1)
        fprintf('%i, ', Resps(r))
    end
    fprintf('%i};\n', Resps(r+1))
    for j = 1:length(Resps)
        fprintf('i=%i, j=%i; outcome=(%f, %f)\n', y, Resps(j), Payoff1(y, Resps(j)), MinLossFollower);
    end
    MaxLossLeader = max(Payoff1(y, Resps));
%    Choices = find(Payoff1(y, Resps) == MaxLossLeader)
    Safety(y) = MaxLossLeader;
    fprintf('Max loss: %f\n\n', MaxLossLeader)
end

Best = min(Safety);
Choices = find(Safety == Best);
fprintf('Leader''s safety level = %f for:\n', Best)
 for i = Choices
    fprintf('i=%i\n', i);
end
