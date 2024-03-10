import socket
import json
import time

def connectETController(ip, port=8055):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((ip, port))
        return (True, sock)
    except Exception as e:
        sock.close()
        return (False,)

def disconnectETController(sock):
    if (sock):
        sock.close()
        sock = None
    else:
        sock = None

def sendCMD(sock, cmd, params=None, id=1):
    if (not params):
        params = []
    else:
        params = json.dumps(params)
    sendStr = "{{\"method\":\"{0}\",\"params\":{1},\"jsonrpc\":\"2.0\",\"id\":{2}}}".format(cmd, params,id) + "\n"
    try:
        sock.sendall(bytes(sendStr, "utf-8"))
        ret = sock.recv(1024)
        jdata = json.loads(str(ret, "utf-8"))
        if ("result" in jdata.keys()):
            return (True, json.loads(jdata["result"]), jdata["id"])
        elif ("error" in jdata.keys()):
            return (False, jdata["error"], jdata["id"])
        else:
            return (False, None, None)
    except Exception as e:
        return (False, None, None)



"""
1. ServoService
"""
def getServoStatus(sock):
    """get robot servo status
    param: sock
    return: bool result, True(active)/False(inactive)
    """
    suc, result, id = sendCMD(sock, "getServoStatus")
    return result

def setServoStatus(sock, status):
    """set robot servo status
    param: sock
    param: int status, 1(open)/0(close)
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "set_servo_status", {"status":status})
    time.sleep(1)
    return result

def syncMotorStatus(sock):
    """sync motor status
    param: sock
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "syncMotorStatus")
    time.sleep(0.5)
    return result

def clearAlarm(sock):
    """clear alarm
    param: sock
    return bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "clearAlarm")
    return result

def getMotorStatus(sock):
    """get motor sync status
    param: sock
    return: bool result, True(sync)/False(unsync)
    """
    suc, result, id = sendCMD(sock, "getMotorStatus")
    return result



"""
2. ParamService
"""
def getRobotState(sock):
    """get robot state
    param: sock
    return int result, 0(stop)/1(pause)/2(emergency stop)/3(run)/4(error)/5(collision)
    """
    suc, result, id = sendCMD(sock, "getRobotState")
    return result

def getRobotMode(sock):
    """get robot mode
    param: sock
    return: int result, 0(teach)/1(play)/2(remote)
    """
    suc, result, id = sendCMD(sock, "getRobotMode")
    return result

def getRobotPos(sock):
    """get robot current position
    param: sock
    return: list result, robot current position
    """
    suc, result, id = sendCMD(sock, "getRobotPos")
    return result

def getRobotPose(sock, coorddinate_num=-1, tool_num=-1):
    """get robot current position and orientation
    param: sock
    param: int coorddinate_num, -1(base frame), [0, 7](corresponding user frame)
    param: int tool_num, -1(current tool number), [0, 7](corresponding tool number)
    return: list result, robot current position and orientation
    """
    suc, result, id = sendCMD(sock, "getRobotPose", 
    {"coorddinate_num":coorddinate_num, "tool_num":tool_num})
    return result

def getMotorSpeed(sock):
    """get robot motor speed
    param: sock
    return: list result, robot motor speed
    """
    suc, result, id = sendCMD(sock, "getMotorSpeed")
    return result

def getCurrentCoord(sock):
    """get robot current coordinate system
    param: sock
    return: int result, 0(joint)/1(Cartesian)/2(tool)/3(user)/4(cylinder)
    """
    suc, result, id = sendCMD(sock, "getCurrentCoord")
    return result

# getCycleMode()
# getCurrentJobLine()
# getCurrentEncode()
# getToolNumber()
# setToolNumber()
# getUserNumber()
# setUserNumber()

def getRobotTorques(sock):
    """get robot current torques
    param: sock
    return: list result, robot current torques
    """
    suc, result, id = sendCMD(sock, "getRobotTorques")
    return result

# getPathPointIndex()
# getAnalogInput()
# setAnalogOutput()

def setCurrentCoord(sock, coord_mode):
    """set robot current coordinate system
    param: sock
    param: int coord_mode, 0(joint)/1(Cartesian)/2(tool)/3(user)/4(cylinder)
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "setCurrentCoord", {"coord_mode":coord_mode})
    time.sleep(0.5)
    return result

