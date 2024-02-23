# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(path, DataFrame; delim=';')
df.tank = 1:nrow(df)
df

# ## Model

using Turing

## Thanks to Kai Xu!

@model function m12_2(density, tank, surv)
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    α ~ Normal(0, 1)

    N_tank = length(tank)
    α_tank ~ filldist(Normal(α, σ), N_tank)

    logitp = α_tank[tank]
    surv .~ BinomialLogit.(density, logitp)
end;

# ## Output

function model(_input)
    _input == nothing && (_input = df)
    _model =     m12_2(_input.density, _input.tank, _input.surv)
    return _model
end

