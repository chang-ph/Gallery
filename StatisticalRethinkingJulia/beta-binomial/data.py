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
#     return [df.admit, df.applications]
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), sep=';')
    return [df['admit'].to_list(), df['applications'].to_list()]

flow = current_workflow()
flow.parse_data(interpret_data)