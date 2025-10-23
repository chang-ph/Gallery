
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
    df = filter(row -> row.age >= 18, df);
    return [df.height]
end

flow = current_workflow()
flow.parse_data(interpret_data)
