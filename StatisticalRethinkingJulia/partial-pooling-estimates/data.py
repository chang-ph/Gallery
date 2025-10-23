
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
    μ = 1.4
    σ = 1.5
    nponds = 60
    ni = repeat([5, 10, 25, 35]; inner=15)

    a_pond = rand(Normal(μ, σ), nponds)

    dsim = DataFrame(; pond=1:nponds, ni=ni, true_a=a_pond)

    prob = logistic.(dsim.true_a)

    dsim.s = [rand(Binomial(ni[i], prob[i])) for i in 1:nponds]

    dsim.p_nopool = dsim.s ./ dsim.ni;

    return (dsim.pond, dsim.s, dsim.ni)
end

flow = current_workflow()
flow.parse_data(interpret_data)
