close all
clear all
clc

% global H W CPM world iRd


% params
H = 100;    % height
W = 100;    % width
CPM = 1;    % cells per meter


%  ╔╗
% ╔╝║
% ╚╗║
%  ║║
% ╔╝╚╗
% ╚══╝
% creating the world
% %{
world = World(H, W, CPM);

% walls
world.setRegion(0,  30, 50, 1, true)
world.setRegion(30, 48, 70, 1, true)
world.setRegion(0,  70, 50, 1, true)

% blocks
world.setRegion(10, 10, 20, 10, true)
world.setRegion(60, 10, 20, 10, true)
world.setRegion(70, 70, 10, 20, true)


% figure
% world.showTerrain();

%}

% ╔═══╗
% ║╔═╗║
% ╚╝╔╝║
% ╔═╝╔╝
% ║║╚═╗
% ╚═══╝
% generate vector field
% %{
world.genForces(20, [26, 87]);
world.genNavigation([26, 87]);
% world.genNavigation([52.5, 52.5]);

figure
world.showTerrain();
hold on
world.showForces();

figure
world.showTerrain();
hold on
world.showNavigation();

figure
world.showTerrain();
hold on
world.showCombined();

world.genPath([26, 26], [26, 87]);
% world.genPath([100, 10], [52.5, 52.5]);

% figure
% world.showTerrain();
% hold on
% world.showCombined();
world.showPath();


