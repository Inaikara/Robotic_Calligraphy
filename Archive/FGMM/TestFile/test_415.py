import numpy as np
from getdata_image import *
import matplotlib.pyplot as plt
# data = getdata_image('sigmoid.png')
# plt.scatter(data[1,:], data[0,:], c='r')
# plt.show()

# data_demo = np.loadtxt('data415_1.txt',delimiter=',').T
# len = 20
# data = []
# for i in range(int(data_demo.shape[1]/len)):
#     data.append([data_demo[0,i*len], data_demo[1,i*len]])
# data = np.array(data).T
# data[:, [0, 1]] = data[:, [1, 0]]
# # data[1, :] = np.flip(data[1, :])
# plt.scatter(data[0,:], data[1,:])
# Data = getdata_image('sigmoid.png')
# plt.plot(Data[0,:], Data[1,:])
# plt.show()
# print(data.shape)

# data = np.loadtxt('data2.txt',delimiter=',')
# data = data[0:2, :]
# plt.scatter(data[0,:], data[1,:])
# plt.show()

data = np.loadtxt('data2.txt',delimiter=',')
Data = data[0:2,:]
Data[0,:] += 10
Data[1,:] += 0.08
Data[1,:] *= 1000

plt.scatter(Data[0,:], Data[1,:], c='r')

Data2 = np.loadtxt('data416_1.txt', delimiter=',').T
print(Data2.shape)
plt.scatter(Data2[0,:], Data2[1,:])
plt.show()