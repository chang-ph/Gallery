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

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")))
    return (df['cafe'].to_list(), df['afternoon'].to_list(), df['wait'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)
