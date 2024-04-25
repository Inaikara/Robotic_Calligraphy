function [ ] = Traj3DPlot(data,componentOrder,trajectory)
%TRAJ3DPLOT 3D轨迹画图
%   此处显示详细说明
figure;
plot(data(:,1),data(:,2),'.');
hold on
for n=1:length(unique(componentOrder(:,1)))
    plot3(trajectory(n*3-1,:),trajectory(n*3,:),-trajectory(n*3-2,:), 'lineWidth', 3);
end
hold off
end