%% START
clc
clear
close all

%% 生成二维高斯分布点
%设置渐变色：figure => 编辑 => 图形属性
%去掉网格,并使之光滑：surf(X, Y, Z); shading interp;
%设置坐标轴宽度：调整linewidth属性对应值


% 绘制二维高斯曲面
% 公式： p(z) = exp(-(z-u)^2/(2*d^2)/(sqrt(2*pi)*d)
% x y 变量
X = 0 : 1 : 100;
Y = 0 : 1 : 100;

% 方差
d02= 1000;
cc = 50;

% 均值(25, 25)
Z = zeros(101, 101);
for row = 1 : 1 : 101
    for col = 1 : 1 : 101
        Z(row, col) = (X(row) - cc) .* (X(row)-cc) + (Y(col) - cc) .* (Y(col) - cc);
    end
end

Z = -Z/(2*d02);

Z = exp(Z) / (sqrt(2*pi) * sqrt(d02));
% 显示高斯曲面
p1=surf(X, Y, Z);
color(:,:,1)=ones(length(X))*0.28;
color(:,:,2)=ones(length(X))*0.44;
color(:,:,3)=ones(length(X))*0.58;
p1.CData=color;
p1.FaceAlpha = 'interp';
p1.AlphaData=Z;

% 去掉图像上的网格，即使之光滑
shading interp 

