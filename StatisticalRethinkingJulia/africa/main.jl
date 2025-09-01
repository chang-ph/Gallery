# auto-generated

# This is the first Stan model in Statistical Rethinking Edition 1 (page 249).
# In Edition 2 (page 242)

# \toc

# ## Data

import CSV
import Random

using DataFrames
using Turing

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')

    df.log_gdp = log.(df.rgdppc_2000)
    dropmissing!(df)

    df = select(df, :log_gdp, :rugged, :cont_africa);
    return df
end

# DataFrame `df` is shown Section [df](#df).

# ## Model

@model function model_fn(y, x₁, x₂)
  σ ~ truncated(Cauchy(0, 2), 0, Inf)
  βAR ~ Normal(0, 10)
  βR ~ Normal(0, 10)
  βA ~ Normal(0, 10)
  α ~ Normal(0, 100)

  μ = α .+ βR * x₁ .+ βA * x₂ .+ βAR * x₁ .* x₂
  y ~ MvNormal(μ, σ)
end

function get_input(_input)
    if _input === nothing
        @info "using default input"
        _data_path = data_path
    else
        @info "using user input from $(_input.file)"
        _data_path = _input.file
    end
    return read_data(_data_path)
end

function model(_input)
    _input = get_input(_input)
    _model = model_fn(_input.log_gdp, _input.rugged, _input.cont_africa)
    return _model
end

