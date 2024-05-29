%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\UtilFunction'));% 工具库
load ./Result/工作区/水FGMM.mat

%% 生成FGMM数据点fig2
% 设置高斯分布的参数
theta=deg2rad(45);
mu = [1, 0.5]; % 均值
Sigma = [0.5, 0; 0, 0.03]; % 协方差矩阵
C=[0.3,0];
T=mu;
Q=[cos(theta),-sin(theta);sin(theta),cos(theta)];

% 生成二维高斯分布的数据
n = 50; % 数据点的数量
data3 = mvnrnd([0,0], Sigma, n);
data1= data3*Q'+T;
data1=BendPoint(data1,C,T,Q);% 生成弯曲数据
%% 变换数据
[C,T,Q] = PCA2LSFM(data1);
T0=repmat(T,[size(data1,1),1]);
data2 = (Q'*(data1-T0)')';

%% 训练
[charGMM1,C1,T1,Q1]=GenerateFGMM(data1, 1);
[charGMM2,C2,T2,Q2]=GenerateFGMM(data2, 1);
[charGMM3,C3,T3,Q3]=GenerateFGMM(data3, 1);

%% 函数图像绘制
x=-Sigma(1):0.01:Sigma(1);
x=x';
y3=zeros(length(x),1);
y2=C2(1)*x.*x+C2(2);
y1=[x,y2]*Q'+T;

%% 绘制数据点
figure
set(gca,'XAxisLocation','origin')
set(gca,'YAxisLocation','origin')
set(gca,'xticklabel',[],'yticklabel',[])
hold on
scatter(data1(:, 1), data1(:, 2),".");
plotBendGMM(charGMM1,C1,T1,Q1, [0 .8 0], 1);
xlim([-2,2])
ylim([-1,2])

arrowAxes(gca)
hold off
ax=gca;
exportgraphics(ax,'fig2a.png','Resolution',600)

figure
set(gca,'XAxisLocation','origin')
set(gca,'YAxisLocation','origin')
set(gca,'xticklabel',[],'yticklabel',[])
hold on
scatter(data2(:, 1), data2(:, 2),".");
plotBendGMM(charGMM2,C2,T2,Q2, [0 .8 0], 1);
xlim([-2,2])
ylim([-1,2])

arrowAxes(gca)
hold off
ax=gca;
exportgraphics(ax,'fig2b.png','Resolution',600)

figure
set(gca,'XAxisLocation','origin')
set(gca,'YAxisLocation','origin')
set(gca,'xticklabel',[],'yticklabel',[])
hold on
scatter(data3(:, 1), data3(:, 2),".");
plotBendGMM(charGMM3,C3,T3,Q3, [0 .8 0], 4);
xlim([-2,2])
ylim([-1,2])
arrowAxes(gca)
hold off
ax=gca;
exportgraphics(ax,'fig2c.png','Resolution',600)









