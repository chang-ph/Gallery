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
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';')
#     return [df.admit, df.reject]
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data), delimiter=';')
    return [df['admit'], df['reject']]

flow = current_workflow()
flow.parse_data(interpret_data)