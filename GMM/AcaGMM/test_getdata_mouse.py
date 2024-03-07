from tkinter import * #导入模块

import numpy as np
from getdata_image import *

def paint(event):
    x1,y1 = (event.x - 0.1), (event.y - 0.1)
    x2,y2 = (event.x + 0.1), (event.y + 0.1)
    print(event.x, event.y)
    data.append([event.x, event.y])
    cv.create_oval(x1, y1, x2, y2, fill = "green") #颜色

root = Tk()
cv = Canvas(root, width = 1000, height = 500) #画布大小
cv.pack(expand = YES, fill = BOTH)
cv.bind("<B1-Motion>", paint)

Data = getdata_image('sigmoid.png')
# Data = np.loadtxt('data2.txt',delimiter=',')[0:2,:]
# Data[0,:] += 10
# Data[1,:] += 0.08
# Data[1,:] *= 1000
# # print(type(Data))
# for i in range(Data.shape[1]):
#     data_x_1 = Data[0,i]-0.1
#     data_y_1 = Data[1,i]-0.1
#     data_x_2 = Data[0,i]+0.1
#     data_y_2 = Data[1,i]+0.1
#     cv.create_oval(data_x_1, data_y_1, data_x_2, data_y_2, fill = "green") #颜色

data = []

mainloop() #循环

np.savetxt('data_526.txt',data, delimiter=',')