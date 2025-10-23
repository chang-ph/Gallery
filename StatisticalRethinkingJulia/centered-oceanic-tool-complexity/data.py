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

# Julia code was here:
# function interpret_data(data)
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';')
#
#     df.log_pop = log.(df.population)
#     df.contact_high = [contact == "high" ? 1 : 0 for contact in df.contact]
#
#     # New col where we center(!) the log_pop values
#     mean_log_pop = mean(df.log_pop)
#     df.log_pop_c = map(x -> x - mean_log_pop, df.log_pop)
#     return [df.total_tools, df.log_pop_c, df.contact_high]
# end

# Python implementation
function interpret_data(data):
    df = pd.read_csv(StringIO(data), delimiter=';')

    df['log_pop'] = np.log(df['population'])
    df['contact_high'] = np.where(df['contact'] == "high", 1, 0)

    # New col where we center(!) the log_pop values
    mean_log_pop = df['log_pop'].mean()
    df['log_pop_c'] = df['log_pop'] - mean_log_pop
    return [df['total_tools'], df['log_pop_c'], df['contact_high']]

flow = current_workflow()
flow.parse_data(interpret_data)