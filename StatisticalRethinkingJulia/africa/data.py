# /// script
# dependencies = [
#   "pandas",
#   "numpy",
# ]
# ///

import pandas as pd
import numpy as np
from io import StringIO
from Coinfer import current_workflow

def interpret_data(data):
    df = pd.read_csv(StringIO(data), sep=';')
    df['log_gdp'] = np.log(df['rgdppc_2000'])
    df = df.dropna()
    return [df['log_gdp'], df['rugged'], df['cont_africa']]

flow = current_workflow()
flow.parse_data(interpret_data)