def dragTeachSwitch(sock, switch):
    """open/close drag switch
    param: sock
    param: int switch, 0(close)/1(open)
    return: True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "drag_teach_switch", {"switch":switch})
    return result

def cmdSetPayload(sock, tool_num, m, point):
    """set robot payload and payload's center of gravity
    param: sock
    param: int tool_num, range[0, 7]
    param: int m, mass of payload(Kg), range[0, 7.2] for EC66
    param: list point, center of gravity of x, y and z(mm), range[-5000, 5000]
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "cmd_set_payload", 
    {"tool_num":tool_num, "m":m, "point":point})
    return result

def cmdSetTCP(sock, point, tool_num):
    """set robot TCP(tool center point)
    param: sock
    param: list point, position and orientation of TCP 
    param: int tool_num, tool number, range[0, 7]
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "cmd_set_tcp", {"point":point, "tool_num":tool_num})
    return result

def getCollisionState(sock):
    """get robot collision state
    param: sock
    return: int result, 1(collision)/0(no collision)
    """
    suc, result, id = sendCMD(sock, "getCollisionState")
    return result

# getUserFrame()
# setCycleMode()
# setUserFrame()

def getTCPPos(sock, tool_num):
    """get tool frame position and orientation
    param: sock
    param: int tool_num, tool number, range[0, 7]
    return: list result, tool frame position(x, y, z) and orientation(rx, ry, rz)
            the unit of rx, ry and rz is degree
    """
    suc, result, id = sendCMD(sock, "getTcpPos", {"tool_num":tool_num})
    return result

def getPayload(sock, tool_num):
    """get the mass of tool payload
    param: sock
    param: int tool_num, tool number, range[0, 7]
    return: double result, the mass of tool payload
    """
    suc, result, id = sendCMD(sock, "getPayload", {"tool_num":tool_num})
    return result

def getToolCentreMass(sock, tool_num):
    """get the canter mass of tool
    param: sock
    param: int tool_num, tool number, range[0, 7]
    return: list result, the canter mass of tool
    """
    suc, result, id = sendCMD(sock, "getCentreMass", {"tool_num":tool_num})
    return result

# getRobotType()
# getDH()
# setCollisionEnable()
# setCollisionSensitivity()
# setSafetyParams()
# getSpeed()
# resetCollisionState()
# getAutoRunToolNumber()
# setAutoRunToolNumber()

def getBaseFlangePose(sock):
    """get the position and orientation of flange in Cartesian coordinate system
    param: sock
    return: list result, the position and orientation of flange in Cartesian coordinate system
    """
    suc, result, id = sendCMD(sock, "get_base_flange_pose")
    return result

# get_user_flange_pose()
# setSysVarP()
# save_var_data()
# getRobotSubtype()
# getRobotSafetyParamsEnabled()
# getRobotSafeyPower()
# getRobotSafetyMomentum()
# getRobotSafetyToolForce()
# getRobotSafetyElbowForce()
# getRobotSpeedPercentage()
# getRobotDragStartupMaxSpeed()
# getRobotTorqueErrorMaxPercents()
# setFlangeButton()
# checkFlangeButton()



"""
3. MovementService
"""
def moveByJoint(sock, targetPos, speed, acc, dec, 
                cond_type=0, cond_num=7, cond_value=1):
    """move by joint
    
    """
    suc, result, id = sendCMD(sock, "moveByJoint",{"targetPos":targetPos,
    "speed":speed, "acc":acc, "dec":dec, "cond_type":cond_type, "cond_num":cond_num,
    "cond_value":cond_value})
    return result

def moveByLine(sock, targetPos, speed_type, speed, acc, dec, 
                cond_type=0, cond_num=7, cond_value=1):
    """move by line
    
    """
    suc, result, id = sendCMD(sock, "moveByLine",{"targetPos":targetPos,
    "speed_type":speed_type, "speed":speed, "acc":acc, "dec":dec,
    "cond_type":cond_type, "cond_num":cond_num, "cond_value":cond_value})
    return result

def moveByArc(sock, midPos, targetPos, speed_type, speed, 
            cond_type=0, cond_num=7, cond_value=1):
    """move by arc
    
    """
    suc, result, id = sendCMD(sock, "moveByArc",{"midPos":midPos, 
    "targetPos":targetPos, "speed_type":speed_type, "speed":speed, 
    "cond_type":cond_type, "cond_num":cond_num, "cond_value":cond_value})
    return result

# moveByRotate()
# addPathPoint()
# clearPathPoint()
# moveByPath()
# jog()

def stop(sock):
    """stop robot
    param: sock
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "stop")
    return result

