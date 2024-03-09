import numpy as np
from scipy.optimize import fsolve

def solve_function(unsolved_value,a,b,v1,v2):
    x = unsolved_value[0]
    y = unsolved_value[1]
    z = unsolved_value[2]
    return [
        x - a * x * z - v1,
        2 * y - z - 2 * v2,
        x - 2 * a * x * y + 2 * a * v2 - v1,
        y - a * x * x - b,
    ]


def projection_point(C, Q, T, x):
    a = C[0], b = C[1]
    x = x - T
    x = np.dot(x, Q)
    # x[:, [0, 1]] = x[:, [1, 0]]


