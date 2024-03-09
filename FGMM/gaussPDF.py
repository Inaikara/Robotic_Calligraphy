import numpy as np
import math
import sys
from pca_initial import *
from sympy import *

def gaussPDF(Data, Mu, Sigma):
    realmin = sys.float_info[3]
    nbVar, nbData = np.shape(Data)
    Data = np.transpose(Data) - np.tile(np.transpose(Mu), (nbData, 1))
    prob = np.sum(np.dot(Data, np.linalg.inv(Sigma))*Data, 1)
    # print(prob, 'prob')
    prob = np.exp(-0.5*prob)/np.sqrt((np.power((2*math.pi), nbVar))*np.absolute(np.linalg.det(Sigma))+realmin)
    return prob

def gene_gaussPDF(Data, theta, i):
    Mu = theta[0]
    Sigma = theta[1]
    C = theta[2]
    Q = theta[3]
    T = theta[4]
    prob = []
    Q_ = np.array(Q[i])
    T_ = T[i] 
    T_ = np.array(T_)
    C_ = C[i]
    sigma_ = Sigma[:, :, i]
    # print(Q_, T_, 'Q_, T_')
    Data_ = np.dot(Q_, Data - np.tile(T_, (Data.shape[1], 1)).T)
    # plt.scatter(Data[0,:], Data[1,:], c='blue')
    # plt.scatter(Data_[0,:], Data_[1,:], c='red')
    # plt.show()
    # print(Data_, 'Data_')
    for i in range(0, Data_.shape[1]):
        data = np.array([Data_[0, i], Data_[1, i]])
        # data = np.dot(Q_,  data - T_)
        root = solve_func([C_[0], C_[2], data[0], data[1]])
        cur_prob = 0
        l1, l2 = cal_distance(root, [C_[0], data[0], data[1]])
        # print(l1, l2, 'l1, l2')
        _l1 = np.array(l1)
        _l2 = np.array(l2)
        for j in range(0, _l1.shape[0]):
            l1_ = float(_l1[j])
            l2_ = float(_l2[j])
            a = float(sigma_[0][0])
            b = float(sigma_[1][1])
            # print(l1_, 'l1_')
            # print(l2_, 'l2_')
            # print(a, 'sigma1')
            # print(b, 'sigma2')
            cur_prob += (np.exp(-l1_*l1_/(2*a))/math.sqrt(2*np.pi*abs(a))) * (np.exp(-l2_*l2_/(2*b))/math.sqrt((2*np.pi*abs(b))))
            # print(cur_prob, 'cur_prob')
        prob.append(cur_prob.copy())
    return np.array(prob)

def gauss_GMR(x,S,Q,T,C, data_temp):
    q11 = Q[0,0]
    q22 = Q[1,1]
    q12 = Q[0,1]
    q21 = Q[1,0]
    x_u = T[0]
    y_u = T[1]
    prob = []
    a = C[0]
    b = C[2]
    s1 = S[0,0]
    s2 = S[1,1]
    # print(x.shape, 'xxxxxxxx')
    for i in range(0,x.shape[1]):
        # plt.scatter(data_temp[0,:], data_temp[1,:], c = 'blue')
        data_temp_ = np.array(data_temp)
        print(data_temp.shape,'data_temp')
        # data_temp_ = data_temp_ - np.tile(T, (data_temp.shape[1], 1)).T
        # data_temp = np.dot(Q,data_temp).T
        # X = data_temp_[:, 0]
        # Y = X * X * C[0] + X * C[1] + C[2]
        # plt.scatter(X, Y, c='green')
        x_0 = x[0, i]
        # plt.axvline(x_0)
        # print(x_0, x_u, y_u, q11, q12, q21, q22, C[0], C[2],'x_0, x_u, y_u, q11, q12, q21, q22, C[0], C[2]')
        x_, y_ = solve_GMR(x_0, x_u, y_u, q11, q12, q21, q22, C[0], C[1], C[2])
        # plt.scatter(x_, y_, c='red')
        # plt.show()
        l = abs((1/2) * x_ * math.sqrt(1 + 4 * a * a * x_ * x_) + (1/(4*abs(a))) * math.log(2 * abs(a) * x_ + math.sqrt(1 + 4 * a * a * x_ * x_),math.e))
        cur_prob = (math.exp(-l*l/(2*s1))/math.sqrt(2*np.pi*abs(s1))) / math.sqrt(2*np.pi*abs(s2))
        prob.append(cur_prob)
    return np.array(prob)


def solve_GMR(x_0, x_u, y_u, q11, q12, q21, q22, a, b, c):
    y = Symbol('y')
    x_ = q11*(x_0-x_u)+q12*(y-y_u)
    y_ = q21*(x_0-x_u)+q22*(y-y_u)

    # func = [y_-a*x_*x_-b]
    func = [q21*(x_0-x_u)+q22*(y-y_u) - a * (q11*(x_0-x_u)+q12*(y-y_u)) * (q11*(x_0-x_u)+q12*(y-y_u)) - b * (q11*(x_0-x_u)+q12*(y-y_u)) - c]
    solved = solve(func, [y])

    if type(solved) == dict:
        y = solved[y]
        return q11*(x_0-x_u)+q12*(y-y_u), q21*(x_0-x_u)+q22*(y-y_u)
    elif type(solved) == list:
        root = np.array(solved)
        print(root, 'rootrootroot')
        print(root.shape, 'root.shape')
        if type(root[0, 0]) == Add:
            # print(root[0,0], 'root0.0')
            print('Add.Add.Add.Add')
            return 10000*(abs(x_0-x_u)), 0
        else:
            min_y = 1000000
            _y = 0
            for i in range(root.shape[0]):
                if abs(root[i,0]-y_u) < min_y:
                    _y = root[i,0]
                    min_y = abs(root[i,0]-y_u)
                # min_x = min(min_x, q11*(x_0-x_u)+q12*(root[i,0]-y_u))
            print(_y, '_y')
            return q11*(x_0-x_u)+q12*(_y-y_u), 0
    # root = np.array(solved)
    # for i in range(0, root.shape[1]):
    #     if type(root[i, 0]) == Add:
    # print(solved)
    # return q11*(x_0-x_u)+q12*(y-y_u), q21*(x_0-x_u)+q22*(y-y_u)


# a, b = solve_GMR(1,2,1,1,0,1,-1,-1,2)
# print(a, b)
