"""
example of elite transparent transmission initialization.
"""
import elite_ci

if __name__ == "__main__":
    robot_ip = "192.168.1.200"
    my_elt = elite_ci.Elt(robot_ip)

    if my_elt.getServoStatus() == False:
        ret = my_elt.setServoStatus(1)
        print('set servo status:', ret)

    if my_elt.getMotorStatus() == False:
        ret = my_elt.syncMotorStatus()
        print('synchronize motor status:', ret)

    while my_elt.getTransparentTransmissionState() == 1:
        ret = my_elt.ttClearServoJointBuf()
        print('clear transparent transmission buffer:', ret)

    ret = my_elt.transparentTransmissionInit(400, 0.01 * 1000, 0.1)
    print('transparent transmission init:', ret)

    ret = my_elt.getTransparentTransmissionState()
    print('get transparent transmission state:', ret)

    # pre-fill transparent transmission buffer
    current_joint_angle = my_elt.getRobotPos()
    print(current_joint_angle)
    ret = my_elt.ttPutServoJointToBuf(current_joint_angle)


