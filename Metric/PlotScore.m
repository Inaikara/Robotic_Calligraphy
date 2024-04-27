clc
clear
close all



Data = importdata("score.csv");
score=Data.data(:,[2,3,4]);
metric=Data.textdata;
type=["GMM";"GMM+PA";"FGMM+PA"];

figure
t=tiledlayout(3,5);
t.TileSpacing = 'compact';
t.Padding = 'compact';
%% 越大越好
for i=1:10
    nexttile
    bar(metric(i),score(i,:),1);
    ylim([0.95*score(i,1) 1.01*score(i,3)])
    ylabel("Score")
end

%% 越小越好
for i=11:15
    nexttile
    bar(metric(i),score(i,:),1);
    ylim([0.95*score(i,3) 1.01*score(i,1)])
    ylabel("Score")
end
    L=legend(type);
    L.Location="northeastoutside";

