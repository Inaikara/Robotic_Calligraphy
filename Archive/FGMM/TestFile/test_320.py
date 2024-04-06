import numpy as np
import matplotlib.pyplot as plt

# data = np.loadtxt('data_jiu.txt', delimiter=',').T
# print(data.shape)
# Data = []
# for i in range(0, int(data.shape[1]/20)):
#     Data.append([data[0,i*20], data[1,i*20]])
# Data = np.array(Data).T
# plt.scatter(Data[0,:], Data[1,:])
# plt.show()


a = [[],[]]
b = np.array([[1,2],[3,4]])
a[0].extend([10,11])
a[1].extend(b[0,:])
# a = np.array(a)
print(a)