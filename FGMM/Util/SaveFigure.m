function [] = SaveFigure(h,n,y)
% h,name,y

%保存到毕业论文文件夹！！
name=strcat('D:\Windows\OneDrive - mail.scut.edu.cn\文档\Project\课程设计_毕业设计\thesis\fig\',n);
namefig=strcat('D:\Windows\OneDrive - mail.scut.edu.cn\文档\Project\课程设计_毕业设计\thesis\fig\MatlabFig\',n);
set(h,'PaperPositionMode','manual');
set(h,'PaperUnits','centimeters');
set(h,'PaperPosition',[0,0,15,y]);%恰当选择尺寸
set(h.CurrentAxes, 'FontSize', 10.5,'LabelFontSizeMultiplier', 1,'TitleFontSizeMultiplier',1,'LineWidth',0.5)
print(h,name,'-r1000','-dpng');%-r600可改为300dpi分辨率
saveas(h,namefig)
end


