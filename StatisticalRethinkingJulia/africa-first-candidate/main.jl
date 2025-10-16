"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/africa-first-candidate.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/africa-first-candidate/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

using Pkg
Pkg.develop(; path=ARGS[1])  # load Coinfer.jl
Pkg.update("TuringCallbacks")
Pkg.add("Turing")
Pkg.add("CSV")
Pkg.add("DataFrames")

using Turing
using Coinfer
using DataFrames
using CSV

flow = Coinfer.ServerlessBayes.current_workflow()

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')

    df.log_gdp = log.(df.rgdppc_2000)
    dropmissing!(df)

    df = select(df, :log_gdp, :rugged, :cont_africa);

    df.log_gdp_std = df.log_gdp ./ mean(df.log_gdp)
    df.rugged_std = df.rugged ./ maximum(df.rugged)

    first(df, 8)
    return [df.log_gdp_std, df.rugged_std, mean(df.rugged_std)]
end

@model function model_fn(log_gdp_std, rugged_std, mean_rugged)
    α ~ Normal(1, 0.1)
    β ~ Normal(0, 0.3)
    σ ~ Exponential(1)

    μ = α .+ β * (rugged_std .- mean_rugged)
    log_gdp_std ~ MvNormal(μ, σ)
end

flow.model = model_fn
