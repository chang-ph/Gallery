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
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')
    return [df['admit'].to_list(), df['reject'].to_list()]

flow = current_workflow()
flow.parse_data(interpret_data)
