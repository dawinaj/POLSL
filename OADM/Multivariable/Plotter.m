clear all
clc

f = @(x) sin(x(1)-0.2)^2+sin(x(2)+0.3)^2;

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

%==============================================

helper = @(x, y) f([x y]);
[X, Y] = meshgrid(xMin:0.1:xMax, yMin:0.1:yMax);
Z = arrayfun(helper, X, Y);
colormap(jet)
shading interp
mesh(X, Y, Z, 'FaceAlpha', '0.5', 'FaceColor', 'flat')
