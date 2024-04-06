import matplotlib.pyplot as plt
import numpy as np
from sympy import *
a = np.linspace(-5,5,100)
b = a * a * 0.5 + 0.5
# print(a)

x = Symbol('x')
y = Symbol('y')
func = [x-2+x*(y-6), y-0.5*x*x-0.5]
solved = solve(func, [x, y])
solved = np.array(solved)
for i in range(0, solved.shape[0]):
    if type(solved[i, 0])==Add:
        solved[i,0] = complex(solved[i, 0])
        if abs(solved[i, 0].imag) > 0.00000001:
            continue
        elif abs(solved[i, 0].imag) < 0.00000001:
            solved[i, 0] = solved[i, 0].real
    if type(solved[i, 1])==Add:
        solved[i,1] = complex(solved[i, 1])
        if abs(solved[i, 1].imag) > 0.00000001:
            continue
        elif abs(solved[i, 1].imag) < 0.00000001:
            solved[i, 1] = solved[i, 1].real
plt.plot(a+6,b,c='b')
plt.scatter(2+6,6,c='r',label='Sample points')
plt.scatter(solved[:,0]+6, solved[:, 1],label='Projection Point')
for i in range(3):
    plt.plot(np.array([2,solved[i,0]])+6, [6,solved[i,1]], c = 'red', ls='dotted')
plt.legend()
plt.xlim(0,12)
plt.ylim(0,12)
plt.rcParams['font.sans-serif']=['SimHei']
plt.show()