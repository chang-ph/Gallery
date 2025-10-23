
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

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')
    df.log_pop = log.(df.population)
    df.society = 1:nrow(df)
    return (df.total_tools, df.log_pop, df.society)
end

flow = current_workflow()
flow.parse_data(interpret_data)
