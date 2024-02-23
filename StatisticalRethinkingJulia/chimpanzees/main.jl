# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

file_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(file_path, DataFrame; delim=';');

# ## Model

using StatsFuns
using Turing

@model function m10_3(y, x₁, x₂)
    α ~ Normal(0, 10)
    βp ~ Normal(0, 10)
    βpC ~ Normal(0, 10)

    logits = α .+ (βp .+ βpC * x₁) .* x₂
    y .~ BinomialLogit.(1, logits)
end

# ## Output

function model(_input)
    _input == nothing && (_input = df)
    _model = m10_3(_input.pulled_left, _input.condition, _input.prosoc_left)
    return _model
end

