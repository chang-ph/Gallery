# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')
    df.log_pop = log.(df.population)
    df.society = 1:nrow(df)
    return df
end

# ## Model

using Turing

@model function m12_6(total_tools, log_pop, society)
    N = length(total_tools)

    α ~ Normal(0, 10)
    βp ~ Normal(0, 1)

    σ_society ~ truncated(Cauchy(0, 1), 0, Inf)

    N_society = length(unique(society)) ## 10

    α_society ~ filldist(Normal(0, σ_society), N_society)

    for i in 1:N
        λ = exp(α + α_society[society[i]] + βp*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
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
    _model =     m12_6(_input.total_tools, _input.log_pop, _input.society)
    return _model
end

