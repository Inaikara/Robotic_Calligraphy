# robot manipulate code
from dmp_cal2 import dmp_cal
import elite_ci_o
import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt

def start_elite():
    robot_ip = "192.168.1.200"
    conSuc, sock = elite_ci_o.connectETController(robot_ip)
    if (conSuc):
        if elite_ci_o.getServoStatus(sock) == False:
            ret = elite_ci_o.setServoStatus(sock, 1)
            print('set servo status:', ret)

        if elite_ci_o.getMotorStatus(sock) == False:
            ret = elite_ci_o.syncMotorStatus(sock)
            print('sync motor status:', ret)

        if elite_ci_o.getTransparentTransmissionState(sock) == 1:
            ret = elite_ci_o.ttClearServoJointBuf(sock)
            print('ttClearServoJointBuf:', ret)
        return sock

def stop_elite(sock):
    elite_ci_o.disconnectETController(sock)

def move(sock,position,speed):
    joint_angles = elite_ci_o.inverseKinematic(sock, position)
    ret = elite_ci_o.moveByLine(sock, joint_angles, 0,speed, 5, 5)
    while True:
        if elite_ci_o.getRobotState(sock) == 0:
            break

def point_process(point,z_c=150):
    x_c=-420
    y_c=-60
    point[0]+=x_c
    point[1]+=y_c
    point[2]+=z_c
    point=np.append(point,[-3.14,0,0])
    return point.tolist()


if __name__ == "__main__":
    # import data
    data = '../sample/trajectory.mat'
    data = scio.loadmat(data)
    trajectory = data['trajectory']# location info

    # calculate
    track, num_stroke, num_step=dmp_cal([0.5,0.5],2)

    # initial
    sock=start_elite()
    
    # for each stroke
    for i in range(num_stroke):


        start_point=point_process(track[i*3:i*3+3,0],200) # record start point
        print("stroke",i+1,"start from:",start_point)
        move(sock,start_point,40)


        # for each step
        for j in range(1,num_step-1,2):
            move_point=point_process(track[i*3:i*3+3,j])
            move(sock,move_point,40)
            print("stroke",i+1,"move to:",move_point)

        end_point=point_process(track[i*3:i*3+3,-1],200) # record start point
        print("stroke",i+1,"end at:",end_point)

        move(sock,end_point,40)

        # ret=move(sock,end_point,15)
        # print("stroke",i+1,"at:",ret)


            

    # # plot
    # plt.figure()
    # for stroke in range(num_stroke):
    #     plt.plot(locxy[stroke*3+1,:], locxy[stroke*3+2,:],'c')
    #     plt.plot(track[stroke*3,:], track[stroke*3+1,:],'r--')
    # plt.show()

