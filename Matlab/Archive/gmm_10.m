% 原始GMM拟合+PCA+GMR
% 众数查找
% 精简
clc
clear all
close all



%% 笔画分割
% 组件数
n_clusters = 8;

% 读图
I = rgb2gray(imread('../sample/shui.jpg'));
I=imresize(I,0.5);

%笔画提取
stroke=FindCurve(I);

% 预处理
I = imbinarize(I);
I=~I;

% 查找字迹点坐标
[X(:,1),X(:,2)]=find(I);
% X=X';

%初始化坐标
[Pi, Mu, Sigma]=EM_init_kmeans(X', n_clusters);

%EM算法
[Pi, Mu, Sigma] = EM(X', Pi, Mu, Sigma);

%根据参数生成模型
gm=gmdistribution(Mu', Sigma,Pi');

%对各个点进行聚类
idx = cluster(gm,X);

% 笔画成分匹配
% new合并了点勾
[com2str ,com2str_new]= impcom2str(stroke,gm);

%% GMR回归
trajNum=1001;% 步数
strokeNum=size(unique(com2str_new(1,:)),2);%笔画数
trajData=zeros(3*strokeNum,trajNum);%轨迹
trajSigma=zeros(strokeNum,trajNum);%粗细
% trajTime=zeros(strokeNum,trajNum);



for n=unique(com2str_new(1,:))
    %寻找对应笔画n的component
    i=com2str_new(2,com2str_new(1,:)==n);
    %对每个component进行时间编码
    X_t=[];
    t=0;
    for j=i
        X_n=X(:,idx==j);
        X_n=X_n';
        %主成分上的投影认为是时间序列
        [~,X_n(:,[3,4]),~]=pca(X_n);
        %取整
        X_n(:,3)=round(X_n(:,3));
        %按时间排序
        X_n=sortrows(X_n,3);
        %判断方向
        stroke_temp=stroke(2,stroke(3,:)==n);
        if sign(X_n(1,2)-X_n(end,2)~=sign(stroke_temp(1,1)-stroke_temp(1,end)))
            X_n(:,3)=flip(X_n(:,3));
            X_n=sortrows(X_n,3);
        end
        %归零
        X_n(:,3)=X_n(:,3)-X_n(1,3)+t;
        %拼接
        X_t=[X_t;[X_n(:,3),X_n(:,[1,2])]];
        %更新末端时间
        t=X_t(end,1);
    end
    %对笔画进行建模
    X_t=X_t';
    [Pi_t, Mu_t, Sigma_t]=EM_init_kmeans(X_t,size(i,2)*3);
    [Pi_t, Mu_t, Sigma_t] = EM(X_t, Pi_t, Mu_t, Sigma_t);
    %对笔画做高斯回归
    trajData(n*3-2,:)= linspace(min(X_t(1,:)), max(X_t(1,:)), trajNum);
    [trajData(n*3-1:n*3,:), ~] = GMR(Pi_t, Mu_t, Sigma_t, trajData(n*3-2,:),1,2:3);
    %笔画粗细判断
    for k=1:trajNum
        temp=find(X_t(1,:)==round(trajData(n*3-2,k)));
        trajSigma(n,k)=size(temp,2);
    end
end

%% 数据可视化处理
% 粗细处理
trajSigma=trajSigma/2;

% 中心处理
[trajData,X]=centralize(trajData,X);

%% 保存数据
save('../sample/trajData.mat','trajData');
save('../sample/trajSigma.mat','trajSigma');

%% 画图 轨迹
figure;
hold on
plot(X(1,:),X(2,:),'.');
for n=1:strokeNum
plot3(trajData(n*3-1,:),trajData(n*3,:),-trajSigma(n,:), 'lineWidth', 3);
end
axis([min(X(1,:))-0.01 max(X(1,:))+0.01 min(X(2,:))-0.01 max(X(2,:))+0.01]);
xlabel('x_1','fontsize',16); ylabel('x_2','fontsize',16);
grid on
hold off   

%% 画图 重构
figure;
t = 0 : .1 : 2 * pi;
hold on;
for n=1:strokeNum
    for k=1:trajNum
        i = trajSigma(n,k) * cos(t) + trajData(n*3-1,k);
        j = trajSigma(n,k) * sin(t) + trajData(n*3,k);
        patch(i, j, 'black','LineStyle', 'none'); %// plot filled circle with transparency
    end
end
%gscatter(X(1,:),X(2,:),idx);
axis([min(X(1,:))-0.01 max(X(1,:))+0.01 min(X(2,:))-0.01 max(X(2,:))+0.01]);
xlabel('x_1','fontsize',16); ylabel('x_2','fontsize',16);
grid on
hold off
    
%% END



