clc
clear
close all
addpath(genpath('.\FGMM')); % 高斯混合模型算法库
%% 加载数据
load hald
Data=ingredients(:,[1,3]);

%% test PCA2LSTM
[C,T,Q] = PCA2LSFM(Data);

%% test FindProjection
figure
hold on
fplot(@(x) C(1)*x^2+C(2));
axis equal
data=Q*(Data-repmat(T,[size(Data,1),1]))';
for i=1:size(Data,1)
    color=[rand(),rand(),rand()];
    plot(data(1,i),data(2,i),'*','Color',color)
    [y1,y2]=FindProjection(data(:,i),C);
    plot(y1,y2,'o','Color',color);
end
hold off
%% test Data2NewData
NewData = Data2NewData(Data',C,T,Q);
figure()
plot(NewData(1,:),NewData(2,:),'*')


%% END
rmpath(genpath('.\FGMM')); % 高斯混合模型算法库
