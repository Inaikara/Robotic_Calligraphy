import numpy as np
from pca_initial import *
import random as rd
from EM_gene import *
from PIL import Image
from getdata_image import *
from GMR_0 import *

def sort_by_first_column_inplace(arr):
    # 使用 sort() 方法，传入 key 参数来指定排序依据为第一列
    arr.sort(key=lambda x: x[0])
    return arr


##########################-----get_data-------######################

Data = getdata_image('ji.jpg')

# data = np.loadtxt("data.txt", delimiter=',')
# data = data[:, 0:2].T
# Data = data + 50
# min_x = min(Data[0,:])
# Data[0,:] -= min_x

# data = np.loadtxt('data414.txt', delimiter=',').T
# print(data.shape)
# Data = []
# for i in range(0, int(data.shape[1]/20)):
#     Data.append([data[0,i*20], data[1,i*20]])
# Data = np.array(Data).T
# min_x = min(Data[0,:])
# Data[0,:] -= min_x

# plt.scatter(Data[0,:], Data[1,:], c='blue')

# data_demo = np.loadtxt('data415_1.txt',delimiter=',').T
# len = 20
# data = []
# for i in range(int(data_demo.shape[1]/len)):
#     data.append([data_demo[0,i*len], data_demo[1,i*len]])
# data = np.array(data).T
# data[:, [0, 1]] = data[:, [1, 0]]
# Data = data

# data = np.loadtxt('data2.txt',delimiter=',')
# Data2 = data[0:2,:]
# Data2[0,:] += 10
# Data2[1,:] += 0.08
# Data2[1,:] *= 1000

# Data3 = np.loadtxt('data416_1.txt', delimiter=',').T
# print(Data3.shape)
# len = 5
# Data = []
# for i in range(int(Data3.shape[1]/len)):
#     Data.append([Data3[0,i*len], Data3[1,i*len]])

# # Data = np.loadtxt('data.txt', delimiter=',').T
# # Data = Data[0:2,:]

# Data = np.array(Data).T
# # print(Data.shape)
# # Data[[0,1],:] = Data[[1,0],:]
# Data[1,:] = 200 - Data[1,:]
# plt.scatter(Data[0,:], Data[1,:])

# data = np.loadtxt('data_526.txt', delimiter=',').T
# len = 3
# Data = []
# for i in range(int(data.shape[1]/len)):
#     Data.append([data[0,i*len], data[1,i*len]])
# Data = np.array(Data).T

# Q_0 = np.array([[0,1],[-1,0]])
# Data = np.dot(Q_0, Data)
# Data[1,:] += 350
# Data = data[0:2,:]
plt.scatter(Data[0,:], Data[1,:])
plt.show()
#########################------initial-------#######################

nb_states = 5
theta, Data_id = PCA_init(Data, nb_states)
init_C = theta[2]
init_Q = theta[3]
init_T = theta[4]

#######################-------EM-----------##########################

print(theta[2], 'init_C')
b = theta[2].copy()
a = EM(Data, theta, nb_states, Data_id, 2, 1)
Priors = a[0]
Mu = a[1]
Sigma = a[2]
C = a[3]
Q = a[4]
T = a[5]

#####################----------plot--------############################
X = Data[0, :]
print(X.mean(axis=0), 'X')
print(C, 'C')
print(init_C, 'init_C')
print(Q, 'Q')
print(init_Q, 'init_Q')
print(T, 'T')
print(init_T, 'init_T')
Data_id = np.array(Data_id)
print(Data_id.shape, 'Data_id')
print(a[2], 'Sigma')
plt.scatter(Data[0,:], Data[1,:], c='blue', label='观测数据点')
for i in range(0, nb_states):
    idtmp = np.nonzero(Data_id == i)
    idtmp = list(idtmp)
    idtmp = np.reshape(idtmp, (np.size(idtmp)))
    data_temp = Data[:,idtmp]
    # plt.scatter(data_temp[0, :], data_temp[1, :])
    data_temp = np.array(data_temp)
    data_temp = data_temp - np.tile(T[i], (data_temp.shape[1], 1)).T
    data_temp = np.dot(Q[i], data_temp).T
    X = data_temp[:, 0]
    Y = X * X * C[i][0] + X * C[i][1] + C[i][2]
    # plt.scatter(X, Y)
    XI = []
    XI.append(X)
    XI.append(Y)
    XI = np.array(XI)
    # plt.scatter(XI[0,:], XI[1, :])
    Data_ = np.dot(np.linalg.inv(Q[i]), XI)
    Data_ = Data_ + np.tile(T[i], (Data_.shape[1], 1)).T
    print(Data_.shape, 'Data_')
    Data_ = list(Data_.T)
    sort_by_first_column_inplace(Data_)
    Data_ = np.array(Data_).T
    plt.plot(Data_[0, :], Data_[1, :])
plt.show()

####################---------GMR---------#############################


timeInput = np.linspace(1, np.max(Data[0, :]), 100)
expData = np.ndarray(shape=(Data.shape[0], np.size(timeInput)))
expData[0, :] = timeInput
expData[1:Data.shape[0], :], expSigma = GMR(Priors, Mu, Sigma, timeInput, 0, np.arange(1, Data.shape[0]), C, Q, T, Data, Data_id)
plt.scatter(Data[0,:], Data[1,:], c='blue', label='观测数据点')

expData = list(expData.T)
sort_by_first_column_inplace(expData)
expData = np.array(expData).T
for i in range(1, Data.shape[0]):
    plt.plot(expData[0,:], expData[i,:], c='red', linewidth=5, label='GMR回归')
# plt.xlabel('时间(s)')
# plt.ylabel('位置(m)')
np.savetxt('data_417_dmp.txt', expData, delimiter=',')
plt.rcParams['font.sans-serif']=['SimHei']
plt.legend()
plt.savefig('tishui.png')
# plt.title('广义高斯混合模型')
plt.title('广义高斯混合模型')
plt.savefig('tishui0.png')
plt.show()