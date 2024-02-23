# auto-generated

# ## Data

using DataFrames
using Turing

import CSV

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame)

df.log_gdp = log.(df.rgdppc_2000)
dropmissing!(df)

df = select(df, :log_gdp, :rugged, :cont_africa);

df.log_gdp_std = df.log_gdp ./ mean(df.log_gdp)
df.rugged_std = df.rugged ./ maximum(df.rugged)

first(df, 8)

# ## Model

@model function model_fn(log_gdp_std, rugged_std, mean_rugged)
    α ~ Normal(1, 0.1)
    β ~ Normal(0, 0.3)
    σ ~ Exponential(1)

    μ = α .+ β * (rugged_std .- mean_rugged)
    log_gdp_std ~ MvNormal(μ, σ)
end

function model(_input)
    _input == nothing && (_input = df)
    _model = model_fn(_input.log_gdp, _input.rugged_std, mean(_input.rugged_std))
    return _model
end

