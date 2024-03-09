function [ ] = SoftStrokePlot(charGMM,data)
%SOFTPLOT 画出毛笔算法生成的笔画分割
%   此处显示详细说明
figure;
hold on
plotGMM_plot(charGMM.mu', charGMM.Sigma, [0 .8 0], 1);
gscatter(data(:,1),data(:,2),data(:,4));
hold off

end