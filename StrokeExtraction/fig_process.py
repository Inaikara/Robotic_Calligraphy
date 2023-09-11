import cv2 as cv
import numpy as np


# 摄像头调用
def video_demo():
    capture = cv.VideoCapture(1)  # 0为电脑内置摄像头
    while True:
        ret, frame = capture.read()  # 摄像头读取,ret为是否成功打开摄像头,true,false。 frame为视频的每一帧图像
        frame = cv.flip(frame, 1)  # 摄像头是和人对立的，将图像左右调换回来正常显示。
        cv.imshow("video", frame)
        c = cv.waitKey(50)

# 摄像头输入
def read_camera(capture):
    ret, frame = capture.read()  # 摄像头读取,ret为是否成功打开摄像头,true,false。 frame为视频的每一帧图像
    frame = cv.flip(frame, 1)  # 摄像头是和人对立的，将图像左右调换回来正常显示。
    return frame

# 本地图像输入
def read_figure(name):
    name = "./figure/" + name
    img = cv.imread(name)
    return img


# 图像预处理
def process_figure(img):
    # 灰度化
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    # 二值化
    _, img = cv.threshold(img, 150, 255, cv.THRESH_BINARY_INV)

    # # 细化
    # img[img == 255] = 1
    # img = morphology.skeletonize(img)
    # img = img.astype(np.uint8) * 255

    return img


# 图像保存
def save_figure(img):
    cv.imwrite("./figure/new.png", img)


if __name__ == "__main__":
    capture = cv.VideoCapture(0)
    while True:   
        img=read_camera(capture)
        img=process_figure(img)
        cv.imshow("video", img)
        c = cv.waitKey(40)
    # img = fig_process("shui.jpg")
    # save_figure(img)
