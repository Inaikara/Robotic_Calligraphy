function [y1,y2] = FindProjection(data,C)
%FINDPROJECTION 此处显示有关此函数的摘要
%   此处显示详细说明

% ax^2+b
a=C(1);
b=C(2);
% solve the cubic function
y1=roots([2*a^2,0,1-2*a*data(2)+2*a*b,-data(1)]);
y1=y1(imag(y1)==0);
y1=y1(1);% debug 存在多个投影点只取第一个
y2=a*y1.*y1+b;

end