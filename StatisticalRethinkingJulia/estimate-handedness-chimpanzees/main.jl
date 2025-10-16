"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/estimate-handedness-chimpanzees.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/estimate-handedness-chimpanzees/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")

using Turing
using Coinfer
using DataFrames
using CSV
using StatsFuns

flow = Coinfer.ServerlessBayes.current_workflow()

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')
    first(df, 10)
    return (df.pulled_left, df.actor, df.condition, df.prosoc_left)
end



@model function m10_4(y, actors, x₁, x₂)
    ## Number of unique actors in the data set
    N_actor = length(unique(actors))

    ## Set an TArray for the priors/param
    α ~ filldist(Normal(0, 10), N_actor)
    βp ~ Normal(0, 10)
    βpC ~ Normal(0, 10)

    logits = α[actors] .+ (βp .+ βpC * x₁) .* x₂
    y .~ BinomialLogit.(1, logits)
end

flow.model = m10_4
