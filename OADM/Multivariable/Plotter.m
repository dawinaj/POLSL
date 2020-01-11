clear all
clc

func = @(x, y) sin(x-0.2)^2+sin(y+0.3)^2;

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

%==============================================

[X, Y] = meshgrid(xMin:0.1:xMax, yMin:0.1:yMax);
Z = arrayfun(func, X, Y);
surf(X, Y, Z)
colormap(jet)
shading interp
