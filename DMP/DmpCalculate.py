# dmp calculate
from dmp_discrete import dmp_discrete
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt


def DmpCalculate(data, ratio=[1.0, 1.0], thickness=1.0):
    # import data
    data = scio.loadmat(data)
    trajectory = data["trajectory"]  # location info
    numStroke = int(np.shape(trajectory)[0] / 3)  # num of stroke
    numStep = np.shape(trajectory)[1]  # num of step

    # generate trajectory
    track = np.zeros((3 * numStroke, numStep))

    # learning
    for stroke in range(numStroke):
        # read data
        y_demo = np.zeros((2, numStep))
        y_demo[0, :] = trajectory[stroke * 3 + 1, :]
        y_demo[1, :] = trajectory[stroke * 3 + 2, :]
        # y_demo[2,:]=locz[stroke,:]

        # dmp learning and reproduce
        dmp = dmp_discrete(n_dmps=2, n_bfs=500, dt=1.0 / numStep)
        dmp.learning(y_demo, plot=False)

        # dmp reproduce
        initial = np.multiply(ratio, y_demo[:, 0]).tolist()
        # initial[2]=0
        goal = np.multiply(ratio, y_demo[:, -1]).tolist()
        # goal[2]=0.05
        y_reproduce, dy_reproduce, ddy_reproduce = dmp.reproduce(
            tau=1, initial=initial, goal=goal
        )

        # save data
        track[stroke * 3 : stroke * 3 + 2, :] = y_reproduce.transpose()
        track[stroke * 3 + 2, :] = -(trajectory[stroke * 3, :] ** 2 * thickness)
    return track, numStroke, numStep


if __name__ == "__main__":
    # import data
    data = "./水FGMM.mat"

    # calculate
    track, numStroke, numStep = DmpCalculate(data, [1, 1], 0.5)
    scio.savemat('DMPResult.mat', {'track':track})
    data = scio.loadmat(data)
    trajectory = data["trajectory"]  # location info

    # plot track in xy
    plt.figure(figsize=(6, 4))
    plt.plot(
        trajectory[0 * 3 + 1, :],
        trajectory[0 * 3 + 2, :],
        "k-",
        alpha=0.5,
        label="original trajectory",
        linewidth=6,
    )
    plt.plot(
        track[0 * 3, :],
        track[0 * 3 + 1, :],
        "r--",
        label="generated trajectory",
        linewidth=3,
    )
    for stroke in range(1, numStroke):
        plt.plot(
            trajectory[stroke * 3 + 1, :],
            trajectory[stroke * 3 + 2, :],
            "k-",
            alpha=0.5,
            linewidth=6
        )
        plt.plot(track[stroke * 3, :], track[stroke * 3 + 1, :], "r--", linewidth=3)
    plt.xticks(fontsize=10)
    plt.yticks(fontsize=10)
    plt.legend(loc="upper left", fontsize=10)
    plt.show()

    # plot different stroke
    for stroke in range(numStroke):
        plt.figure(figsize=(6, 4))
        plt.plot(trajectory[stroke * 3 + 1, :], "c", linewidth=6, label="original x")
        plt.plot(track[stroke * 3, :], "r--", linewidth=3, label="generated x")
        plt.plot(trajectory[stroke * 3 + 2, :], "y", linewidth=6, label="original y")
        plt.plot(track[stroke * 3 + 1, :], "g--", linewidth=3, label="generated y")
        plt.legend(loc="upper left", fontsize=10)
        plt.xlabel("time")
        plt.show()

    # plot thickness
    # plt.figure()
    # for stroke in range(numStroke):
    #     for step in range(numStep):
    #         plt.scatter(locxy[stroke*3+1,step], locxy[stroke*3+2,step], s=locz[stroke,step]**2*3.14*8,c='c')

    # for stroke in range(numStroke):
    #     for step in range(numStep):
    #         plt.scatter(track[stroke*3,step], track[stroke*3+1,step], s=track[stroke*3+2,step]**2*3.14*8,c='r',alpha=0.2)
    # plt.show()
