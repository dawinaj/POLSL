clear all
clc

Payoff1 = [
    0   2   1.5
    1   1   3
    -1  2   2
]

Payoff2 = [
    -1  1   -0.75
    2   0   1
    0   1   -0.5
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

fprintf('1st Player is a Leader:\n');
Leader = zeros(1, hght);
Follower = zeros(1, hght);
for y = 1:hght
    MinLossFollower = min(Payoff2(y, 1:wdth));
    Resps = find(Payoff2(y, 1:wdth) == MinLossFollower);
    fprintf('R(%i) = { ', y)
    for r = Resps
        fprintf('%i ', r)
    end
    fprintf('};\n')
    for j = Resps
        fprintf('i=%i, j=%i; outcome=(%f, %f)\n', y, j, Payoff1(y, j), MinLossFollower);
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


fprintf('\n\n2nd Player is a Leader:\n');
Leader = zeros(1, wdth);
Follower = zeros(1, wdth);
for x = 1:wdth
    MinLossFollower = min(Payoff1(1:hght, x));
    Resps = find(Payoff1(1:hght, x) == MinLossFollower);
    fprintf('R(%i) = { ', x)
    for r = Resps
        fprintf('%i ', r)
    end
    fprintf('};\n')
    for i = Resps
        fprintf('i=%i, j=%i; outcome=(%f, %f)\n', i, x, MinLossFollower, Payoff2(i, x));
    end
    MaxLossLeader = max(Payoff2(Resps, x));
    Leader(x) = MaxLossLeader;
    Follower(x) = MinLossFollower;
    fprintf('Leader''s worst outcome: (%f, %f)\n\n', MinLossFollower, MaxLossLeader)
end

Best = min(Leader);
Choices = find(Leader == Best);
fprintf('Leader''s safest strategies:\n')
for item = Choices
    fprintf('i=%i\n', item)
    fprintf('outcome=(%f, %f)\n', Follower(item), Best)
end
