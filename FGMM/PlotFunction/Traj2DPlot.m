function [] = Traj2DPlot(data,componentOrder,trajectory)
%Traj2DPlot 2D轨迹画图
%   此处显示详细说明
figure;
plot(data(:,1),data(:,2),'.');
hold on
for n=1:length(unique(componentOrder(:,1)))
    plot(trajectory(n*3-1,:),trajectory(n*3,:), 'lineWidth', 3);
end
hold off
end