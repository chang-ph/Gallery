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
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';')
#     first(df, 10)
#     return (df.pulled_left, df.actor, df.condition, df.prosoc_left)
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data), delimiter=';')
    print(df.head(10))
    return (df['pulled_left'], df['actor'], df['condition'], df['prosoc_left'])

flow = current_workflow()
flow.parse_data(interpret_data)