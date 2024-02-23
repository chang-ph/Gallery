# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')

# ## Model

using Turing

dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
df.male = [g == "male" ? 1 : 0 for g in df.gender]
df.dept_id = [dept_map[de] for de in df.dept]

@model function m13_2(applications, dept_id, male, admit)
    sigma_dept ~ truncated(Cauchy(0, 2), 0, Inf)
    bm ~ Normal(0, 1)
    a ~ Normal(0, 10)
    a_dept ~ filldist(Normal(a, sigma_dept), 6)

    logit_p = a_dept[dept_id] + bm*male

    admit .~ BinomialLogit.(applications, logit_p)
end

function model(_input)
    _input == nothing && (_input = df)
    _model =     m13_2(_input.applications, _input.dept_id, _input.male, _input.admit)
    return _model
end

