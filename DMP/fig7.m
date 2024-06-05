clc
clear
close all
%% 加载DMP数据
load DMPResult.mat
t=1:1000;
x1=track(1,:);
x2=track(4,:);
x3=track(7,:);
x4=track(10,:);
y1=track(2,:);
y2=track(5,:);
y3=track(8,:);
y4=track(11,:);
z1=track(3,:);
z2=track(6,:);
z3=track(9,:);
z4=track(12,:);
figure
hold on
plot(t,x1)
plot(t,x2)
plot(t,x3)
plot(t,x4)
hold off
 