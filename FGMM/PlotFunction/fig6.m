clc
clear
close all
%% 加载DMP数据
load ./Data/DMPResult.mat
load ./Data/Result.mat
load ./Data/水dataNew.mat
load ./Data/水FGMM.mat
%% color
t=1:1000;
red=[1,0.39,0.38];
yellow=[1,0.65,0.0];
magneta=[0.74,0.31,0.56];
purple=[0.35,0.31,0.55];
dark=[0,0.25,0.36];
%% 变量
tmp=[1,473;474,1127;1128,1554;1555,1841];
figname=["fig6a.pdf","fig6b.pdf","fig6c.pdf","fig6d.pdf"];

for i=1:4
x1=track(3*i-2,:);
dx1=dmptrack(3*i-2,:);
y1=track(3*i-2+1,:);
dy1=dmptrack(3*i-2+1,:);

%% 画图
figure
fig=tiledlayout(2,1);
fig.TileSpacing = 'compact';
fig.Padding = 'compact';

nexttile
hold on
dt=1000*dataNew(tmp(i,1):tmp(i,2),4)/max(dataNew(tmp(i,1):tmp(i,2),4));
% dem=plot(dt,dataNew(tmp(i,1):tmp(i,2),1)-50.9643,'Color',[red,0.3]);
% dem=scatter(dt,dataNew(tmp(i,1):tmp(i,2),1)-50.9643,'filled','CData',red,'SizeData',10,'MarkerFaceAlpha',0.3);
rep1=plot(t,x1,'-','Color',red,'LineWidth',2);
rep5=plot(t,dx1,'-','Color',magneta,'LineWidth',2);
ylabel("X-axis")
xticklabels='None';
xtick='None';
hold off

nexttile
hold on
% plot(dt,dataNew(tmp(i,1):tmp(i,2),2)-53.0916,'Color',[red,0.3]);
% scatter(dt,dataNew(tmp(i,1):tmp(i,2),2)-53.0916,'filled','CData',red,'SizeData',10,'MarkerFaceAlpha',0.3);
plot(t,y1,'-','Color',red,'LineWidth',2)
plot(t,dy1,'-','Color',magneta,'LineWidth',2)
xlabel("Time (step)")
ylabel("Y-axis")
hold off

set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.3]);%figture位置，最下角，宽高
% set (gca,'position',[0.1,0.1,0.8,0.8] );%axis位置，最下角，宽高
legend([rep1,rep5],{'Reproduction (Original Size)','Reproduction (Half Size)'},Location="northwest")
exportgraphics(fig,figname(i),'ContentType','vector')
end


 