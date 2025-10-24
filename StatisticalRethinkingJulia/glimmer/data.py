# /// script
# dependencies = [
#   "pandas",
#   "numpy",
#   "bokeh",
#   "requests",
# ]
# ///

import pandas as pd
import numpy as np
from io import StringIO
from Coinfer import current_workflow

# Julia code:
# function interpret_data(data)
#     x = repeat([-1], 9);
#     append!(x, repeat([1], 11));
#     y = repeat([0], 10);
#     append!(y, repeat([1], 10));
#     return (x, y)
# end

def interpret_data(data):
    x = np.repeat(-1, 9).tolist()
    x.extend(np.repeat(1, 11).tolist())
    y = np.repeat(0, 10).tolist()
    y.extend(np.repeat(1, 10).tolist())
    return (x, y)

flow = current_workflow()
flow.parse_data(interpret_data)
