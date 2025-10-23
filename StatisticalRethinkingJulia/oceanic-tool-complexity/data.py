
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
    df.contact_high = [contact == "high" ? 1 : 0 for contact in df.contact]

    return (df.total_tools, df.log_pop, df.contact_high)
end

flow = current_workflow()
flow.parse_data(interpret_data)
