"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/africa.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/africa/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

using Pkg
Pkg.develop(; path=ARGS[1])  # load Coinfer.jl
Pkg.update("TuringCallbacks")

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
    return [df.log_gdp, df.rugged, df.cont_africa]
end

@model function model_fn(y, x₁, x₂)
  σ ~ truncated(Cauchy(0, 2), 0, Inf)
  βAR ~ Normal(0, 10)
  βR ~ Normal(0, 10)
  βA ~ Normal(0, 10)
  α ~ Normal(0, 100)

  μ = α .+ βR * x₁ .+ βA * x₂ .+ βAR * x₁ .* x₂
  y ~ MvNormal(μ, σ)
end

flow.model = model_fn
