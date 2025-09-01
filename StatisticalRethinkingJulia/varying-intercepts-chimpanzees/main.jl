# auto-generated

# ## Data

import CSV

using DataFrames

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';');
    return df
end

# ## Model

using Turing

@model function m12_4(pulled_left, actor, condition, prosoc_left)
    ## Total num of y
    N = length(pulled_left)

    ## Separate σ priors for each actor
    σ_actor ~ truncated(Cauchy(0, 1), 0, Inf)

    ## Number of unique actors in the data set
    N_actor = length(unique(actor)) #7

    ## Vector of actors (1,..,7) which we'll set priors on
    α_actor ~ filldist(Normal(0, σ_actor), N_actor)

    ## Prior for intercept, prosoc_left, and the interaction
    α ~ Normal(0, 10)
    βp ~ Normal(0, 10)
    βpC ~ Normal(0, 10)

    logitp = α .+ α_actor[actor] .+
            (βp .+ βpC * condition) .* prosoc_left

    pulled_left .~ BinomialLogit.(1, logitp)
end;

# ## Output

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
    _model =     m12_4(_input.pulled_left, _input.actor, _input.condition, _input.prosoc_left)
    return _model
end

