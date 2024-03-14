from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

def getdata_image(image):
    img = Image.open(image).convert('L')
    img_data = np.asarray(img)
    print(img_data.shape)
    k = 0
    data = []

    for i in range(0, img_data.shape[0]):
        for j in range(0, img_data.shape[1]):
            if img_data[i, j] != 255:
                data.append([i, j])
                k += 1
    data = np.array(data).T
    print(data)
    Data = []
    len = 300
    for i in range(0, int(data.shape[1]/len)):
        Data.append(data[:, i * len])
    Data = np.array(Data).T
    # plt.scatter(Data[0,:],Data[1,:])
    # plt.show()
    return Data

