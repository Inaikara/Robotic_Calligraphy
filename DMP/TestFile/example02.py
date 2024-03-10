
# DMP官方

from dmp_discrete import *

if __name__ == "__main__":
    data_len = 500

    # ----------------- For different initial and goal positions
    t = np.linspace(0, 1.5*np.pi, data_len)
    y_demo = np.zeros((2, data_len))
    y_demo[0,:] = np.sin(t)
    y_demo[1,:] = np.cos(t)
    
    # DMP learning
    dmp = dmp_discrete(n_dmps=y_demo.shape[0], n_bfs=100, dt=1.0/data_len)
    dmp.learning(y_demo, plot=False)

    # reproduce learned trajectory
    y_reproduce, dy_reproduce, ddy_reproduce = dmp.reproduce()

    # set new initial and goal poisitions
    y_reproduce_2, dy_reproduce_2, ddy_reproduce_2 = dmp.reproduce(tau=0.5, initial=[0.2, 0.8], goal=[-0.5, 0.2])

    plt.figure(figsize=(10, 5))
    plt.plot(y_demo[0,:], 'g', label='demo sine')
    plt.plot(y_reproduce[:,0], 'r--', label='reproduce sine')
    plt.plot(y_reproduce_2[:,0], 'r-.', label='reproduce 2 sine')
    plt.plot(y_demo[1,:], 'b', label='demo cosine')
    plt.plot(y_reproduce[:,1], 'm--', label='reproduce cosine')
    plt.plot(y_reproduce_2[:,1], 'm-.', label='reproduce 2 cosine')
    plt.legend()
    plt.grid()
    plt.xlabel('time')
    plt.ylabel('y')


    # ----------------- For same initial and goal positions
    t = np.linspace(0, 2*np.pi, data_len)

    y_demo = np.zeros((2, data_len))
    y_demo[0,:] = np.sin(t)
    y_demo[1,:] = np.cos(t)

    # DMP learning
    dmp = dmp_discrete(n_dmps=y_demo.shape[0], n_bfs=400, dt=1.0/data_len)
    dmp.learning(y_demo, plot=False)

    # reproduce learned trajectory
    y_reproduce, dy_reproduce, ddy_reproduce = dmp.reproduce()

    # set new initial and goal poisitions
    y_reproduce_2, dy_reproduce_2, ddy_reproduce_2 = dmp.reproduce(tau=0.8, initial=[0.2, 0.8], goal=[0.5, 1.0])

    plt.figure(figsize=(10, 5))
    plt.plot(y_demo[0,:], 'g', label='demo sine')
    plt.plot(y_reproduce[:,0], 'r--', label='reproduce sine')
    plt.plot(y_reproduce_2[:,0], 'r-.', label='reproduce 2 sine')
    plt.plot(y_demo[1,:], 'b', label='demo cosine')
    plt.plot(y_reproduce[:,1], 'm--', label='reproduce cosine')
    plt.plot(y_reproduce_2[:,1], 'm-.', label='reproduce 2 cosine')
    plt.legend(loc="upper right")
    plt.ylim(-1.5, 3)
    plt.grid()
    plt.xlabel('time')
    plt.ylabel('y')
    plt.show()