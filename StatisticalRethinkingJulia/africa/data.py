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

def interpret_data(data: bytes):
    df = pd.read_csv(StringIO(data.decode('utf-8')), sep=';')
    df['log_gdp'] = np.log(df['rgdppc_2000'])
    df = df.dropna()
    return [df['log_gdp'], df['rugged'], df['cont_africa']]

print("#####1")
flow = current_workflow()
flow.parse_data(interpret_data)
print("#####2")
