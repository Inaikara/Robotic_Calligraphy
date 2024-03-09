import numpy as np
import sys
from gaussPDF import *
def GMR(Priors, Mu, Sigma, x, input, output, C, Q, T, Data, Data_id):
    lo = np.size(output)
    nbData = np.size(x)
    nbVar = np.size(Mu, 0)
    nbStates = np.size(Sigma, 2)
    realmin = sys.float_info[3]
    Pxi = np.ndarray(shape=(nbData, nbStates))
    x = np.reshape(x,(1,nbData))
    y_tmp = np.ndarray(shape = (nbVar-1, nbData, nbStates))
    Sigma_y_tmp = np.ndarray(shape = (lo, lo, 1, nbStates))
    output_y = np.ndarray(shape=(nbStates,nbData))
    print(Priors, 'Priors')
    for i in range (0,nbStates):
        if abs(C[i][0]) < 0.0001:
            print(i,'iiiiiii')
            m = Mu[input,i]
            m = np.reshape(m,(np.size(input),1))
            s = Sigma[input, input, i]
            s = np.reshape(s, (np.size(input),np.size(input)))
            Pxi[:,i] = np.multiply(Priors[i],gaussPDF(x,m,s))
        else:
            S = Sigma[:,:,i]
            Q_ = Q[i]
            C_ = C[i]
            T_ = T[i]
            idtmp = np.nonzero(Data_id == i)
            idtmp = list(idtmp)
            idtmp = np.reshape(idtmp, (np.size(idtmp)))
            data_temp = Data[:, idtmp]
            Pxi[:,i] = np.multiply(Priors[i], gauss_GMR(x, S, Q_, T_, C_, data_temp))
    print(Pxi, 'Pxi')
    beta = np.divide(Pxi,np.tile(np.reshape(np.sum(Pxi,1),(nbData, 1))+realmin,(1,nbStates)))
    print(beta,'beta')
    for j in range (0,nbStates):
        if abs(C[j][0]) < 0.0001:
            a = np.delete(Mu, np.s_[input], axis = 0)
            a = a[:,j]
            a = np.reshape(a,(nbVar-np.size(input),1))
            a = np.tile(a, (1, nbData))
            b = np.delete(Sigma[:,:,j], 0, axis = 0)
            b = np.delete(b, np.s_[1:nbVar], axis = 1)
            c = Sigma[input, input, j]
            c = np.reshape(c, (1,1))
            c = np.linalg.inv(c)
            c = np.dot(b, c)
            d = np.reshape(Mu[input, j], (1,1))
            d = np.tile(d, (1,nbData))
            d = x - d
            d = np.dot(c, d)
            y_tmp[:,:,j] = a + d
        else:
            Q_ = Q[j]
            C_ = C[j]
            T_ = T[j]
            Sigma_ = Sigma[:,:,i]
            for m in range(nbData):
                y_tmp[0,m,j] = calculate(x[0, m], Q_, T_, C_)
                # l = calculate_l(x[0, m], Q_, T_, C_,)
                # y_tmp[0,m,j] = T_[1] + Sigma_[0,1]*(1/Sigma_[0,0])*l
    # plt.scatter(x[0,:],y_tmp[0,:,0])
    # plt.scatter(x[0,:],y_tmp[0,:,1])
    # plt.show()
    # pravilno
    a, b = np.shape(beta)
    beta_tmp = np.reshape(beta, (1,a,b))
    a = np.tile(beta_tmp,(lo,1,1))
    y_tmp2 = a*y_tmp
    y = np.sum(y_tmp2,2)

    for j in range(0, nbStates):
        a = np.delete(Sigma[:,:,j], 0, axis = 0)
        a = np.delete(a, 0, axis = 1)
        b = np.delete(Sigma[:, :, j], 0, axis=0)
        b = np.delete(b, np.s_[1:nbVar], axis=1)
        c = Sigma[input, input, j]
        c = np.reshape(c, (1, 1))
        c = np.linalg.inv(c)
        c = np.dot(b, c)
        d = np.delete(Sigma[:,:,j], 0,axis = 1)
        d = np.delete(d, np.s_[1:nbVar], axis = 0)
        d = np.dot(c, d)
        Sigma_y_tmp[:,:,0,j] = a - d
    a, b = np.shape(beta)
    beta_tmp = np.reshape(beta,(1,1,a,b))
    a = beta_tmp*beta_tmp
    a = np.tile(a, (lo,lo,1,1))
    b = np.tile(Sigma_y_tmp,(1,1,nbData,1))
    Sigma_y_tmp2 = a*b
    Sigma_y = np.sum(Sigma_y_tmp2, 3)
    return (y, Sigma_y)

def calculate(x, Q, T, C):
    q11 = Q[0, 0]
    q22 = Q[1, 1]
    q12 = Q[0, 1]
    q21 = Q[1, 0]
    x_u = T[0]
    y_u = T[1]
    a = C[0]
    b = C[2]
    x_, y_ = solve_(x, x_u, y_u, q11, q12, q21, q22, C[0], C[1],C[2])
    print(x_,'x_')
    return x_


def solve_(x_0, x_u, y_u, q11, q12, q21, q22, a ,b, c):
    y = Symbol('y')
    x_ = q11*(x_0-x_u)+q12*(y-y_u)
    y_ = q21*(x_0-x_u)+q22*(y-y_u)

    # func = [y_-a*x_*x_-b]
    func = [q21*(x_0-x_u)+q22*(y-y_u) - a * (q11*(x_0-x_u)+q12*(y-y_u)) * (q11*(x_0-x_u)+q12*(y-y_u)) - b * (q11*(x_0-x_u)+q12*(y-y_u)) - c]
    solved = solve(func, [y])

    if type(solved) == dict:
        y = solved[y]
        # return y, q21*(x_0-x_u)+q22*(y-y_u)
        return y, q21*(x_0-x_u)+q22*(y-y_u)
    elif type(solved) == list:
        root = np.array(solved)
        if type(root[0, 0]) == Add:
            print('Add.Add.Add.Add')
            return 0, 0
        else:
            min_y = 1000000
            _y = 0
            for i in range(root.shape[0]):
                if abs(root[i, 0] - y_u) < min_y:
                    _y = root[i, 0]
                    min_y = abs(root[i, 0] - y_u)
                # min_x = min(min_x, q11*(x_0-x_u)+q12*(root[i,0]-y_u))
            # print(_y, '_y')
            return _y, 0
        
def calculate_l(x0, Q, T, C):
    q11 = Q[0, 0]
    q22 = Q[1, 1]
    q12 = Q[0, 1]
    q21 = Q[1, 0]
    x_u = T[0]
    y_u = T[1]
    a = C[0]
    b = C[2]
    x_, y_ = solve_(x0, x_u, y_u, q11, q12, q21, q22, C[0], C[1],C[2])
    # print(x_,'x_')
    x = q11*(x0-x_u)+q12*(x_-y_u)
    l = (1/2) * x * math.sqrt(1 + 4 * a * a * x * x) + (1/(4*abs(a))) * math.log(2 * abs(a) * x + math.sqrt(1 + 4 * a * a * x * x),math.e)
    print(x0, x_, x_u, y_u, 'x, y, xu, yu')
    print(l,'l')
    return l