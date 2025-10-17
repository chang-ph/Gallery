"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/partial-pooling-estimates
"""

using Pkg
Pkg.develop(; path=ARGS[1])  # load Coinfer.jl

using Turing
using Coinfer
using DataFrames
using CSV
using StatsFuns: logistic

flow = Coinfer.ServerlessBayes.current_workflow()

function interpret_data(data)
    μ = 1.4
    σ = 1.5
    nponds = 60
    ni = repeat([5,10,25,35], inner=15)

    a_pond = rand(Normal(μ, σ), nponds)

    dsim = DataFrame(pond = 1:nponds, ni = ni, true_a = a_pond)

    prob = logistic.(dsim.true_a)

    dsim.s = [rand(Binomial(ni[i], prob[i])) for i in 1:nponds]

    dsim.p_nopool = dsim.s ./ dsim.ni;

    return (dsim.pond, dsim.s, dsim.ni)
end

@model function m12_3(pond, s, ni)
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    α ~ Normal(0, 1)

    N_ponds = length(pond)

    α_pond ~ filldist(Normal(α, σ), N_ponds)

    logitp = α_pond[pond]
    s .~ BinomialLogit.(ni, logitp)
end;

flow.model = m12_3
