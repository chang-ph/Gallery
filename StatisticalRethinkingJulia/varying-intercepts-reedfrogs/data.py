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
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';');
#     @assert size(df) == (48, 5) ## hide
#     df.tank_index = 1:nrow(df)
#     return (df.density, df.tank_index, df.surv)
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')
    assert df.shape == (48, 5)  # hide
    df['tank_index'] = range(1, len(df) + 1)
    return (df['density'].to_list(), df['tank_index'].to_list(), df['surv'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)