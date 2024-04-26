%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\UtilFunction'));% 工具库

%% 加载FGMM数据
load ./Result/工作区/水FGMM.mat
dataNew=[];
trajectoryFGMM=[];
trajsigmaFGMM=[];
trajthickFGMM=[];

%% 遍历每个笔画
strokelist=unique(componentOrder(:,1))';
for stroketype=strokelist
    %% 导入笔画数据
    strokedata=data(data(:,4)==stroketype,[1,2,3]);
    strokedirect=stroke(stroke(:,4)==stroketype,[1,2,3]);

    %% 时间编码
    strokedata = GetFGMMTime(strokedata,strokedirect,C,T,Q);
    dataNew=[dataNew;strokedata];
        
    %% 轨迹生成
    [stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

    %% 保存
    trajectoryFGMM=[trajectoryFGMM;stroketrajectory];
    trajsigmaFGMM=[trajsigmaFGMM;stroketrajsigma];
    trajthickFGMM=[trajthickFGMM;stroketrajthick];
end

%% 加载GMM数据
load ./Result/工作区/水GMM.mat
trajectoryGMM=[];
trajsigmaGMM=[];
trajthickGMM=[];
%% 遍历每个笔画
strokelist=unique(componentOrder(:,1))';
for stroketype=strokelist
    %% 导入笔画数据
    strokedata=data(data(:,4)==stroketype,[1,2,3]);
    strokedirect=stroke(stroke(:,4)==stroketype,[1,2,3]);

    %% 时间编码
    strokedata = GetFGMMTime(strokedata,strokedirect,C,T,Q);

    %% 轨迹生成
    [stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

    %% 保存
    trajectoryGMM=[trajectoryGMM;stroketrajectory];
    trajsigmaGMM=[trajsigmaGMM;stroketrajsigma];
    trajthickGMM=[trajthickGMM;stroketrajthick];
end

%% FGMM+GMM
trajectory=[trajectoryGMM(1:2,:);trajectoryFGMM(3:8,:)];
trajsigma=[trajsigmaGMM(1:2,:,:);trajsigmaFGMM(3:8,:,:)];
trajthick=[trajthickGMM(1:2,:,:);trajthickFGMM(3:8,:,:)];

%% 画图
h=figure;
hold on
for i=1:size(trajectory,1)/2
    plotGMM(trajectoryGMM([2*i-1,2*i],:), trajsigmaGMM([2*i-1,2*i],:,:),[0 0 .8], 5)
end
hold off
SaveFigure(h,"1",1)

h=figure;
hold on
for i=1:size(trajectory,1)/2
    plotGMM(trajectoryGMM([2*i-1,2*i],:), trajthickGMM([2*i-1,2*i],:,:),[0 0 .8], 6)
end
hold off
SaveFigure(h,"2",1)

h=figure;
hold on
for i=1:size(trajectory,1)/2
    plotGMM(trajectory([2*i-1,2*i],:), trajthick([2*i-1,2*i],:,:),[0 0 .8], 6)
end
hold off
SaveFigure(h,"3",1)
%% END


