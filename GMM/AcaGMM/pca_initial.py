import matplotlib.pyplot as plt
import numpy as np
from numpy.linalg import eig
import matplotlib.pyplot as plot
from scipy.optimize import fsolve
from sympy import *
import math

def kMeans(X, K, maxIters = 50):
    centroids = X[np.random.choice(np.arange(len(X)), K), :]
    for i in range(maxIters):
        C = np.array([np.argmin([np.dot(x_i-y_k, x_i-y_k) for y_k in centroids]) for x_i in X])
        centroids = [X[C == k].mean(axis = 0) for k in range(K)]
    return np.array(centroids) , C

# def pca(X,k):
#     print(X, 'pca_X')
#     T = X.mean(axis=0)
#     X = X - X.mean(axis = 0) #向量X去中心化
#     X_cov = np.cov(X.T, ddof = 0) #计算向量X的协方差矩阵，自由度可以选择0或1
#     eigenvalues,eigenvectors = eig(X_cov) #计算协方差矩阵的特征值和特征向量
#     klarge_index = eigenvalues.argsort()[-k:][::-1] #选取最大的K个特征值及其特征向量
#     k_eigenvectors = eigenvectors[klarge_index] #用X与特征向量相乘
#     return np.dot(k_eigenvectors, X.T), T, k_eigenvectors
#     # return np.dot(k_eigenvectors, X), T, k_eigenvectors.T

def pca(X,i):
    """
    二维数据的主成分分析（PCA）函数

    参数：
    X: numpy.array, shape (n_samples, 2)
        输入的二维数据，每行代表一个样本，每列代表一个特征

    返回：
    eig_vals: numpy.array, shape (2,)
        特征值（方差）的数组，按从大到小排序
    eig_vecs: numpy.array, shape (2, 2)
        特征向量的数组，每列代表一个特征向量
    X_pca: numpy.array, shape (n_samples, 2)
        降维后的数据，投影到主成分上的结果
    """
    i = 2
    # 1. 计算均值
    mean = np.mean(X, axis=0)

    # 2. 中心化数据
    X_centered = X - mean

    # 3. 计算协方差矩阵
    cov_matrix = np.cov(X_centered, rowvar=False)

    # 4. 计算特征值和特征向量
    eig_vals, eig_vecs = np.linalg.eig(cov_matrix)

    # 5. 特征值从大到小排序
    idx = np.argsort(eig_vals)[::-1]
    eig_vals = eig_vals[idx]
    eig_vecs = eig_vecs[:, idx]

    # 6. 降维
    # X_pca = np.dot(X_centered, eig_vecs)
    X_pca = np.dot(eig_vecs.T, X_centered.T)

    return X_pca, mean, eig_vecs.T

def least_squares(X, k):
    # z1 = np.polyfit(X[:,0], X[:, 1], k)
    z1 = np.polyfit(X[0, :], X[1, :], k)
    return z1

def solve_func(para):
    x = Symbol('x')
    y = Symbol('y')
    a = para[0]
    b = para[1]
    v1 = para[2]
    v2 = para[3]
    func = [x-v1+2*(y-v2)*a*x, a*x*x+b-y]
    solved_value = solve(func, [x,y])
    solved_value = np.array(solved_value)
    # num_root = solved_value.shape[0]
    return solved_value

