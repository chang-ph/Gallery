
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
    x = repeat([-1], 9);
    append!(x, repeat([1], 11));
    y = repeat([0], 10);
    append!(y, repeat([1], 10));
    return (x, y)
end

flow = current_workflow()
flow.parse_data(interpret_data)
