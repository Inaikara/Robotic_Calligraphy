import cv2
import numpy as np
import csv
import os
from ultralytics import YOLO

class VideoFileDetection:
    def __init__(self, yolo_model_path, aruco_dict_type=cv2.aruco.DICT_6X6_250, video_file=None):
        if not video_file:
            raise ValueError("必须提供视频文件名")
        
        # 加载相机标定数据
        calibration_data = np.load("action4.npz")
        self.camera_matrix = calibration_data["camera_matrix"]
        self.dist_coeffs = calibration_data["dist_coeffs"]

        # ArUco标定板的真实尺寸 (单位: 米)
        self.aruco_marker_size = 0.095  # 95毫米 = 0.095米

        # 加载YOLO模型
        self.model = YOLO(yolo_model_path)

        # 加载ArUco字典和设置参数
        self.aruco_dict = cv2.aruco.getPredefinedDictionary(aruco_dict_type)
        self.parameters = cv2.aruco.DetectorParameters()
        # 调整ArUco检测参数
        self.parameters.adaptiveThreshConstant = 7
        self.parameters.minMarkerPerimeterRate = 0.03
        self.parameters.maxMarkerPerimeterRate = 4.0
        self.parameters.minCornerDistanceRate = 0.05
        self.parameters.minDistanceToBorder = 3
        self.parameters.cornerRefinementMethod = cv2.aruco.CORNER_REFINE_SUBPIX

        # 打开视频文件
        self.cap = cv2.VideoCapture(video_file)
        self.csv_filename = os.path.splitext(os.path.basename(video_file))[0] + ".csv"

        # 初始化CSV文件
        with open(self.csv_filename, mode="w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(["Video Time (ms)", "Aruco Horizontal Distance (mm)", "Brush Length (mm)"])

    def process_frame(self, frame, video_time):
        # YOLO检测
        results = self.model(frame)
        filtered_results = results[0].boxes[results[0].boxes.conf > 0.5]

        aruco_distance_x = None
        brush_height_mm = None

        # ArUco检测
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        corners, ids, _ = cv2.aruco.detectMarkers(gray, self.aruco_dict, parameters=self.parameters)

        if ids is not None:
            rvecs, tvecs, _ = cv2.aruco.estimatePoseSingleMarkers(corners, self.aruco_marker_size, self.camera_matrix, self.dist_coeffs)

            # 获取标记距离相机的水平方向距离 (x方向)，并转换为毫米
            aruco_distance_x = tvecs[0][0][0] * 1000  # x方向的距离

            # 在左上角显示距离
            cv2.putText(
                frame,
                f"ArUco Horizontal Distance: {aruco_distance_x:.2f} mm",
                (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX,
                1,
                (255, 0, 0),
                2,
            )

            # 定义ArUco标记的四个角点的3D坐标
            aruco_corners_3d = np.array(
                [
                    [-self.aruco_marker_size / 2, self.aruco_marker_size / 2, 0],
                    [self.aruco_marker_size / 2, self.aruco_marker_size / 2, 0],
                    [self.aruco_marker_size / 2, -self.aruco_marker_size / 2, 0],
                    [-self.aruco_marker_size / 2, -self.aruco_marker_size / 2, 0],
                ],
                dtype=np.float32,
            )

            # 投影3D角点到图像平面
            img_points, _ = cv2.projectPoints(
                aruco_corners_3d,
                rvecs[0],
                tvecs[0],
                self.camera_matrix,
                self.dist_coeffs,
            )

            # 计算投影点之间的距离（对角线长度）
            aruco_diag_pixel = np.linalg.norm(img_points[0] - img_points[2])
            pixel_per_meter = aruco_diag_pixel / (self.aruco_marker_size * np.sqrt(2))

            # 用这个比例来测量YOLO检测框的实际垂直尺寸
            for box in filtered_results:
                y1, y2 = int(box.xyxy[0][1]), int(box.xyxy[0][3])
                brush_height_mm = int((y2 - y1) / pixel_per_meter * 1000)  # 转换为毫米单位并取整
                conf = float(box.conf[0])
                cls = int(box.cls[0])
                label = f"{self.model.names[cls]} {conf:.2f} ({brush_height_mm}mm)"

                # 绘制边界框和标签
                cv2.rectangle(
                    frame,
                    (int(box.xyxy[0][0]), y1),
                    (int(box.xyxy[0][2]), y2),
                    (0, 255, 0),
                    2,
                )
                cv2.putText(
                    frame,
                    label,
                    (int(box.xyxy[0][0]), y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.9,
                    (0, 255, 0),
                    2,
                )

        # 如果识别到Aruco水平距离和Brush长度，则记录数据
        if aruco_distance_x is not None and brush_height_mm is not None:
            with open(self.csv_filename, mode="a", newline="") as file:
                writer = csv.writer(file)
                writer.writerow([video_time, aruco_distance_x, brush_height_mm])

        frame_resized = cv2.resize(frame, (640, 400))
        return frame_resized

    def run(self):
        while True:
            ret, frame = self.cap.read()
            if not ret:
                break

            # 获取当前帧在视频中的时间（毫秒）
            video_time = self.cap.get(cv2.CAP_PROP_POS_MSEC)

            # 处理当前帧
            processed_frame = self.process_frame(frame, video_time)

            # 显示处理后的帧
            cv2.imshow("YOLO and ArUco Detection with Measurement", processed_frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                break

        self.cap.release()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    video_file = "data/map_data/video/01.mp4"  # 设置为输入视频文件名
    measurement = VideoFileDetection(yolo_model_path="model-best.pt", video_file=video_file)
    measurement.run()
