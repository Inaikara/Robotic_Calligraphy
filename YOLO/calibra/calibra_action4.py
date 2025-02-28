import cv2
import numpy as np
import glob

# 设置棋盘格的内角点尺寸（11列8行）
checkerboard_size = (11, 8)

# 设置每个方格的实际大小（20毫米 = 0.02米）
square_size = 0.02  # 单位：米

# 准备对象点：如 (0,0,0), (1,0,0), (2,0,0) ... 假设每个方格的实际尺寸为 square_size
objp = np.zeros((checkerboard_size[0] * checkerboard_size[1], 3), np.float32)
objp[:, :2] = np.mgrid[0:checkerboard_size[0], 0:checkerboard_size[1]].T.reshape(-1, 2) * square_size

# 用于存储对象点和图像点
objpoints = []  # 3D点
imgpoints = []  # 2D点

# 获取标定图像文件
images = glob.glob('calibra/*.jpg')  # 替换为你的图像路径

for fname in images:
    img = cv2.imread(fname)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 寻找棋盘格角点
    ret, corners = cv2.findChessboardCorners(gray, checkerboard_size, None)
    
    if ret:
        objpoints.append(objp)
        imgpoints.append(corners)
        
        # 绘制角点
        cv2.drawChessboardCorners(img, checkerboard_size, corners, ret)
        cv2.imshow('Corners', img)
        cv2.waitKey(100)

cv2.destroyAllWindows()

# 标定相机
ret, camera_matrix, dist_coeffs, rvecs, tvecs = cv2.calibrateCamera(objpoints, imgpoints, gray.shape[::-1], None, None)

# 输出标定参数
print("Camera matrix:\n", camera_matrix)
print("Distortion coefficients:\n", dist_coeffs)

# 保存标定结果
np.savez('calibration_data.npz', camera_matrix=camera_matrix, dist_coeffs=dist_coeffs)

# 畸变校正示例
img = cv2.imread('test.jpg')  # 替换为你要校正的图像
h, w = img.shape[:2]
new_camera_matrix, roi = cv2.getOptimalNewCameraMatrix(camera_matrix, dist_coeffs, (w, h), 1, (w, h))

# 校正图像
dst = cv2.undistort(img, camera_matrix, dist_coeffs, None, new_camera_matrix)

# 裁剪图像
x, y, w, h = roi
dst = dst[y:y+h, x:x+w]

cv2.imshow('Undistorted Image', dst)
cv2.waitKey(0)
cv2.destroyAllWindows()
