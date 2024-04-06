function [strokelength] = GetThickness(data,dataL,dataR,trajZ_old)
%GETTHICKNESS 计算两个时间点之间最厚距离
%   输入
% data列数据
a=(dataR(2)-dataL(2))/(dataR(1)-dataL(1));
b=dataR(2)-a*dataR(1);
thickness=zeros(size(data,1),1);
for i=1:size(data,1)
    y1=data(i,1);
    y2=data(i,2);
    r1=(y1+a*y2-a*b)/(a^2+1);
    r2=a*r1+b;
    % 判断正负
    if a*y1+b<=y2 
        thickness(i)=pdist([[r1,r2];[y1,y2]],'euclidean');
    else
        thickness(i)=-pdist([[r1,r2];[y1,y2]],'euclidean');
    end
end
    
strokelength=(max(thickness)-min(thickness))/2;

if isempty(strokelength)
    strokelength=trajZ_old;
end

end