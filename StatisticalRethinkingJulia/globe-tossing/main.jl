"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/globe-tossing
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
    return [9, 6]
end

@model function globe_toss(n, k)
    θ ~ Beta(1, 1)
    k ~ Binomial(n, θ)
    return k, θ
end;

flow.model = globe_toss
