%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\UtilFunction'));% 工具库

%% 加载FGMM数据
fgmmstroke=[2,5,7,6,3];
gmmstroke=[3,7,2,8,4];
load ./Result/工作区/水FGMM.mat
Mu=charGMM.mu';
Sigma=charGMM.Sigma;
load('./Result/工作区/水GMM.mat','charGMM');
Mu(:,fgmmstroke)=charGMM.mu(gmmstroke,:)';
Sigma(:,:,fgmmstroke)=charGMM.Sigma(:,:,gmmstroke);
nbData=size(Mu,2);
nbDrawingSeg = 50;
t = linspace(-pi, pi, nbDrawingSeg)';

%% 画图6b
p1=figure;
hold on
color=[1,0.65,0;1,0.39,0.38;0,0,0;0.74,0.31,0.56;0,0.25,0.36];
for i=[1,2,4,5]
    plot(data(data(:,4)==i,1),data(data(:,4)==i,2),'.','Color',color(i,:))
    % plot(stroke(stroke(:,4)==i,1),stroke(stroke(:,4)==i,2),'.','MarkerSize',20,'Color',color(i,:))
end
% color=[1,0.65,0;1,0.39,0.38;0.74,0.31,0.56;0,0.25,0.36];
for j=1:nbData
    idx=componentOrder(:,2)==j;
    idx=componentOrder(idx,1);
    stdev = sqrtm(3.0.*Sigma(:,:,j));
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    if abs(C(j,:))>=1e-5
        X=BendPoint(X,C(j,:),T(j,:),Q(:,:,j));
    end
    patch(X(:,1), X(:,2), color(idx,:), 'lineWidth', 2, 'EdgeColor', color(idx,:),'FaceAlpha',.8,'EdgeAlpha',.8);
    % plot(Mu(1,:), Mu(2,:), 'x', 'lineWidth', 2, 'color', color);
end
axis equal
axis off
hold off
exportgraphics(p1,'fig6c.png','Resolution',600)

%% 画图6a
p1=figure;
hold on
color=[1,0.65,0;1,0.39,0.38;0,0,0;0.74,0.31,0.56;0,0.25,0.36];
for i=[1,2,4,5]
    plot(data(data(:,4)==i,1),data(data(:,4)==i,2),'.','Color',color(i,:))
    plot(stroke(stroke(:,4)==i,1),stroke(stroke(:,4)==i,2),'.','MarkerSize',20,'Color',color(i,:))
end
axis equal
axis off
hold off
exportgraphics(p1,'fig6a.png','Resolution',600)

%% 画图6c
load('./Result/工作区/水GMM.mat');
Mu=charGMM.mu';
Sigma=charGMM.Sigma;
nbData=size(Mu,2);
nbDrawingSeg = 50;
t = linspace(-pi, pi, nbDrawingSeg)';
p1=figure;
hold on
color=[1,0.65,0;1,0.39,0.38;0,0,0;0.74,0.31,0.56;0,0.25,0.36];
for i=[1,2,4,5]
    plot(data(data(:,4)==i,1),data(data(:,4)==i,2),'.','Color',color(i,:))
    % plot(stroke(stroke(:,4)==i,1),stroke(stroke(:,4)==i,2),'.','MarkerSize',20,'Color',color(i,:))
end
% color=[1,0.65,0;1,0.39,0.38;0.74,0.31,0.56;0,0.25,0.36];
for j=1:nbData
    idx=componentOrder(:,2)==j;
    idx=componentOrder(idx,1);
    stdev = sqrtm(3.0.*Sigma(:,:,j));
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    if abs(C(j,:))>=1e-5
        X=BendPoint(X,C(j,:),T(j,:),Q(:,:,j));
    end
    patch(X(:,1), X(:,2), color(idx,:), 'lineWidth', 2, 'EdgeColor', color(idx,:),'FaceAlpha',.8,'EdgeAlpha',.8);
    % plot(Mu(1,:), Mu(2,:), 'x', 'lineWidth', 2, 'color', color);
end
axis equal
axis off
hold off
exportgraphics(p1,'fig6b.png','Resolution',600)

































