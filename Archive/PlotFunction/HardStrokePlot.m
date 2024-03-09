function [ ] = HardStrokePlot(charGMM,stroke)
%HARDPLOT 画出硬笔算法生成的笔画分割
%   输入charGMM，stroke
figure;
hold on
plotGMM_plot(charGMM.mu', charGMM.Sigma, [0 .8 0], 1);
gscatter(stroke(:,1),stroke(:,2),stroke(:,3));
hold off

end