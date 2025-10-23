
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
    return [df.admit, df.reject]
end

flow = current_workflow()
flow.parse_data(interpret_data)
