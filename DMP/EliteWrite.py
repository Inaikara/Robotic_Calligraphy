# robot manipulate code
from DmpCalculate import DmpCalculate
import elite_ci
import numpy as np


def startElite():
    robot_ip = "192.168.1.200"
    my_elt = elite_ci.Elt(robot_ip)

    if my_elt.getServoStatus() == False:
        ret = my_elt.setServoStatus(1)
        print("set servo status:", ret)

    if my_elt.getMotorStatus() == False:
        ret = my_elt.syncMotorStatus()
        print("synchronize motor status:", ret)

    while my_elt.getTransparentTransmissionState() == 1:
        ret = my_elt.ttClearServoJointBuf()
        print("clear transparent transmission buffer:", ret)

    return my_elt


def moveSlow(position, strokeAngle):
    # position[5] = np.rad2deg(strokeAngle)
    joint_angles = my_elt.inverseKinematic(position)
    my_elt.moveByLine(joint_angles, 0, 50, 5, 5)
    while True:
        if my_elt.getRobotState() == 0:
            break


def move(position, strokeAngle):
    # position[5] = np.rad2deg(strokeAngle)
    joint_angles = my_elt.inverseKinematic(position)
    # joint_angles[5] = np.rad2deg(strokeAngle)
    ret = my_elt.ttPutServoJointToBuf(joint_angles)


def transInit():
    ret = my_elt.transparentTransmissionInit(400, 0.01 * 1000, 0.1)
    print("transparent transmission init:", ret)

    ret = my_elt.getTransparentTransmissionState()
    print("get transparent transmission state:", ret)

    # pre-fill transparent transmission buffer
    current_joint_angle = my_elt.getRobotPos()
    ret = my_elt.ttPutServoJointToBuf(current_joint_angle)

def getNewAngle(direct):
    direct = direct / np.linalg.norm(direct)
    baseDirect = np.array([0, 1])
    cosd = np.dot(direct, baseDirect) / (
        np.linalg.norm(direct) * np.linalg.norm(baseDirect)
    )
    sind = np.cross(direct, baseDirect) / (
        np.linalg.norm(direct) * np.linalg.norm(baseDirect)
    )
    d = np.arctan2(cosd, sind)
    return d

#242F
#244
def getNewPoint(point, z_c=240):
    # -420
    x_c = -420
    # -60
    y_c = -180
    # test
    point[0] = -point[0]
    point[1] = -point[1]

    point[0] += x_c
    point[1] += y_c
    point[2] += z_c
    point = np.append(point, [-3.14, 0, 0])
    return point.tolist()

if __name__ == "__main__":
    # 导入数据
    # # 水
    # data = "./水FGMM.mat"
    # strokeOrder=[1, 0, 3, 2]

    # 上
    data = "./寸.mat"
    strokeOrder=[0, 1, 2]   

    # # 下
    # data = "./下.mat"
    # strokeOrder=[0, 1, 2]   

    # DMP泛化
    track, numStroke, numStep = DmpCalculate(data, [0.8, 0.8], 0.2)

    # 初始化艾利特
    my_elt = startElite()

    # 对每个笔画
    # yong
    # for i in [3,1,0,2]:
    # shang
    # for i in [1,-2,0]:
    # cun
    for i in strokeOrder:
        # for i in range(numStroke):
        # 计算笔画角度
        print(i)
        direct = track[i * 3 : i * 3 + 2, 1] - track[i * 3 : i * 3 + 2, -1]
        strokeAngle = getNewAngle(direct)

        moveDir = np.sign(i)

        # 移动到笔画起点
        startPoint = getNewPoint(track[i * 3 : i * 3 + 3, 0], 300)
        moveSlow(startPoint, strokeAngle)

        # 初始化透传
        transInit()

        # 移动每一步
        if moveDir >= 0:
            for j in range(1, numStep - 2):
                movePoint = getNewPoint(track[i * 3 : i * 3 + 3, j])
                move(movePoint, strokeAngle)
        else:
            for j in range(numStep - 2, 0, -1):
                movePoint = getNewPoint(track[i * 3 : i * 3 + 3, j])
                move(movePoint, strokeAngle)

        # 移动到笔画终点
        endPoint = getNewPoint(track[i * 3 : i * 3 + 3, -1], 300)
        move(endPoint, strokeAngle)
    # 移动到笔画起点
    startPoint = getNewPoint([0,0,0], 300)
    moveSlow(startPoint, strokeAngle)
    # test ssh
