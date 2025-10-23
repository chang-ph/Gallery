
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
    df = CSV.read(IOBuffer(data), DataFrame; delim=';');
    @assert size(df) == (48, 5) ## hide
    df.tank_index = 1:nrow(df)
    return (df.density, df.tank_index, df.surv)
end

flow = current_workflow()
flow.parse_data(interpret_data)
