%% START
clc
clear
close all

n=200;
Sigma = [1, 0; 0, 0.1];
%% 生成椭圆
p1=figure;
hold on
for i=0:15:45
    theta=deg2rad(i);
    T=[0,0];
    Q=[cos(theta),-sin(theta);sin(theta),cos(theta)];
    NewSigma=Q*Sigma*Q';
    nbDrawingSeg = 40;
    t = linspace(-pi, pi, nbDrawingSeg)';
    stdev = sqrtm(5.0.*NewSigma);
    Xt1 = [cos(t) sin(t)] * real(stdev) + repmat([0,0],nbDrawingSeg,1);
    if i==45
        patch(Xt1(:,1), Xt1(:,2),[0.46,0.58,0.69],'EdgeColor', [0.46,0.58,0.69],'FaceAlpha',0.8,'EdgeAlpha',0.5);
    else
        patch(Xt1(:,1), Xt1(:,2),[0.46,0.58,0.69],'EdgeColor', [0.46,0.58,0.69],'FaceAlpha',0.2,'EdgeAlpha',0.5);
    end
end
hold off
axis equal
axis off
exportgraphics(p1,'.\Figure\fig5.png','Resolution',600)








