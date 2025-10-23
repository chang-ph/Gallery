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
#     df.tank = 1:nrow(df)
#     return (df.density, df.tank, df.surv)
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')
    df['tank'] = range(1, len(df) + 1)
    return (df['density'].to_list(), df['tank'].to_list(), df['surv'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)