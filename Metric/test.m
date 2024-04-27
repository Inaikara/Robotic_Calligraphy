% 数据
data = [20, 30, 40, 50];

% 设置不同的偏移量
offsets = [1, 0, 1, 0];

% 绘制柱状图，设置偏移量
bar(data, 'XOffset', offsets);

% 添加标题和标签
title('柱状图示例');
xlabel('类别');
ylabel('值');

% 显示图形
grid on;
