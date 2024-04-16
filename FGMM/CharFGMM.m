%% 说明
% 修改AddTime和GenerateGMM至AddFTime和GenerateFGMM可以切换模式
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

%% 不同字体
% 水
numComponent = 7;
img = rgb2gray(imread('./Result/水.jpg'));

% % 上 
% numComponent = 5;
% img = rgb2gray(imread('./Result/上.jpg'));

% % 下
% numComponent = 4;
% img = rgb2gray(imread('./Result/下.jpg'));

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

%% 硬笔笔画
HardStrokePlot(charGMM,stroke,C,T,Q)

%% 软笔笔画
SoftStrokePlot(charGMM,data,C,T,Q)

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));
%% END