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

# Julia代码:
# function interpret_data(data)
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';')
#     df.log_pop = log.(df.population)
#     df.society = 1:nrow(df)
#     return (df.total_tools, df.log_pop, df.society)
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')
    df['log_pop'] = np.log(df['population'])
    df['society'] = range(1, len(df) + 1)
    return (df['total_tools'], df['log_pop'], df['society'])

flow = current_workflow()
flow.parse_data(interpret_data)