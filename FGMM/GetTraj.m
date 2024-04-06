%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库

%% 加载FGMM数据
load ./Result/水FGMM.mat

%% 硬笔笔画
HardStrokePlot(charGMM,stroke,C,T,Q)

%% 软笔笔画
SoftStrokePlot(charGMM,data,C,T,Q)

%% 时序提取
% 时间列3，笔画列4
data = AddTime(data,stroke,componentOrder,C,T,Q);

%% GMR回归
trajectoryFGMM = GetTrajectory(data,componentOrder,step);

%% 加载GMM数据
load ./Result/水GMM.mat

%% 时序提取
% 时间列3，笔画列4
data = AddTime(data,stroke,componentOrder,C,T,Q);

%% GMR回归
trajectoryGMM = GetTrajectory(data,componentOrder,step);

%% 合并轨迹
trajectory=[trajectoryGMM(1:3,:);trajectoryFGMM(4:12,:)];

%% 数据处理
[trajectory,data] = TrajectoryProcess(trajectory,data);

%% 轨迹画图
% 二维轨迹
Traj2DPlot(data,componentOrder,trajectory)
% 
% 三维轨迹
Traj3DPlot(data,componentOrder,trajectory)
% 
% 模拟书写
TrajSmPlot(step,trajectory)

%% 保存数据
save('output.mat','trajectory');

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));
%% END