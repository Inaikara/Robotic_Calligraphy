%% 说明
% LASA数据集测试用
%% 添加路径
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库

%% 选择数据集
n=3;
numComponent = 4;
%% 加载数据
names = {'Angle','BendedLine','CShape','DoubleBendedLine','GShape',...
         'heee','JShape','JShape_2','Khamesh','Leaf_1',...
         'Leaf_2','Line','LShape','NShape','PShape',...
         'RShape','Saeghe','Sharpc','Sine','Snake',...
         'Spoon','Sshape','Trapezoid','Worm','WShape','Zshape',...
         'Multi_Models_1','Multi_Models_2','Multi_Models_3','Multi_Models_4'};
% n = input('\nType the number of the model you wish to load [type 0 to exit]: ');
fprintf('\n\n')
if n<0 || n>30
    disp('Wrong model number!')
    disp('Please try again and type a number between 1-30.')
elseif n == 0
    return
else
    load(['LASA/DataSet/' names{n}],'demos','dt') %loading the model
end

data=[];
for i=1:length(demos)
    data=[data,demos{i}.pos];
end

% % 数据画图
% figure
% plot(data(1,:),data(2,:),'x')

%% FGMM参数估计
[charGMM,C,T,Q]=GenerateFGMM(data', numComponent);

%% GMR
%% 画图
figure;
hold on
plotBendGMM(charGMM,C,T,Q, [0 .8 0], 1);
gscatter(data(1,:),data(2,:));
hold off

%% 删除路径
rmpath(genpath('.\FindCurve'));
rmpath(genpath('.\FGMM'));
rmpath(genpath('.\PlotFunction'));
rmpath(genpath('.\UtilFunction'));
%% END




