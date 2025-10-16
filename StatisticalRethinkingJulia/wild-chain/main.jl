"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/wild-chain
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
    y = [-1, 1]
    return [y]
end

@model function m8_2(y)
    α ~ Flat() ## improper prior with pobability one everywhere
    σ ~ FlatPos(0.0) ## improper prior with probability one everywhere above 0.0

    y ~ Normal(α, σ)
end;

flow.model = m8_2
