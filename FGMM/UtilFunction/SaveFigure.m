function [] = SaveFigure(h,n,p)% 图像，文件名, 比例
%% 设定保存路径和文件名
name=strcat('.\Result\',n);
%% 设定开启控制分辨率模式
set(h,'PaperPositionMode','manual');
%% 设定单位
set(h,'PaperUnits','inches');
%% 设定图窗位置
set(h,'PaperPosition',[0,0,7.16,7.16*p]);
%% 设定坐标轴属性
set(h.CurrentAxes, 'FontSize', 10.5,'LabelFontSizeMultiplier', 1,'TitleFontSizeMultiplier',1,'LineWidth',0.5)
%% 保存为位图
print(h,name,'-r600','-dpng');
%% 保存为矢量图
% print(h,name,'-dpdf','-r0');
%% 保存为fig格式
% saveas(h,name)
end


