clc
clear
close all



Data = importdata("score.csv");
score=Data.data(:,[2,3,4]);
metric=Data.textdata;
type=["GMM";"GMM+PA";"FGMM+PA"];

figure(Color="white")
t=tiledlayout(3,5,TileSpacing='compact',Padding = 'compact');
%% 越大越好
for i=1:10
    nexttile
    bar(metric(i),score(i,:),1);
    ylim([0.95*score(i,1) 1.01*score(i,3)])
end

%% 越小越好
for i=11:15
    nexttile
    bar(metric(i),score(i,:),1);
    ylim([0.95*score(i,3) 1.01*score(i,1)])
end

L=legend(type);
L.Layout.Tile = 'south';%设置legend位置
L.Orientation = 'horizontal';%设置legend里的元素横向排列
