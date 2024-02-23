# auto-generated

# ## Data

import CSV
import Random

using DataFrames
using StatsFuns

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')
first(df, 10)

# ## Model

using Turing

@model function m10_4(y, actors, x₁, x₂)
    ## Number of unique actors in the data set
    N_actor = length(unique(actors))

    ## Set an TArray for the priors/param
    α ~ filldist(Normal(0, 10), N_actor)
    βp ~ Normal(0, 10)
    βpC ~ Normal(0, 10)

    logits = α[actors] .+ (βp .+ βpC * x₁) .* x₂
    y .~ BinomialLogit.(1, logits)
end

function model(_input)
    _input == nothing && (_input = df)
    _model = m10_4(_input.pulled_left, _input.actor, _input.condition, _input.prosoc_left)
    return _model
end

