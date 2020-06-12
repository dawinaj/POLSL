clear all
clc

tMax = 2;
zMin = 0;
zMax = 1;
a2 = 0.01;
h = 0.2;
r = 0.1;

w = net_method(tMax, zMin, zMax, h, r, a2)



function w = net_method(tM, zm, zM, h, r, a2)
    [Ti, tc] = Nodes(0,  tM, h)
    [Zk, zc] = Nodes(zm, zM, r)
    w = zeros(length(Ti), length(Zk));
    for i = 1
    end
end

function ret = wt0z(z)
    ret = sin(pi*z)
end

% Separate interval into h-long pieces, return their borders and count
function [nodes, count] = Nodes(a, b, h)
    nodes = a:h:b;
    count = length(nodes);
end
