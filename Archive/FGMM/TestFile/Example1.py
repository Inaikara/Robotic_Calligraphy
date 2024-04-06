from GMM_GMR import GMM_GMR
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
from plotGMM import *

if __name__ == "__main__":
    # data = np.loadtxt("stiff_data.txt", delimiter=' ')
    # # data = data[:, 0:2].T

    # data = data.T

    # data = np.loadtxt('c_stiff_data.txt', delimiter=' ').T

    # data = np.array([[1,2,3],[4,5,6],[7,8,9]])

    # data = np.loadtxt('zhizhou.txt', delimiter=',').T
    # print(data.shape)
    # Data = []
    # for i in range(0, int(data.shape[1]/15)):
    #     Data.append([data[0,i*15], data[1,i*15]])
    # Data = np.array(Data).T
    # # min_x = min(Data[0,:])
    # # Data[0,:] -= min_x
    # data = Data/100

    img = Image.open('input.jpg').convert('L')
    img_data = np.asarray(img)
    print(img_data.shape)
    k = 0
    data = []
    for i in range(0, img_data.shape[0]):
        for j in range(0, img_data.shape[1]):
            if img_data[i, j] == 0:
                data.append([i, j])
                k += 1
    data = np.array(data).T

    Data = []
    for i in range(0, int(data.shape[1]/100)):
        Data.append(data[:, i * 100])
    Data = np.array(Data).T
    data = Data

    gmr = GMM_GMR(4)
    gmr.fit(data)
    timeInput = np.linspace(1, np.max(data[0, :]), 100)
    gmr.predict(timeInput)
    data_= gmr.expData
    print(gmr.Mu, 'Mu')
    print(gmr.Sigma, 'sigma')
    print(data_, 'data')
    fig = plt.figure()

    ax1 = fig.add_subplot(221)
    print(type(ax1))
    plt.title("Data")
    gmr.plot(ax=ax1, plotType="Data")

    ax2 = fig.add_subplot(222)
    plt.title("Gaussian States")
    gmr.plot(ax=ax2, plotType="Clusters")
    plt.show()

    # ax3 = fig.add_subplot(223)
    # plt.title("Regression")
    # gmr.plot(ax=ax3, plotType="Regression")

    # ax4 = fig.add_subplot(224)
    # plt.title("Clusters + Regression")
    # gmr.plot(ax=ax4, plotType="Clusters")
    # gmr.plot(ax=ax4, plotType="Regression")
    # predictedMatrix = gmr.getPredictedMatrix()
    # print(predictedMatrix)
    # ax1 = fig.add_subplot(111)
    # plt.plot(gmr.data[0,:], gmr.data[1,:],'.', color='blue')
    # rows = np.array([0, 1])
    # cols = np.arange(0, gmr.numbefOfStates, 1)
    # plotGMM(gmr.Mu[np.ix_(rows, cols)], gmr.Sigma[np.ix_(rows, rows, cols)], [255/255,0,0], 1, ax1)
    # plt.xlim(3.75,5.5)
    # plt.ylim(1.25,3.25)
    # plt.show()