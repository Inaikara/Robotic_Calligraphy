import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# 创建球体的参数
r = 1  # 半径
phi = np.linspace(0, np.pi, 100)  # 极角
theta = np.linspace(0, 2 * np.pi, 100)  # 方位角
phi, theta = np.meshgrid(phi, theta)  # 构建网格

# 球体的笛卡尔坐标
x = 0.5 * np.sin(phi) * np.cos(theta)
y = r * np.sin(phi) * np.sin(theta)
z = r * np.cos(phi)

# 创建3D图形
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

# 绘制初始球体
ax.plot_surface(x, y, z, color='b', alpha=0.5)

# 绕z轴旋转角度（单位为弧度）
angle = np.pi / 4  # 旋转45度
cos_theta = np.cos(angle)
sin_theta = np.sin(angle)

# 计算旋转后的坐标
x_rot = cos_theta * x + sin_theta * y
y_rot = -sin_theta * x + cos_theta * y
z_rot = z

# 清除原始球体
ax.clear()

# 绘制旋转后的球体
ax.plot_surface(x_rot, y_rot, z_rot, color='r', alpha=0.5)
plt.show()
