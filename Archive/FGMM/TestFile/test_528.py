import numpy as np
import matplotlib.pyplot as plt
from getdata_image import *

# data = np.loadtxt('data3.txt', delimiter=' ')
# Data = np.array(data)[:, 0:3]
# print(Data)
# data_ = [1-Data[500:1900,1], Data[500:1900,0]]
# data_ = np.array(data_)
# np.savetxt('data_ji_3.txt', data_,delimiter=' ')
# plt.scatter(data_[0,:], data_[1,:])

# plt.show()

# data = getdata_image('ji.jpg')
# plt.plot(data[0,:], data[1,:])
# plt.show()

def jianshao(data, len):
    data0 = []
    print(data.shape[1])
    for i in range(int(data.shape[1]/len)):
        data0.append([data[0, i * len], data[1, i * len]])
    return np.array(data0).T

data1 = np.loadtxt('data_ji_1.txt', delimiter=' ')
data2 = np.loadtxt('data_ji_2.txt', delimiter=' ')
data3 = np.loadtxt('data_ji_3.txt', delimiter=' ')
data1 = jianshao(data1, 20)
data2 = jianshao(data2, 20)
data3 = jianshao(data3, 20)
print(data3.shape)
# plt.scatter(data1[0,:]-0.01, data1[1,:], c='grey')
# plt.scatter(data2[0,:], data2[1,:], c='grey')
# plt.scatter(data3[0,:], data3[1,:], c='grey')
# a = np.linspace(0, data1.shape[1], data1.shape[1])
print(data1.shape)
# plt.scatter(np.linspace(1, data1.shape[1], data1.shape[1])-15, data1[0,:]-0.01, c='grey')
# plt.scatter(np.linspace(1, data2.shape[1], data2.shape[1])-5, data2[0,:], c='grey')
# plt.scatter(np.linspace(1, data3.shape[1], data3.shape[1]), data3[0,:], c='grey')
plt.xlim(0,80)
plt.scatter(np.linspace(1, data1.shape[1], data1.shape[1])-15, data1[1,:]-0.01, c='grey')
plt.scatter(np.linspace(1, data2.shape[1], data2.shape[1])-5, data2[1,:], c='grey')
plt.scatter(np.linspace(1, data3.shape[1], data3.shape[1]), data3[1,:], c='grey')
plt.show()

