# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(path, DataFrame; delim=';');

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

function model(_input)
    _input == nothing && (_input = df)
    _model =     m12_5(_input.pulled_left, _input.actor, _input.block, _input.condition, _input.prosoc_left)
    return _model
end

