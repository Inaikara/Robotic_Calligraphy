%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库

%% 加载FGMM数据
load ./Result/下FGMM.mat

%% 硬笔笔画
HardStrokePlot(charGMM,stroke,C,T,Q)

%% 软笔笔画
SoftStrokePlot(charGMM,data,C,T,Q)

%% 时序提取
% 时间列3，笔画列4
data = AddTime(data,stroke,componentOrder,C,T,Q);

%% GMR回归
trajectory = GetTrajectory(data,componentOrder,step);

%% 数据处理
[trajectory,data] = TrajectoryProcess(trajectory,data);

%% 理论书写轨迹画图
figure
hold on
trajsigma=zeros(2,2,step);
for i=1:3:size(trajectory,1)
    trajsigma(1,1,:)=trajectory(i,:);
    trajsigma(2,2,:)=trajectory(i,:);
    plotGMM(trajectory([i+1,i+2],:), trajsigma,[0 0 .8], 2)
end
hold off


%% 实际书写轨迹画图
%% 二维轨迹
Traj2DPlot(data,componentOrder,trajectory)
%% 三维轨迹
Traj3DPlot(data,componentOrder,trajectory)
%% 模拟书写
TrajSmPlot(step,trajectory)

%% 保存数据
% save('下.mat','trajectory');

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));
%% END