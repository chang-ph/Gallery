"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/weakly-informative-priors
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
    y = [-1,1]
    return [y]
end

@model function m8_3(y)
    α ~ Normal(1, 10)
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    μ = α

    y ~ Normal(μ, σ)
end;

flow.model = m8_3
