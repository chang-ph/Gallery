# auto-generated

# This is model 13.4 from Statistical Rethinking Edition 1.

# \toc

# ## Data

import CSV
import Random

using DataFrames
using Turing

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')

dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
df.male = [g == "male" ? 1 : 0 for g in df.gender]
df.dept_id = [dept_map[de] for de in df.dept]
df

# ## Model

@model function m13_4(applications, dept_id, male, admit)
    sigma_dept ~ truncated(Cauchy(0, 2), 0, Inf)
    a ~ Normal(0, 10)
    a_dept ~ filldist(Normal(a, sigma_dept), 6)
    
    logit_p = a_dept[dept_id]
    
    admit .~ BinomialLogit.(applications, logit_p)
end;

# ## Output

function model(_input)
    _input == nothing && (_input = df)
    _model =     m13_4(_input.applications, _input.dept_id, _input.male, _input.admit)
    return _model
end

