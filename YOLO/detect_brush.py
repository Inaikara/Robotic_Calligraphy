import cv2
from ultralytics import YOLO

# 提示用户选择摄像头索引
camera_index = 1

# 打开选择的摄像头
cap = cv2.VideoCapture(camera_index)

# 检查摄像头是否成功打开
if not cap.isOpened():
    print(f"无法打开索引为 {camera_index} 的摄像头")
    exit()

# 加载YOLOv8模型
model = YOLO('pen_4.pt')  # 这里加载你训练好的YOLOv8模型

while True:
    # 逐帧捕获
    ret, frame = cap.read()

    # 检查是否成功读取帧
    if not ret:
        print("无法接收帧（可能是摄像头断开连接）")
        break
    frame = cv2.rotate(frame, cv2.ROTATE_90_CLOCKWISE)
    # 使用YOLOv8模型进行预测
    results = model(frame)

    # 过滤置信度低于0.5的检测结果
    filtered_results = results[0].boxes[results[0].boxes.conf > 0.5]

    # 创建一个新的结果对象以绘制过滤后的检测结果
    results[0].boxes = filtered_results

    # 解析预测结果并绘制检测框
    annotated_frame = results[0].plot()

    # 显示带有检测结果的帧
    cv2.imshow('YOLOv8 Detection', annotated_frame)

    # 按下 'q' 键退出循环
    if cv2.waitKey(1) == ord('q'):
        break

# 释放摄像头并关闭窗口
cap.release()
cv2.destroyAllWindows()
