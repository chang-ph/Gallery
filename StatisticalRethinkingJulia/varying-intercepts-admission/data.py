
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

    dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
    df.male = [g == "male" ? 1 : 0 for g in df.gender]
    df.dept_id = [dept_map[de] for de in df.dept]
    return (df.applications, df.dept_id, df.male, df.admit)
end

flow = current_workflow()
flow.parse_data(interpret_data)
