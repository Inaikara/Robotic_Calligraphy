# dmp calculate
from dmp_discrete import dmp_discrete
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt

def dmp_cal(ratio=[1,1],thickness=1):
    # import data
    data = '../sample/trajData.mat'
    data = scio.loadmat(data)
    locxy = data['trajData']# location info
    data = '../sample/trajSigma.mat'
    data = scio.loadmat(data)
    locz = data['trajSigma']# thickness info
    num_stroke=np.shape(locz)[0]# num of stroke
    num_step=np.shape(locz)[1]# num of step

    # generate trajectory
    track=np.zeros((3*num_stroke,num_step))

    # learning
    for stroke in range(num_stroke):
        # read data
        y_demo = np.zeros((2,num_step))
        y_demo[0,:]=locxy[stroke*3+1,:]
        y_demo[1,:]=locxy[stroke*3+2,:]
        #y_demo[2,:]=locz[stroke,:]

        # dmp learning and reproduce
        dmp = dmp_discrete(n_dmps=2, n_bfs=500, dt=1.0/num_step)
        dmp.learning(y_demo, plot=False)

        # dmp reproduce
        initial=np.multiply(ratio,y_demo[:,0]).tolist()
        #initial[2]=0
        goal=np.multiply(ratio,y_demo[:,-1]).tolist()
        #goal[2]=0.05
        y_reproduce, dy_reproduce, ddy_reproduce = dmp.reproduce(tau=1, initial=initial, goal=goal)

        # save data
        track[stroke*3:stroke*3+2,:]=y_reproduce.transpose()
        track[stroke*3+2,:]=-(locz[stroke,:]**2*thickness)
    return track, num_stroke, num_step


if __name__ == "__main__":
    # import data
    data = '../sample/trajData.mat'
    data = scio.loadmat(data)
    locxy = data['trajData']# location info
    data = '../sample/trajSigma.mat'
    data = scio.loadmat(data)
    locz = data['trajSigma']# thickness info

    # calculate
    track, num_stroke, num_step=dmp_cal([0.5,0.5],0.5)

    # plot track in xy
    plt.figure()
    for stroke in range(num_stroke):
        plt.plot(locxy[stroke*3+1,:], locxy[stroke*3+2,:],'c')
        plt.plot(track[stroke*3,:], track[stroke*3+1,:],'r--')
    plt.show()

    # plot different stroke
    plt.figure()
    for stroke in range(num_stroke):
        plt.subplot((num_stroke//2)+1, 2, stroke+1)
        plt.plot(locxy[stroke*3+1,:], 'c', label='demo x')
        plt.plot(track[stroke*3,:], 'r--', label='reproduce x')
        plt.plot(locxy[stroke*3+2,:], 'm', label='demo y')
        plt.plot(track[stroke*3+1,:], 'g--', label='reproduce y')
        #plt.legend()
        #plt.grid()
        plt.xlabel('time')
        plt.ylabel('y')
    plt.subplots_adjust(wspace=0, hspace=0)
    plt.show()

    # plot thickness
    # plt.figure()
    # for stroke in range(num_stroke):
    #     for step in range(num_step):
    #         plt.scatter(locxy[stroke*3+1,step], locxy[stroke*3+2,step], s=locz[stroke,step]**2*3.14*8,c='c')

    # for stroke in range(num_stroke):
    #     for step in range(num_step):
    #         plt.scatter(track[stroke*3,step], track[stroke*3+1,step], s=track[stroke*3+2,step]**2*3.14*8,c='r',alpha=0.2)

    plt.show()