def cal_distance(root ,para):
    _l1 = []
    _l2 = []
    for i in range(0, root.shape[0]):
        if type(root[i, 0])==Add:
            root[i,0] = complex(root[i, 0])
            if abs(root[i, 0].imag) > 0.00000001:
                continue
            elif abs(root[i, 0].imag) < 0.00000001:
                root[i, 0] = root[i, 0].real
        if type(root[i, 1])==Add:
            root[i,1] = complex(root[i, 1])
            if abs(root[i, 1].imag) > 0.00000001:
                continue
            elif abs(root[i, 1].imag) < 0.00000001:
                root[i, 1] = root[i, 1].real
        a = para[0]
        z1 = root[i, 0]
        z2 = root[i, 1]
        v1 = para[1]
        v2 = para[2]
        a = float(a)
        _l1.append(abs((1/2) * z1 * math.sqrt(1 + 4 * a * a * z1 * z1) + (1/(4*abs(a))) * math.log(2 * abs(a) * z1 + math.sqrt(1 + 4 * a * a * z1 * z1),math.e)))
        _l2.append(math.sqrt((v1-z1)*(v1-z1)+(v2-z2)*(v2-z2)))
    return _l1, _l2

def LSFM_PCA(Data, k):
    _, Q, T = pca(Data, k)

def init_variance(data, theta):
    L1 = []
    L2 = []
    sigma_1 = 0
    sigma_2 = 0
    for i in range(0, data.shape[1]):
        l1 = []
        l2 = []
        root = solve_func([theta[0], theta[2],data[0, i], data[1, i]])
        l1, l2 = cal_distance(root, [theta[0], data[0, i], data[1, i]])
        l2_min = min(l2)
        min_dex = l2.index(l2_min)
        l1_min = l1[min_dex]
        L1.append(l1_min)
        L2.append(l2_min)
        # print(l1_min, 'l1_min')
        # print(l2_min, 'l2_min')
        sigma_1 += l1_min * l1_min
        sigma_2 += l2_min * l2_min
    sigma_1 = sigma_1 / data.shape[1]
    sigma_2 = sigma_2 / data.shape[1]
    return sigma_1, sigma_2

def PCA_init(Data, nbStates):       #Data:2*n
    nbVar, nbData = np.shape(Data)
    Centers, Data_id = kMeans(np.transpose(Data), nbStates)
    Mu = np.transpose(Centers)
    Priors = np.ndarray(shape = (1, nbStates))
    Sigma = np.ndarray(shape = (nbVar, nbVar, nbStates))
    # fig = plt.figure()
    C = []
    # print(Data_id)
    threshold = 0.0001
    Q = []
    T = []
    for i in range(0, nbStates):
        idtmp = np.nonzero(Data_id == i)
        idtmp = list(idtmp)
        idtmp = np.reshape(idtmp, (np.size(idtmp)))
        Priors[0,i] = np.size(idtmp)
        Data = np.array(Data)
        data_temp = Data[:,idtmp]
        data_temp = np.array(data_temp)
        # plt.scatter(data_temp[0,:], data_temp[1, :])
        pca_, T_, Q_ = pca(data_temp.T, 2)
        a = np.tile(T_, (data_temp.shape[1], 1)).T
        data_temp = np.dot(Q_, data_temp - np.tile(T_, (data_temp.shape[1], 1)).T)    # y = Q * (x - T)
        
        Q.append(Q_.copy())
        T.append(T_)
        print(pca_.shape, 'pca')
        quad = least_squares(pca_, 2)
        # plt.scatter(pca_[0,:], pca_[1,:])
        # plt.scatter(pca_[0,:], pca_[0,:]*pca_[0,:]*quad[0]+pca_[0,:]*quad[1]+quad[2])
        C.append(quad)
        if abs(quad[0]) >= threshold:
            sigma_1, sigma_2 = init_variance(data_temp, quad)
            Sigma[:, :, i] = np.array([[sigma_1, 0], [0, sigma_2]])
        if abs(quad[0]) < threshold:
            a = np.concatenate((Data[:, idtmp],Data[:, idtmp]), axis = 1)
            Sigma[:,:,i] = np.cov(a)
            Sigma[:,:,i] = Sigma[:,:,i] + 0.00001 * np.diag(np.diag(np.ones((nbVar,nbVar))))
    Priors = Priors / nbData
    theta = [Mu, Sigma, C, Q, T, Priors]
    # plt.show()
    return theta, Data_id