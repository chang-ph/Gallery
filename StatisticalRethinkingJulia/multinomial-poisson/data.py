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
#
#     dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
#     df.male = [g == "male" ? 1 : 0 for g in df.gender]
#     df.dept_id = [dept_map[de] for de in df.dept]
#     return (df.applications, df.dept_id, df.male, df.admit)
# end

# Python implementation
def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')

    # Create department mapping
    dept_map = {key: idx + 1 for idx, key in enumerate(df['dept'].unique())}  # +1 to match Julia's 1-based indexing
    df['male'] = [1 if g == "male" else 0 for g in df['gender']]
    df['dept_id'] = [dept_map[de] for de in df['dept']]

    return (df['applications'].to_list(), df['dept_id'].to_list(), df['male'].to_list(), df['admit'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)