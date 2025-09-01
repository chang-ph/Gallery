# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

file_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')
    return df
end

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

function get_input(_input)
    if _input === nothing
        _data_path = file_path
    else
        _data_path = _input.file
    end
    return read_data(_data_path)
end

function model(_input)
    _input = get_input(_input)
    _model = m10_3(_input.pulled_left, _input.condition, _input.prosoc_left)
    return _model
end

