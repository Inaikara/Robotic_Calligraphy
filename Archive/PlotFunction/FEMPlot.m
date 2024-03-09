function [] = FEMPlot(Data,gm,C,T,Q)
%TESTFEM 此处显示有关此函数的摘要
%   此处显示详细说明
% 画图
figure(1);
hold on
plotBendGMM(gm.mu', gm.Sigma, C,T,Q,[rand(),rand(),rand()], 1);
gscatter(Data(1,:),Data(2,:));
axis equal
hold off
end