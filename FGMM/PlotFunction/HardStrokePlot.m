function [ ] = HardStrokePlot(charGMM,C,T,Q,stroke)
%HARDPLOT 画出硬笔算法生成的笔画分割
%   输入charGMM，stroke
figure;
hold on
plotBendGMM(charGMM,C,T,Q, [0 .8 0], 1);
gscatter(stroke(:,1),stroke(:,2),stroke(:,3));
hold off

end