clear all
clc

tMax = 2;
zMin = 0;
zMax = 1;
a2 = 0.01;
h = 0.2;
r = 0.1;

w = net_method(tMax, zMin, zMax, h, r)



function w = net_method(tM, zm, zM, h, r)
    Ti = Nodes(0,  tM, h)
    Zk = Nodes(zm, zM, r)
    w=0
end

function ret = wt0z(z)
    ret = sin(pi*z)
end

% Separate interval into h-long pieces, return their borders
function [nodes] = Nodes(a, b, h)
    nodes = a:h:b;
end
