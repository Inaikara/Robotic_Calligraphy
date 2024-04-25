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
%% 时序提取
% 时间列3，笔画列4
data = AddTime(data,stroke,componentOrder,C,T,Q);

%% GMR回归
[trajectory,trajSigma,trajthick] = GetTrajectory(data,componentOrder,step);

%% 数据处理
[trajectory,data] = TrajectoryProcess(trajectory,data);

%% 改进前
figure
hold on
for i=1:size(trajSigma,1)/2
    plotGMM(trajectory([3*i-1,3*i],:), trajSigma([2*i-1,2*i],:,:),[0 0 .8], 2)
end
% plot(data(:,1),data(:,2),'r.');
hold off

%% 改进后
figure
hold on
for i=1:size(trajthick,1)/2
    plotGMM(trajectory([3*i-1,3*i],:), trajthick([2*i-1,2*i],:,:),[0 0 .8], 2)
end
% plot(data(:,1),data(:,2),'r.');
hold off

%% 理论书写轨迹（改进后）
% figure
% hold on
% trajthick=zeros(2,2,step);
% for i=1:3:size(trajectory,1)
%     trajthick(1,1,:)=(trajectory(i,:).*trajectory(i,:))/3;
%     trajthick(2,2,:)=(trajectory(i,:).*trajectory(i,:))/3;
%     plotGMM(trajectory([i+1,i+2],:), trajthick,[0 0 .8], 2)
% end
% plot(data(:,1),data(:,2),'r.');
% hold off




%% 实际书写轨迹画图（改进后）
% figure;
% t = 0 :  .1 : 2 * pi;
% color=[0 0 .8] + [0.6,0.6,0.6];
% color(find(color>1.0)) = 1.0;
% hold on
% plot(data(:,1),data(:,2),'r.');
% for n=1:size(trajectory,1)/3
%     for k=1:step
%         i = trajectory(n*3-2,k) * cos(t) + trajectory(n*3-1,k);
%         j = trajectory(n*3-2,k) * sin(t) + trajectory(n*3,k);
%         patch(i, j, color,'LineStyle', 'none','FaceAlpha',.5); %// plot filled circle with transparency
%     end
% end
% hold off


%% 保存数据
% save('下.mat','trajectory');

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));
%% END