%% START
clc
clear
close all
addpath(genpath('.\FindCurve')); % 硬笔笔画算法库
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
addpath(genpath('.\UtilFunction'));% 工具库

%% 加载FGMM数据
load ./Data/水FGMM.mat
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
load ./Data/水GMM.mat
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
color=["k";"k";"k";"k"];
% color=[1,0.65,0;1,0.39,0.38;0.74,0.31,0.56;0,0.25,0.36];
clc
close all
figure
hold on
for i=1:4
    x=trajectory(2*i-1,:)-50.9643;
    y=trajectory(2*i,:)-53.0916;
    z=zeros([1,1000]);
    for j=1:1000
        [R,D]=eig(trajthick(2*i-1:2*i,:,j));
        z(j)=max(D(1,1),D(2,2));
    end
    [z,~] = envelope(z);
    z=medfilt1(z,2);
    z=-0.2*z+240;
    plot3(x,y,z,'LineWidth',1,'Color',color(i,:))
    sp=plot3(x(1),y(1),z(1),'hexagram','MarkerSize',5,'MarkerFaceColor',"k",'MarkerEdgeColor',"k");
    plot3(x(1),y(1),z(1),'hexagram','MarkerSize',10,'MarkerFaceColor',color(i,:),'MarkerEdgeColor',color(i,:));
    ep=plot3(x(end),y(end),z(end),'pentagram','MarkerSize',5,'MarkerFaceColor',"k",'MarkerEdgeColor',"k");
    plot3(x(end),y(end),z(end),'pentagram','MarkerSize',10,'MarkerFaceColor',color(i,:),'MarkerEdgeColor',color(i,:));

end
% zlim([239,240])
legend([sp,ep],{'Starting Points','Ending Points'},'Location','northwest')
view(70,45)
zlabel('高度 (毫米)')
grid on
hold off
exportgraphics(gca,'以水字为例生成的运动序列.png','Resolution',600)

%% END


