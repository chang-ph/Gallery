# auto-generated

# ## Data

import CSV

using DataFrames
using Random
using Turing

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')
    df = filter(row -> row.age >= 18, df);
    return df
end

# For df, see Section [df](#df).

# ## Model

@model function line(height)
    μ ~ Normal(178, 20)
    σ ~ Uniform(0, 50)

    height ~ Normal(μ, σ)
end

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
    _model = line(_input.height)
    return _model
end

