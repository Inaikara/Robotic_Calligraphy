%% START
clc
clear
close all
addpath(genpath('.\FGMM'));
addpath(genpath('.\UtilFunction'));

%% 生成高斯分布的样本点
n=200;
Sigma = [0.5, 0; 0, 0.1];
data1 = mvnrnd([0;0], Sigma, 500);
az=-45;
ez=45;
%% 生成椭圆
nbDrawingSeg = 40;
t = linspace(-pi, pi, nbDrawingSeg)';
stdev = sqrtm(5.0.*Sigma);
Xt1 = [cos(t) sin(t)] * real(stdev) + repmat([0,0],nbDrawingSeg,1);
%% 生成高斯分布1
X=linspace(-5,5,n);
Y=linspace(-5,5,n);
Z = zeros(n);
for i = 1 : n
    for j = 1 : n
        Z(j, i) = GaussPDF([X(i);Y(j)], [0;0], Sigma);
    end
end
%% 画图fig2.c
figure
hold on
% 画高斯模型
p1=surf(X, Y, Z);
color(:,:,1)=ones(n)*0.28;
color(:,:,2)=ones(n)*0.44;
color(:,:,3)=ones(n)*0.58;
p1.CData=color;
p1.FaceAlpha = 'interp';
p1.AlphaData=Z;
% 画样本点
plot(data1(:,1),data1(:,2),'.')
% 设置
xlim([-2,2])
ylim([-2,2])
grid on
shading interp
% 画椭圆
patch(Xt1(:,1), Xt1(:,2),[0.82,0.86,0.89],'EdgeColor', [0.10,0.29,0.48],'FaceAlpha',0.2,'EdgeAlpha',0);
hold off
view(az,ez)
exportgraphics(gca,'fig2c.png','Resolution',600)

%% 生成弯曲的样本点
C=[0.5,0];
data2=BendPoint(data1,C,[0,0],eye(2));
Z = zeros(n);
%% 生成椭圆
Xt2 =BendPoint(Xt1,C,[0,0],eye(2));
%% 生成高斯模型2
for i = 1 : n
    for j = 1 : n
        tmp = Data2NewData([X(i);Y(j)],C,[0,0],eye(2));
        Z(j, i) = GaussPDF(tmp, [0;0], Sigma);
    end
end

%% 画图fig2.b
figure
hold on
% 画高斯模型
p2=surf(X, Y, Z);
color(:,:,1)=ones(n)*0.28;
color(:,:,2)=ones(n)*0.44;
color(:,:,3)=ones(n)*0.58;
p2.CData=color;
p2.FaceAlpha = 'interp';
p2.AlphaData=Z;
% 画样本点
plot(data2(:,1),data2(:,2),'.')
% 设置
xlim([-2,2])
ylim([-2,2])
grid on
shading interp 
% 画椭圆
patch(Xt2(:,1), Xt2(:,2),[0.82,0.86,0.89],'EdgeColor', [0.10,0.29,0.48],'FaceAlpha',0.2,'EdgeAlpha',0);
hold off
view(az,ez)
exportgraphics(gca,'fig2b.png','Resolution',600)
%% 生成平移旋转后的数据
theta=deg2rad(45);
T=[0.7,-0.7];
Q=[cos(theta),-sin(theta);sin(theta),cos(theta)];
data3=data2*Q'+T;
%% 生成椭圆
Xt3=Xt2*Q'+T;
%% 生成高斯数据
Z = zeros(n);
for i = 1 : n
    for j = 1 : n
        tmp=([X(i),Y(j)]-T)*Q;
        tmp = Data2NewData(tmp',C,[0,0],eye(2));
        Z(j, i) = GaussPDF(tmp, [0;0], Sigma);
    end
end


%% 画图fig2.a
figure
hold on

% 画高斯模型
p2=surf(X, Y, Z);
color(:,:,1)=ones(n)*0.28;
color(:,:,2)=ones(n)*0.44;
color(:,:,3)=ones(n)*0.58;
p2.CData=color;
p2.FaceAlpha = 'interp';
p2.AlphaData=Z;
% 画样本点
plot(data3(:,1),data3(:,2),'.')
% 设置
xlim([-2,2])
ylim([-2,2])
grid on
shading interp 
% 画椭圆
patch(Xt3(:,1), Xt3(:,2),[0.82,0.86,0.89],'EdgeColor', [0.10,0.29,0.48],'FaceAlpha',0.2,'EdgeAlpha',0);
hold off
view(az,ez)
exportgraphics(gca,'fig2a.png','Resolution',600)

