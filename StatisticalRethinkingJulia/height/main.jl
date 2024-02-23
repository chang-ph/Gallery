# auto-generated

# ## Data

import CSV

using DataFrames
using Random
using Turing

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')
df = filter(row -> row.age >= 18, df);

# For df, see Section [df](#df).

# ## Model

@model function line(height)
    μ ~ Normal(178, 20)
    σ ~ Uniform(0, 50)

    height ~ Normal(μ, σ)
end

function model(_input)
    _input == nothing && (_input = df)
    _model = line(_input.height)
    return _model
end

