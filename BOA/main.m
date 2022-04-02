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


figure
world.showTerrain();
%}


% ╔═══╗
% ║╔═╗║
% ╚╝╔╝║
% ╔═╝╔╝
% ║║╚═╗
% ╚═══╝
% generate vector field
% %{

world.genForces(20, [20.5, 90.5]);
figure
world.showPotential();
% figure
hold on
world.showVectors();
% world.showCar();
%}




