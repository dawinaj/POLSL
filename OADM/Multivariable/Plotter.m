clear all
clc

f = @(x) sin(x(1)-0.2)^2+sin(x(2)+0.3)^2;

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

%==============================================

helper = @(x, y) f([x y]);
[X, Y] = meshgrid(xMin:0.01:xMax, yMin:0.01:yMax);
Z = arrayfun(helper, X, Y);
surf(X, Y, Z)
colormap(jet)
shading interp
