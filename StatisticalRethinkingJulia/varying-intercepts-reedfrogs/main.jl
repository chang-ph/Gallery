# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';');
@assert size(df) == (48, 5) ## hide
df.tank_index = 1:nrow(df)
df

# ## Model

using Turing
using StatsFuns: logistic

@model function reedfrogs(Nᵢ, i, Sᵢ)
    αₜₐₙₖ ~ filldist(Normal(0, 1.5), length(i))
    pᵢ = logistic.(αₜₐₙₖ[i])
    Sᵢ .~ Binomial.(Nᵢ, pᵢ)
end;

# ## Output

n = nrow(df)
function model(_input)
    _input == nothing && (_input = df)
    _model = reedfrogs(_input.density, _input.tank_index, _input.surv)
    return _model
end

