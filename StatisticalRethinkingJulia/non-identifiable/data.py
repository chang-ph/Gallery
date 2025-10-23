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

# function interpret_data(data)
#     y = rand(Normal(0, 1), 100);
#     return [y]
# end

def interpret_data(data):
    y = np.random.normal(0, 1, 100)
    return [y]

flow = current_workflow()
flow.parse_data(interpret_data)