def run(sock):
    """run robot
    param: sock
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "run")
    return result

def pause(sock):
    """pause robot
    param: sock
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "pause")
    return result

# checkJbiExist()
# runJbi()
# getJbiState()
# setSpeed()
# moveBySpeedj()
# moveBySpeedl()



"""
4. KinematicsService
"""
def inverseKinematic(sock, targetPose):
    """robot inverse kinematics
    param: sock
    param: list targetPose, target position and orientation
    return: list result, corresponding joint angles
    """
    suc, result, id = sendCMD(sock, "inverseKinematic", {"targetPose":targetPose})
    return result

def positiveKinematic(sock, targetPose):
    """robot positive kinematics
    param: sock
    param: list targetPose, target joint angles
    return: list result, corresponding position and orientation
    """
    suc, result, id = sendCMD(sock, "positiveKinematic", {"targetPose":targetPose})
    return result

# convertPoseFromCartToUser()
# convertPoseFromUserToCart()
# inverseKinematic()
# poseMul()
# poseInv()



"""
5. IOService
"""



"""
6. VarService
"""



"""
7. TransparentTransmissionService
"""
def transparentTransmissionInit(sock, lookahead, t, smoothness):
    """initialize robot transparent transmission
    param: sock
    param: double lookahead, lookahead time(ms), range[10, 1000]
    param: double t, sample time(ms), range[2, 100]
    param: double smoothness, gain, range[0, 1]
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "transparent_transmission_init", 
    {"lookahead":lookahead, "t":t, "smoothness":smoothness})
    return result

def ttSetCurrentServoJoint(sock, targetPos):
    """set current transparent transmission servo target joint angles
    param: sock
    param: list targetPos, target joint angles
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "tt_set_current_servo_joint", {"targetPos":targetPos})
    return result

def ttPutServoJointToBuf(sock, targetPos):
    """put transparent transmission servo target joint angles to buffer
    param: sock
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "tt_put_servo_joint_to_buf", {"targetPos":targetPos})
    return result

def ttClearServoJointBuf(sock, clear=0):
    """clear transparent transmission buffer
    param: int clear, 0
    return: bool result, True(success)/False(fail)
    """
    suc, result, id = sendCMD(sock, "tt_clear_servo_joint_buf", {"clear":clear})
    time.sleep(0.5)
    return result

def getTransparentTransmissionState(sock):
    """get current robot transparent transmission state
    param: sock
    return: bool result, current tt state
    """
    suc, result, id = sendCMD(sock, "get_transparent_transmission_state")
    return result



"""
8. SystemService
"""
def getSoftVersion(sock):
    """get controller software version
    param: sock
    return: result, controller software version
    """
    suc, result, id = sendCMD(sock, "getSoftVersion")
    return result

def getJointVersion(sock, axis):
    """get joint servo version
    param: sock
    param: int axis, range[0, 7] corresponding to axis 1-8
    return: joint servo version
    """
    suc, result, id = sendCMD(sock, "getJointVersion", {"axis":axis})
    return result



if __name__ == "__main__":
    robot_ip = "192.168.1.200"
    conSuc, sock = connectETController(robot_ip)
    if (conSuc):
        suc, result, id = sendCMD(sock, "getRobotState")
    print(suc, result, id)
