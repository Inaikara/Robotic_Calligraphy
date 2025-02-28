import cv2
import numpy as np

# 加载相机标定数据
calibration_data = np.load('action4.npz')
camera_matrix = calibration_data['camera_matrix']
dist_coeffs = calibration_data['dist_coeffs']

# 加载预定义的字典
aruco_dict = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_6X6_250)
parameters = cv2.aruco.DetectorParameters()

# 打开摄像头
cap = cv2.VideoCapture(1)

while True:
    ret, frame = cap.read()
    if not ret:
        break
    
    frame = cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
    # 转换为灰度图像
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # 检测ArUco码
    corners, ids, rejected = cv2.aruco.detectMarkers(gray, aruco_dict, parameters=parameters)

    # 如果检测到ArUco码
    if ids is not None:
        # 绘制检测到的标记q
        cv2.aruco.drawDetectedMarkers(frame, corners, ids)

        # 估计每个标记的姿态
        rvecs, tvecs, _ = cv2.aruco.estimatePoseSingleMarkers(corners, 0.05, camera_matrix, dist_coeffs)

        for i in range(len(ids)):
            # 绘制坐标轴
            cv2.drawFrameAxes(frame, camera_matrix, dist_coeffs, rvecs[i], tvecs[i], 0.05)
            
            # 获取并打印笛卡尔坐标轴
            rvec = rvecs[i]
            tvec = tvecs[i]
            print(f"ID: {ids[i][0]} - rvec: {rvec.flatten()} tvec: {tvec.flatten()}")

    # 显示结果
    cv2.imshow('Aruco Detection', frame)

    # 按下 'q' 键退出循环
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放摄像头并关闭所有窗口
cap.release()
cv2.destroyAllWindows()
