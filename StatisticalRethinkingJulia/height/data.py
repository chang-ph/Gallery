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
#     df = filter(row -> row.age >= 18, df);
#     return [df.height]
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data), delimiter=';')
    df = df[df['age'] >= 18]
    return [df['height']]

flow = current_workflow()
flow.parse_data(interpret_data)