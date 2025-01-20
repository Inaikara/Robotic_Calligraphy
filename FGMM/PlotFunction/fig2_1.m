%% START
clc
clear
close all
addpath(genpath('.\FGMM'));
addpath(genpath('.\UtilFunction'));

data=[1,3];
C=[0.5,0];
% ax^2+b
a=C(1);
b=C(2);
% solve the cubic function
y1=roots([2*a^2,0,1-2*a*data(2)+2*a*b,-data(1)]);
y1=y1(imag(y1)==0);
y2=a*y1.*y1+b;

t=linspace(-5,5,1000);
t2=linspace(0,y1(1),500);


l=figure;
hold on
% 二次函数
plot(t,C(1)*t.*t+C(2),'LineWidth',2,'Color',[0.00,0.25,0.36])

% 投影线
for i=1:length(y1)
    plot([data(1),y1(i)],[data(2),y2(i)],'--','LineWidth',2,'Color',[1,0.65,0.00])
end

% L1距离
l1=plot(t2,C(1)*t2.*t2+C(2),'LineWidth',2,'Color',[1,0.39,0.38]);

% L2距离
l2=plot([data(1),y1(1)],[data(2),y2(1)],'LineWidth',2,'Color',[1,0.65,0.00]);

% 样本点
p1=plot(data(1),data(2),'.','MarkerSize',30,'Color',[1,0.65,0.00]);

% 二次曲线上的点
p2=plot(y1,y2,'.','MarkerSize',30,'Color',[1,0.39,0.38]);


h=legend([p2 p1 l1 l2],{'Projection Point','Sample Point','$l_1$','$l_2$'},'NumColumns',2);
set(h,'Interpreter','latex','FontName','Times New Roman','FontSize',18,'Location','north')
gca.XAxislocation='origin';
gca.YAxislocation='origin';
xlim([-2.5,2.5])
ylim([-0.5,4.5])
axis equal
axis off
hold off

exportgraphics(l,'fig2d.png','Resolution',600)



