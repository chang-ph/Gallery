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
    print(df.head(10))
    return (df['pulled_left'].to_list(), df['actor'].to_list(), df['condition'].to_list(), df['prosoc_left'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)
