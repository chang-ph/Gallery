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

    df['log_pop'] = np.log(df['population'])
    df['contact_high'] = df['contact'].apply(lambda x: 1 if x == 'high' else 0)

    return (df['total_tools'].to_list(), df['log_pop'].to_list(), df['contact_high'].to_list())

flow = current_workflow()
flow.parse_data(interpret_data)
