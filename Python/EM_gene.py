from gaussPDF import *
import numpy as np
import sys

def EM(Data, theta, k, Data_id, bianjie, time):
    Mu = theta[0].copy()
    Sigma = theta[1].copy()
    init_c = theta[2].copy()
    C = theta[2].copy()
    Q = theta[3].copy()
    T = theta[4].copy()
    Priors = theta[5].copy()
    realmax = sys.float_info[0]
    realmin = sys.float_info[3]
    loglik_threshold = 1e-10
    nbVar, nbData = np.shape(Data)
    nbStates = k
    loglik_old = -realmax
    nbStep = 0
    threshold = 0.001
    Pix = np.ndarray(shape = (nbStates, nbData))
    Pxi = np.ndarray(shape = (nbData, nbStates))
    while 1:
        # Estep
        for i in range(0, nbStates):
            # print([Sigma[0,0,i], Sigma[0,1,i], Sigma[1,0,i], Sigma[1,1,i]],C,Q,T,'Sigma, C, Q, T' )
            if abs(C[i][0]) >= threshold:
                Pxi[:, i] = gene_gaussPDF(Data, [Mu, Sigma, C, Q, T, Priors], i)
            else:
                Pxi[:, i] = gaussPDF(Data, Mu[:, i], Sigma[:, :, i])
        # print(Pxi, 'Pxi')
        Pix_tmp = np.multiply(np.tile(Priors, (nbData, 1)),Pxi)
        Pix = np.divide(Pix_tmp,np.tile(np.reshape(np.sum(Pix_tmp,1), (nbData, 1)), (1, nbStates)))
        E = np.sum(Pix, 0)
        Priors = np.reshape(Priors, (nbStates))
        # Mstep
        for i in range(0, nbStates):
            Priors[i] = E[i]/nbData
            P = np.array(Pix[:, i]).T
            print(P, 'P')
            for m in range(0, P.shape[0]):
                if P[m] > 0.5:
                    P[m] = 1
                else:
                    P[m] = 0
            Xi = np.multiply(np.tile(P, (2, 1)), Data)
            # plt.scatter(Data[0, :], Data[1, :], c='red')
            # plt.scatter(Xi[0,:], Xi[1, :], c='blue')
            # plt.show()
            X_i = []
            for k in range(Xi.shape[1]):
                if abs(Xi[0, k]) > bianjie or abs(Xi[1, k]) > bianjie:
                    X_i.append([Xi[0, k], Xi[1, k]])
            X_i = np.array(X_i).T
            # plt.scatter(Data[0,:], Data[1, :])
            # plt.scatter(X_i[0,:], X_i[1, :])
            # plt.show()
            # idtmp = np.nonzero(Data_id == i)
            # idtmp = list(idtmp)
            # idtmp = np.reshape(idtmp, (np.size(idtmp)))
            # print(Xi, 'Xi')
            # Xi = Xi[:,idtmp]

            Y, T_new, Q_new = pca(X_i.T, 2)
            C_new = least_squares(Y, 2)
            print(init_c, 'init_c')
            print(C_new, 'C_new')
            print(C, i, 'C, i')
            C[i] = C_new
            Q[i] = Q_new
            T[i] = T_new
            if abs(C_new[0]) >= threshold:
                U_new = np.dot(Data,Pix[:,i])/E[i] + np.dot(np.linalg.inv(Q_new), np.array([0, C_new[2]]).T) + T_new
                Mu[:, i] = U_new
                L_te = np.zeros((nbData, 2))
                Data_ =  np.dot(Q_new, Data - np.tile(T_new, (Data.shape[1], 1)).T)    # y = Q * (x - T)
                for k in range(0, nbData):
                    data = Data_[:, k]
                    root = solve_func([C_new[0], C_new[2] ,data[0], data[1]])
                    l1, l2 =cal_distance(root, [C_new[0],data[0], data[1]])
                    L1_1 = 0
                    L1_2 = 0
                    L2_1 = 0
                    L2_2 = 0
                    L1_mean = 0
                    L2_mean = 0
                    for j in range(0, len(l1)):
                        l1[j] = float(l1[j])
                        l2[j] = float(l2[j])
                        Sigma_1 = float(Sigma[0,0,i])
                        Sigma_2 = float(Sigma[1,1,i])
                        # print(l2[j], Sigma_2, 'l2, sigma')
                        L1_1 += (np.exp(-l1[j]*l1[j]/(2*abs(Sigma_1)))/(np.sqrt(2*np.pi*abs(Sigma_1)))) * l1[j]
                        L1_2 += np.exp(-l1[j]*l1[j]/(2*abs(Sigma_1)))/(np.sqrt(2*np.pi*abs(Sigma_1)))
                        L2_1 += (np.exp(-l2[j]*l2[j]/(2*abs(Sigma_2)))/(np.sqrt(2*np.pi*abs(Sigma_2)))) * l2[j]
                        L2_2 += np.exp(-l2[j]*l2[j]/(2*abs(Sigma_2)))/(np.sqrt(2*np.pi*abs(Sigma_2)))
                    if(L1_2 == 0):
                        for j in range(0, len(l1)):
                            L1_mean += float(l1[j])
                        L_te[k, 0] = L1_mean/len(l1)
                    elif(L1_2 != 0):
                        # print('0.0.0.0.0.0')
                        L_te[k, 0] = L1_1/L1_2
                    # print(L2_1, L2_2, 'L2_1, L2_2')
                    if(L2_2 == 0):

                        for j in range(0, len(l2)):
                            L2_mean += float(l2[j])
                        L_te[k, 1] = L2_mean/len(l2)
                    elif(L2_2 != 0):
                        # print('0.0.0.0.0.0')
                        L_te[k, 1] = L2_1/L2_2
                sigma_1_1 = 0
                sigma_1_2 = 0
                sigma_2_1 = 0
                sigma_2_2 = 0
                for k in range(0, nbData):
                    sigma_1_1 += Pix[k, i] * L_te[k, 0]
                    sigma_1_2 += Pix[k, i]
                    sigma_2_1 += Pix[k, i] * L_te[k, 1]
                    sigma_2_2 += Pix[k, i]
                sigma_1_new = sigma_1_1/sigma_1_2
                sigma_2_new = sigma_2_1/sigma_2_2
                Sigma[0,0,i] = sigma_1_new
                Sigma[1,1,i] = sigma_2_new
                Sigma[0,1,i] = np.cov(X_i[0,:], X_i[1,:])[0,1]
                Sigma[1,0,i] = np.cov(X_i[0,:], X_i[1,:])[0,1]
            if abs(C_new[0]) < threshold:
                Mu[:,i] = np.dot(Data,Pix[:,i])/E[i]
                Data_tmp1 = Data - np.tile(np.reshape(Mu[:,i], (nbVar, 1)), (1,nbData))
                a = np.transpose(Pix[:, i])
                b = np.reshape(a, (1, nbData))
                c = np.tile(b, (nbVar, 1))
                d = c*Data_tmp1
                e = np.transpose(Data_tmp1)
                f = np.dot(d,e)
                Sigma[:,:,i] = f/E[i]
                Sigma[:,:,i] = Sigma[:,:,i] + 0.00001 * np.diag(np.diag(np.ones((nbVar,nbVar))))
        # Stop Criterion
        for i in range (0,nbStates):
            if abs(C[i][0]) >= threshold:
                Pxi[:, i] = gene_gaussPDF(Data, [Mu, Sigma, C, Q, T, Priors], i)
            else:
                Pxi[:, i] = gaussPDF(Data, Mu[:, i], Sigma[:, :, i])
            # print('Pxi', Pxi[:,i])
        F = np.dot(Pxi,np.transpose(Priors))
        indexes = np.nonzero(F<realmin)
        indexes = list(indexes)
        indexes = np.reshape(indexes,np.size(indexes))
        F[indexes] = realmin
        F = np.reshape(F, (nbData, 1))
        loglik = np.mean(np.log10(F), 0)
        print(np.absolute((loglik/loglik_old)-1), 'np.absolute((loglik/loglik_old)-1)')
        if np.absolute((loglik/loglik_old)-1)<loglik_threshold:
            break
        loglik_old = loglik
        nbStep = nbStep+1
        print(nbStep, 'nbstep')
        if nbStep > time:
            break
    return(Priors,Mu,Sigma, C, Q, T)
            