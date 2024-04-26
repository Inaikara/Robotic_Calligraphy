from skimage.metrics import variation_of_information
from PIL import Image
import numpy as np
# 越小越好

input = np.array(Image.open("./Result/0.bmp"))
output1 = np.array(Image.open("./Result/1.bmp"))
output2 = np.array(Image.open("./Result/2.bmp"))
output3 = np.array(Image.open("./Result/3.bmp"))

score1 = variation_of_information(input, output1)
score2 = variation_of_information(input, output2)
score3 = variation_of_information(input, output3)

print(np.sum(score1),np.sum(score2),np.sum(score3))
