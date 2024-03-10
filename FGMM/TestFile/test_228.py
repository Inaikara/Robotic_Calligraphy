import numpy as np
from pca_initial import *
import random as rd
from EM_gene import *
from PIL import Image
from getdata_image import *

##########################-----get_data-------######################

# Data = getdata_image('319.png')
# print(Data.shape, 'D')
# plt.scatter(Data[0, :], Data[1, :])
# plt.show()
# print(Data.shape,'0.0.0.0')

# Data = np.loadtxt('data_322.txt', delimiter=',')
# Data = np.array(Data.T)

# data = []

# for i in range(0, int(Data.shape[1]/10)):
#     data.append(Data[:,i*10])

# data = np.array(data)
# print(data.shape, 'data')
# print(Data.shape, 'Data')

# Data = data.T
# print(Data.shape,'0.0.0.0')

data = np.loadtxt('data_jiu.txt', delimiter=',').T
print(data.shape)
Data = []
for i in range(0, int(data.shape[1]/20)):
    Data.append([data[0,i*20], data[1,i*20]])
Data = np.array(Data).T

#########################------initial-------#######################
nb_states = 3
theta, Data_id = PCA_init(Data, nb_states)



print(theta[2], 'init_C')
b = theta[2].copy()
a = EM(Data, theta, nb_states, Data_id, 50)
C = a[3]
Q = a[4]
T = a[5]
print(C, 'C')
Data_id = np.array(Data_id)
print(Data_id.shape, 'Data_id')
print(a[2], 'Sigma')
data_plot = [[], []]
for i in range(0, nb_states):
    idtmp = np.nonzero(Data_id == i)    
    idtmp = list(idtmp)
    print(np.size(idtmp), 'len')
    idtmp = np.reshape(idtmp, (np.size(idtmp)))
    data_temp = Data[:,idtmp]
    data_temp = np.array(data_temp)
    plt.scatter(data_temp[0, :], data_temp[1, :])
    data_temp =  np.dot(Q[i], data_temp - np.tile(T[i], (data_temp.shape[1], 1)).T)
    # plt.scatter(data_temp[0,:], data_temp[1,:])
    X = data_temp[0, :]
    Y = X * X * C[i][0] + X * C[i][1] + C[i][2]
    XI = []
    XI.append(X)
    XI.append(Y)
    XI = np.array(XI)
    # plt.scatter(XI[0,:], XI[1, :])
    Data_ =  np.dot(np.linalg.inv(Q[i]), XI) 
    Data_ = Data_ + np.tile(T[i], (Data_.shape[1], 1)).T
    print(Data_.shape, 'Data_')
    data_plot[0].extend(Data_[0,:])
    data_plot[1].extend(Data_[1,:])
    # plt.plot(Data_[0, :], Data_[1, :])
data_plot = np.array(data_plot)
data_plot = data_plot.T[np.lexsort(data_plot[::-1,:])].T
plt.plot(data_plot[0,:], data_plot[1,:])
plt.show()