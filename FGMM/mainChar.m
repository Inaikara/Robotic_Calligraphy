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

    %% 轨迹生成
    [stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

    %% 保存
    trajectoryFGMM=[trajectoryFGMM;stroketrajectory];
    trajsigmaFGMM=[trajsigmaFGMM;stroketrajsigma];
    trajthickFGMM=[trajthickFGMM;stroketrajthick];
end

%% 加载GMM数据
load ./Result/水GMM.mat
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
% plotstroke=1:size(trajectory,1)/2;
plotstroke=3;

% GMM+Sigma
figure
hold on
for i=plotstroke
    plotGMM(trajectoryGMM([2*i-1,2*i],:), trajsigmaGMM([2*i-1,2*i],:,:),[0 0 .8], 2)
    plot(data(data(:,4)==strokelist(i),1),data(data(:,4)==strokelist(i),2),'b.')
end
% plot(data(:,1),data(:,2),'b.');
hold off

% GMM+DA
figure
hold on
for i=plotstroke
    plotGMM(trajectoryGMM([2*i-1,2*i],:), trajthickGMM([2*i-1,2*i],:,:),[0 0 .8], 4)
    plot(data(data(:,4)==strokelist(i),1),data(data(:,4)==strokelist(i),2),'b.')
end
% plot(data(:,1),data(:,2),'b.');
hold off

% FGMM+DA
figure
hold on
for i=plotstroke
    plotGMM(trajectory([2*i-1,2*i],:), trajthick([2*i-1,2*i],:,:),[0 0 .8], 4)
    plot(data(data(:,4)==strokelist(i),1),data(data(:,4)==strokelist(i),2),'b.')
end
% plot(data(:,1),data(:,2),'b.');
hold off

%% END


