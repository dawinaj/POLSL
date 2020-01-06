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

Leader = zeros(1, hght);
Follower = zeros(1, hght);
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
    Leader(y) = MaxLossLeader;
    Follower(y) = MinLossFollower;
    fprintf('Leader''s worst outcome: (%f, %f)\n\n', MaxLossLeader, MinLossFollower)
end

Best = min(Leader);
Choices = find(Leader == Best);
fprintf('Leader''s safest strategies:\n')
for item = Choices
    fprintf('i=%i\n', item)
    fprintf('outcome=(%f, %f)\n', Best, Follower(item))
end

