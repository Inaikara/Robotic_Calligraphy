function [y1,y2] = FindProjection(data,C)
%FINDPROJECTION 此处显示有关此函数的摘要
%   此处显示详细说明

% solve the cubic function
y1=roots([2*C^2,0,1-2*C*data(2),-data(1)]);
y1=y1(imag(y1)==0);
y2=C*y1.*y1;

end