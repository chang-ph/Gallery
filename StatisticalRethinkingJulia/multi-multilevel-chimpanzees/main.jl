"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/multi-multilevel-chimpanzees.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/multi-multilevel-chimpanzees/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

path = joinpath(@__DIR__, "data.csv")

function read_data(path)
    df = CSV.read(path, DataFrame; delim=';');

    return df
end

# ## Model

using Turing

@model function m12_5(pulled_left, actor, block, condition, prosoc_left)
    ## Total num of y
    N = length(pulled_left)

    ## Separate σ priors for each actor and block
    σ_actor ~ truncated(Cauchy(0, 1), 0, Inf)
    σ_block ~ truncated(Cauchy(0, 1), 0, Inf)

    ## Number of unique actors in the data set
    N_actor = length(unique(actor)) ## 7
    N_block = length(unique(block))

    ## Vector of actors (1,..,7) which we'll set priors on
    α_actor ~ filldist(Normal(0, σ_actor), N_actor)
    α_block ~ filldist(Normal(0, σ_block), N_block)

    ## Prior for intercept, prosoc_left, and the interaction
    α ~ Normal(0, 10)
    βp ~ Normal(0, 10)
    βpC ~ Normal(0, 10)

    logitp = α .+ α_actor[actor] + α_block[block] .+
            (βp .+ βpC * condition) .* prosoc_left

    pulled_left .~ BinomialLogit.(1, logitp)
end;

# ## Output

function get_input(_input)
    if _input === nothing
        _data_path = path
    else
        _data_path = _input.file
    end
    return read_data(_data_path)
end

function model(_input)
    _input = get_input(_input)
    _model =     m12_5(_input.pulled_left, _input.actor, _input.block, _input.condition, _input.prosoc_left)
    return _model
end

