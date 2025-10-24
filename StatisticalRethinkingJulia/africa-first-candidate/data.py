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

# function interpret_data(data)
#     df = CSV.read(IOBuffer(data), DataFrame; delim=';')

#     df.log_gdp = log.(df.rgdppc_2000)
#     dropmissing!(df)

#     df = select(df, :log_gdp, :rugged, :cont_africa);

#     df.log_gdp_std = df.log_gdp ./ mean(df.log_gdp)
#     df.rugged_std = df.rugged ./ maximum(df.rugged)

#     first(df, 8)
#     return [df.log_gdp_std, df.rugged_std, mean(df.rugged_std)]
# end

def interpret_data(data):
    df = pd.read_csv(StringIO(data.decode("utf-8")), delimiter=';')

    df['log_gdp'] = np.log(df['rgdppc_2000'])
    df.dropna(inplace=True)

    df = df[['log_gdp', 'rugged', 'cont_africa']]

    df['log_gdp_std'] = df['log_gdp'] / df['log_gdp'].mean()
    df['rugged_std'] = df['rugged'] / df['rugged'].max()

    df.head(8)
    return [df['log_gdp_std'].to_list(), df['rugged_std'].to_list(), df['rugged_std'].mean()]

flow = current_workflow()
flow.parse_data(interpret_data)
