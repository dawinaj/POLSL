clear all
clc

tMax = 2;
zMin = 0;
zMax = 1;
a2 = 0.01;
h = 0.2;
r = 0.1;
bndZMin = 0;
bndZMax = 0;

[w, t, z] = net_method(tMax, zMin, zMax, h, r, a2, bndZMin, bndZMax)
y = reference(t, z, a2)
surf(z, t, y)
colormap(jet)
shading interp

MSE = MS(y-w)


function [w, Ti, Zk] = net_method(tM, zm, zM, h, r, a2, bzm, bzM)
    [Ti, tc] = Nodes(0,  tM, h)
    [Zk, zc] = Nodes(zm, zM, r)
    w = zeros(tc, zc);
    for k = 1:zc
        w(1, k) = wt0z(Zk(k));
    end
    
    for i = 1:tc
        w(i, 1)  = bzm;
        w(i, zc) = bzM;
    end
    
    for i = 2:tc
        for k = 2:(zc-1)
            w(i, k) = w(i-1, k) + a2 * h / r / r * (w(i-1, k-1) - 2*w(i-1, k) + w(i-1, k+1));
        end
    end
end

function ret = wt0z(z)
    ret = sin(pi*z);
end

function y = reference(t, z, a2)
    tc = length(t);
    zc = length(z);
    y = zeros(tc, zc);
    for i = 1:tc
        for k = 1:zc
            y(i, k) = exp(-pi^2 * a2*t(i))*sin(pi*z(k));
        end
    end
end

% Separate interval into h-long pieces, return their borders and count
function [nodes, count] = Nodes(a, b, h)
    nodes = a:h:b;
    count = length(nodes);
end


function m = MS(w)
    w = w.^2;
    m = mean(w, 'all');
end
