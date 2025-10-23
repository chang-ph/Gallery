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
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';');
#     return (df.pulled_left, df.actor, df.condition, df.prosoc_left)
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')
    return (df['pulled_left'], df['actor'], df['condition'], df['prosoc_left'])

flow = current_workflow()
flow.parse_data(interpret_data)