%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\UtilFunction'));% 工具库
load ./Result/工作区/水FGMM.mat

%% 示教图像画图 fig1
% h=figure;
% hold on
% scatter(data(:,1),data(:,2),"filled","black");
% legend off
% axis off
% hold off

%% 先验轨迹画图 fig1
% h=figure;
% hold on
% gscatter(stroke(:,1),stroke(:,2),stroke(:,4),10);
% legend off
% axis off
% hold off
% SaveFigure(h,"先验轨迹图像",1)