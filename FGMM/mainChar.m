%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库

trajectory=[];
trajsigma=[];
trajthick=[];
%% 加载GMM数据
load ./Result/水GMM.mat

%% 遍历每个笔画
for stroketype=1
% for stroketype=unique(componentOrder(:,1))'
    %% 导入笔画数据
    strokedata=data(data(:,4)==stroketype,[1,2,3]);
    strokedirect=stroke(stroke(:,4)==stroketype,[1,2,3]);

    %% 时间编码
    strokedata = GetFGMMTime(strokedata,strokedirect,C,T,Q);

    %% 轨迹生成
    [stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

    %% 保存
    trajectory=[trajectory;stroketrajectory];
    trajsigma=[trajsigma;stroketrajsigma];
    trajthick=[trajthick;stroketrajthick];
end

%% 加载FGMM数据
load ./Result/水FGMM.mat
%% 遍历每个笔画
for stroketype=[2,4,5]
    %% 导入笔画数据
    strokedata=data(data(:,4)==stroketype,[1,2,3]);
    strokedirect=stroke(stroke(:,4)==stroketype,[1,2,3]);

    %% 时间编码
    strokedata = GetFGMMTime(strokedata,strokedirect,C,T,Q);

    %% 轨迹生成
    [stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

    %% 保存
    trajectory=[trajectory;stroketrajectory];
    trajsigma=[trajsigma;stroketrajsigma];
    trajthick=[trajthick;stroketrajthick];
end

%% 画图
%% 改进前
figure
hold on
for i=1:2:size(trajsigma,1)
    plotGMM(trajectory([i,i+1],:), trajsigma([i,i+1],:,:),[0 0 .8], 4)
end
plot(data(:,1),data(:,2),'.');
hold off

%% 改进后
figure
hold on
for i=1:2:size(trajthick,1)
    plotGMM(trajectory([i,i+1],:), trajthick([i,i+1],:,:),[0 0 .8], 4)
end
% plot(data(:,1),data(:,2),'.');
% scatter(data(:,1),data(:,2),'filled','MarkerFaceAlpha',.2);
hold off



