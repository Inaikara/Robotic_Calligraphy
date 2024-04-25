function [data,charGMM,C,T,Q] = ADS2NADS(data,directdata,numComponent,type)
%   ADS2NADS 将系统从自治系统转变为非自治系统的函数
%   输入：（均为列数据）
%   data:原始数据
%   direction：方向数据，指引大致方向
%   numComponent：GMM或FGMM的组件数
%   type：1为GMM，2为FGMM
%   输出：
%   data：1和2列为原始数据，3列为类别，4列为时间

%% 转变为非自治系统
if type==1
    %% GMM参数估计
    [charGMM,C,T,Q]=GenerateGMM(data, numComponent);
elseif type==2
    %% FGMM参数估计
    [charGMM,C,T,Q]=GenerateFGMM(data, numComponent);
else
    disp("type：1为GMM，2为FGMM")
end
%% FGMM聚类
data(:,3)=cluster(charGMM,data);
directdata(:,3)=cluster(charGMM,directdata);
%% PCA时间赋值
data = GetFGMMTime(data,directdata,C,T,Q);

end

