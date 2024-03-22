function [C,T,Q] = PCA2LSFM(Data)
%PCA2LSFM 输入列数据，输出CTQ矩阵

nbData = size(Data,1);

% Translation Matrix T
T = mean(Data);

% Rotation Matrix Q
Q = pca(Data(:,[1,2]));

% Transform
Data = (Data-repmat(T,[nbData,1]))*Q;

% LSFM
y1 = Data(:,1).*Data(:,1);
y1 = [y1,ones([nbData,1])];
y2 = Data(:,2);

% Curve Parameters C
C = pinv(y1'*y1)*y1'*y2;




end