# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')

dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
df.male = [g == "male" ? 1 : 0 for g in df.gender]
df.dept_id = [dept_map[de] for de in df.dept]
df

# ## Model

using Turing

@model function m13_3(applications, dept_id, male, admit)
    Rho ~ LKJ(2, 2.)
    sigma_dept ~ filldist(truncated(Cauchy(0, 2), 0, Inf), 2)
    bm ~ Normal(0, 1)
    a ~ Normal(0, 1)
    
    dist_mu = [a, bm]
    dist_Sigma = sigma_dept .* Rho .* sigma_dept'
    dist_Sigma = (dist_Sigma' + dist_Sigma) / 2
    
    a_bm_dept ~ filldist(MvNormal(dist_mu, dist_Sigma), 6)
    
    a_dept, bm_dept = a_bm_dept[1, :], a_bm_dept[2, :]
    logit_p = a_dept[dept_id] + bm_dept[dept_id] .* male
    
    admit .~ BinomialLogit.(applications, logit_p)
end;

# ## Output

function model(_input)
    _input == nothing && (_input = df)
    _model =     m13_3(_input.applications, _input.dept_id, _input.male, _input.admit)
    return _model
end

