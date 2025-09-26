"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/estimate-handedness-chimpanzees.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/estimate-handedness-chimpanzees/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

# ## Data

import CSV
import Random

using DataFrames
using StatsFuns

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')
    first(df, 10)
    return df
end


# ## Model

using Turing

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
    _model = m10_4(_input.pulled_left, _input.actor, _input.condition, _input.prosoc_left)
    return _model
end

