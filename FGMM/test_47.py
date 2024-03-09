import numpy as np
import matplotlib.pyplot as plt
# def sort_by_first_column_inplace(arr):
#     # 使用 sort() 方法，传入 key 参数来指定排序依据为第一列
#     arr.sort(key=lambda x: x[0])
#     return arr

# # 示例用法

# # arr = [[3, 2], [1, 4], [2, 3], [4, 1]]
# # sort_by_first_column_inplace(arr)
# # print(arr)

# # a = np.array([[1,5,3],[4,5,6]]).T
# # print(a.shape)
# # a = list(a)
# # sort_by_first_column_inplace(a)
# # print(np.array(a))
# # a = np.array(a)
# # print(a[1,1])
# i = 1
# plt.plot([1,2],[2,4],linewidth=3)
# filename = 'fig'+str(i)+'.png'
# plt.savefig(filename)
# plt.show(

# 创建两个示例数组
x = np.array([1, 2, 3, 4, 5])  # 数组 x
y = np.array([5, 4, 3, 2, 1])  # 数组 y

# 计算协方差
covariance = np.cov(x, y)  # 返回协方差矩阵，取其第一行第二列的元素

print("协方差：", covariance)
