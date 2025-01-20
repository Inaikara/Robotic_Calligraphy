clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\PlotFunction')); % 绘图库
addpath(genpath('.\UtilFunction'));% 工具库

%% 训练
step=1000;
numComponent=2;
nbDrawingSeg = 40;
img = rgb2gray(imread('na.jpg'));
[img,data] = ImgProcess(img);
stroke=FindCurve(img,5);
stroke = StrokeOptimize(stroke);
[charGMM,C,T,Q]=GenerateFGMM(data, numComponent);
[data,stroke,componentOrder]= AddStroke(data,stroke,charGMM);
Mu=charGMM.mu';
Sigma=charGMM.Sigma;
strokedata=data(data(:,4)==1,[1,2,3]);
strokedirect=stroke(stroke(:,4)==1,[1,2,3]);
strokedata = GetFGMMTime(strokedata,strokedirect,C,T,Q);
[stroketrajectory,stroketrajsigma,stroketrajthick] = GetGMRTraj(strokedata(:,[1,2,4,5]),numComponent,step);

%% fig3a FGMM过程
color=[1,0.39,0.38;0.35,0.31,0.55];
p1=figure;
hold on
% 样本点2
p=gscatter(data(:,1),data(:,2),data(:,3),color);
for j=1:numComponent
    % 椭圆
    stdev = sqrtm(3.0.*Sigma(:,:,j));
    t = linspace(-pi, pi, nbDrawingSeg)';
    X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    if abs(C(j,:))>=1e-5
        X=BendPoint(X,C(j,:),T(j,:),Q(:,:,j));
    end
    patch(X(:,1), X(:,2), color(j,:),'EdgeColor', color(j,:),'FaceAlpha',0.5,'EdgeAlpha',0.8);
    % 抛物线
    pt=linspace(-40,40,1000)';
    pt(:,2)=C(j,1)*pt.*pt+C(j,2);
    pt=pt*Q(:,:,j)'+T(j,:);
    if j==1
        l1=plot(pt(:,1),pt(:,2),'--','lineWidth', 2, 'color', color(j,:));
    else
        l2=plot(pt(:,1),pt(:,2),'--','lineWidth', 2, 'color', color(j,:));
    end
end
h=legend([p(1) p(2) l1 l2],{'Demonstration (1st Component)','Demonstration (2nd Component)','The Principal Axis (1st Component)','The Principal Axis (2nd Component)'},'Location','northeast');
% set(h,'FontName','Times New Roman','FontSize',12)
axis off
axis equal
hold off

%% 箭头图
p2=figure;
hold on
plotGMM(stroketrajectory, stroketrajsigma,[1,0.88,0.98], 5);
for j=1:numComponent
    arrowdata=data(data(:,3)==j,[1,2]);
    arrowOri=zeros(size(arrowdata));
    % 坐标变换
    arrowdataT=(arrowdata-repmat(T(j,:),[size(arrowdata,1),1]))*Q(:,:,j);
    for i=1:size(arrowdata,1)
        [y,~] = FindProjection(arrowdataT(i,:),C(j,:));
        y=2*C(j,1)*y;
        arrowOri(i,:)=[1,y]/norm([1,y]);
        % quiver([arrowdata(i,1)],[arrowdata(i,2)],[arrowOri(i,1)],[arrowOri(i,2)])
    end
    arrowOri=arrowOri*Q(:,:,j)';
    % randomlist=randi(size(arrowdata,1),fix(size(arrowdata,1)/10),1);
    if j==1
        p(1)=quiver(arrowdata(1:2:end,1),arrowdata(1:2:end,2),arrowOri(1:2:end,1),arrowOri(1:2:end,2),'Color',color(j,:),'AutoScaleFactor',0.8);
    else
        p(2)=quiver(arrowdata(1:4:end,1),arrowdata(1:4:end,2),arrowOri(1:4:end,1),arrowOri(1:4:end,2),'Color',color(j,:),'AutoScaleFactor',0.8);
    end
    % % 椭圆
    % stdev = sqrtm(3.0.*Sigma(:,:,j));
    % t = linspace(-pi, pi, nbDrawingSeg)';
    % X = [cos(t) sin(t)] * real(stdev) + repmat(Mu(:,j)',nbDrawingSeg,1);
    % if abs(C(j,:))>=1e-5
    %     X=BendPoint(X,C(j,:),T(j,:),Q(:,:,j));
    % end
    % patch(X(:,1), X(:,2), color(j,:),'EdgeColor', color(j,:),'FaceAlpha',0.5,'EdgeAlpha',0.8);
    % GMR
end
l1=plot(stroketrajectory(1,:),stroketrajectory(2,:),'--','LineWidth',2,'Color',[0.54,0.31,0.56]);
sp=plot(stroketrajectory(1,1),stroketrajectory(2,1),'pentagram','Color',color(1,:),'MarkerSize',20,'MarkerFaceColor',color(1,:));
ep=plot(stroketrajectory(1,end),stroketrajectory(2,end),'pentagram','Color',color(2,:),'MarkerSize',20,'MarkerFaceColor',color(2,:));
h=legend([p(1) p(2) sp ep l1],{'The Time Flow (1st Component)','The Time Flow (2nd Component)','The Starting Point','The Ending Point','GMR Result'},'Location','northeast');
% set(h,'FontName','Times New Roman','FontSize',12)
axis off
axis equal
hold off
exportgraphics(p1,'fig3a.png','Resolution',600)
exportgraphics(p2,'fig3b.png','Resolution',600)

















