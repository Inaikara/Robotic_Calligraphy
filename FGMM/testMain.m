%% 添加路径
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库
%% 参数设定
step=1000;
numComponent = 7;
img = rgb2gray(imread('input.jpg'));

%% 图像预处理
[img,data] = ImgProcess(img);

%% 硬笔笔画提取
stroke=FindCurve(img,5);

%% 硬笔笔画优化
stroke = StrokeOptimize(stroke);

%% GMM参数估计
[charGMM,C,T,Q]=GenerateFGMM(data, numComponent);

%% 软笔笔画提取
% 成分列3，笔画列4
[data,stroke,componentOrder]= AddStroke(data,stroke,charGMM);

%% 时序提取
% 时间列3，笔画列4
data = AddTime(data,stroke,componentOrder,C,Q,T);

%% 笔画画图
% % 硬笔笔画
% HardStrokePlot(charGMM,C,T,Q,stroke)
% 软笔笔画
SoftStrokePlot(charGMM,C,T,Q,data)

%% GMR回归
trajectory = GetTrajectory(data,componentOrder,step);

%% 数据处理
[trajectory,data] = TrajectoryProcess(trajectory,data);

%% 轨迹画图
% % 二维轨迹
% Traj2DPlot(data,componentOrder,trajectory)
% 
% 三维轨迹
Traj3DPlot(data,componentOrder,trajectory)
% 
% 模拟书写
TrajSmPlot(step,trajectory)

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));

%% 保存数据
save('output.mat','trajectory');

%% END