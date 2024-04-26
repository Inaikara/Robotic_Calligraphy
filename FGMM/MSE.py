from skimage.metrics import mean_squared_error
from PIL import Image
import numpy as np

input = np.array(Image.open("./Result/0.bmp"))
output1 = np.array(Image.open("./Result/1.bmp"))
output2 = np.array(Image.open("./Result/2.bmp"))
output3 = np.array(Image.open("./Result/3.bmp"))

score1 = mean_squared_error(input, output1)
score2 = mean_squared_error(input, output2)
score3 = mean_squared_error(input, output3)

print(score1,score2,score3)
