clc
clear
close all
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
%% 加载数据
numComponent = 8;
img = rgb2gray(imread('input.jpg'));

%% 图像预处理
[img,data] = ImgProcess(img);


% figure
% plot(Data(:,1),Data(:,2),'*')
% axis equal

% %% 投影
% [C,T,Q] = PCA2LSFM(Data);
% NewData= GetProjectionLength(Data,C,T,Q);



% figure
% hold on
% t_data=[6,0;-6,0];
% plot(t_data(1,1),t_data(1,2),'o')
% plot(t_data(2,1),t_data(2,2),'o')
% for C=0.1:0.1:2
%     b_data=BendPoint(t_data,C);
%     plot(b_data(1,1),b_data(1,2),'o')
%     plot(b_data(2,1),b_data(2,2),'o')
%     fplot(@(x) C*x^2);
% end
% axis equal
% hold off


% %画图
% figure
% hold on
% Data = (Data-T)*Q;
% plot(Data(:,1),Data(:,2),'o')
% fplot(@(x) C*x^2);
% for i=1:size(Data,1)
%     [y1,y2]=FindProjection(Data(i,:),C);
%     plot(y1,y2,'*');
% end
% axis equal
% hold off

%% EM算法
% Data = (Data-T)*Q;
[charGMM,C,T,Q]=GenerateGMM(data, numComponent);

mu=charGMM.mu;

figure;
hold on
plotBendGMM(charGMM.mu', charGMM.Sigma, C,T,Q,[0 .8 0], 1);
gscatter(Data(:,1),Data(:,2));
axis equal
hold off


rmpath(genpath('.\FGMM')); % 高斯混合模型算法库
%%END