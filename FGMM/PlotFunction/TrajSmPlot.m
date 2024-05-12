function [ ] = TrajSmPlot(step,trajectory)
%SIMULATEPLOT 模拟轨迹画图
%   此处显示详细说明
figure;
t = 0 :  .1 : 2 * pi;
hold on
for n=1:size(trajectory,1)/3
    for k=1:step
        i = trajectory(n*3-2,k) * cos(t) + trajectory(n*3-1,k);
        j = trajectory(n*3-2,k) * sin(t) + trajectory(n*3,k);
        patch(i, j, 'FaceColor','blue','FaceAlpha',.5,'LineStyle', 'none'); %// plot filled circle with transparency
    end
end
hold off
end