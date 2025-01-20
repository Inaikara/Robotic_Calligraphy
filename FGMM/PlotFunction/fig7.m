clear
close all
%% 加载DMP数据
load ./Data/DMPResult.mat
load ./Data/Result.mat
load ./Data/水FGMM.mat
h1=50*ones([1,1841]);
h2=25*ones([1,1000]);

%% 变量
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
dx1=dmptrack(1,:);
dx2=dmptrack(4,:);
dx3=dmptrack(7,:);
dx4=dmptrack(10,:);
dy1=dmptrack(2,:);
dy2=dmptrack(5,:);
dy3=dmptrack(8,:);
dy4=dmptrack(11,:);
dz1=dmptrack(3,:);
dz2=dmptrack(6,:);
dz3=dmptrack(9,:);
dz4=dmptrack(12,:);
%% color
red=[1,0.39,0.38];
yellow=[1,0.65,0.0];
magneta=[0.74,0.31,0.56];
purple=[0.35,0.31,0.55];
dark=[0,0.25,0.36];

%% 
figure
hold on
% demon=plot3(x1,y1,h1,':','Color',red,'LineWidth',2);
% plot3(x2,y2,h1,':','Color',red,'LineWidth',2)
% plot3(x3,y3,h1,':','Color',red,'LineWidth',2)
% plot3(x4,y4,h1,':','Color',red,'LineWidth',2)
demon=plot3(data(:,1)-50.9643,data(:,2)-53.0916,h1,':','Color',red,'MarkerSize',2);
repro1=plot3(x1,y1,h2+25,'-','Color',red,'LineWidth',2);
plot3(x2,y2,h2+25,'-','Color',red,'LineWidth',2)
plot3(x3,y3,h2+25,'-','Color',red,'LineWidth',2)
plot3(x4,y4,h2+25,'-','Color',red,'LineWidth',2)


repro=plot3(dx1,dy1,h2,'-','Color',magneta,'LineWidth',2);
plot3(dx2,dy2,h2,'-','Color',magneta,'LineWidth',2)
plot3(dx3,dy3,h2,'-','Color',magneta,'LineWidth',2)
plot3(dx4,dy4,h2,'-','Color',magneta,'LineWidth',2)

% 透视
plot3([x1(1),0],[y1(1),0],[h1(1),0],'--','Color',yellow,'LineWidth',2)
plot3([x2(1),0],[y2(1),0],[h1(1),0],'--','Color',yellow,'LineWidth',2)
plot3([x3(1),0],[y3(1),0],[h1(1),0],'--','Color',yellow,'LineWidth',2)
plot3([x4(1),0],[y4(1),0],[h1(1),0],'--','Color',yellow,'LineWidth',2)
plot3([x1(end),0],[y1(end),0],[h1(end),0],'--','Color',yellow,'LineWidth',2)
plot3([x2(end),0],[y2(end),0],[h1(end),0],'--','Color',yellow,'LineWidth',2)
plot3([x3(end),0],[y3(end),0],[h1(end),0],'--','Color',yellow,'LineWidth',2)
plot3([x4(end),0],[y4(end),0],[h1(end),0],'--','Color',yellow,'LineWidth',2)
% 透视点
plot3(x1(1),y1(1),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x2(1),y2(1),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x3(1),y3(1),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x4(1),y4(1),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x1(end),y1(end),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x2(end),y2(end),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x3(end),y3(end),h1(1),'.','Color',red,'MarkerSize',20)
plot3(x4(end),y4(end),h1(1),'.','Color',red,'MarkerSize',20)

plot3(dx1(1),dy1(1),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx2(1),dy2(1),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx3(1),dy3(1),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx4(1),dy4(1),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx1(end),dy1(end),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx2(end),dy2(end),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx3(end),dy3(end),h2(1),'.','Color',magneta,'MarkerSize',20)
plot3(dx4(end),dy4(end),h2(1),'.','Color',magneta,'MarkerSize',20)

plot3(0,0,0,'.','Color',yellow,'MarkerSize',20)
axis equal
axis off
view(60,20)
legend([demon,repro1,repro],{'Demonstraion','Reproduction (Original Size)','Reproduction (Half Size)'})
% legend('Location','south')
exportgraphics(gca,'fig7.png','Resolution',600)
















