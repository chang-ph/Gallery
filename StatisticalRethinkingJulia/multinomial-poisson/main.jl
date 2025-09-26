"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/multinomial-poisson.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/multinomial-poisson/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')

    dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
    df.male = [g == "male" ? 1 : 0 for g in df.gender]
    df.dept_id = [dept_map[de] for de in df.dept]
    return df
end

# ## Model

using Turing

@model function m13_2(applications, dept_id, male, admit)
    sigma_dept ~ truncated(Cauchy(0, 2), 0, Inf)
    bm ~ Normal(0, 1)
    a ~ Normal(0, 10)
    a_dept ~ filldist(Normal(a, sigma_dept), 6)

    logit_p = a_dept[dept_id] + bm*male

    admit .~ BinomialLogit.(applications, logit_p)
end

# ## Output

function get_input(_input)
    if _input === nothing
        _data_path = data_path
    else
        _data_path = _input.file
    end
    return read_data(_data_path)
end

function model(_input)
    _input = get_input(_input)
    _model =     m13_2(_input.applications, _input.dept_id, _input.male, _input.admit)
    return _model
end

