# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

delim = ';'
data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim)

    df.log_pop = log.(df.population)
    df.contact_high = [contact == "high" ? 1 : 0 for contact in df.contact]
    df

    return df
end

# ## Model

using Turing

@model function m10_10stan(total_tools, log_pop, contact_high)
    α ~ Normal(0, 100)
    βp ~ Normal(0, 1)
    βc ~ Normal(0, 1)
    βpc ~ Normal(0, 1)

    for i ∈ 1:length(total_tools)
        λ = exp(α + βp*log_pop[i] + βc*contact_high[i] +
            βpc*contact_high[i]*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
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
    _model =     m10_10stan(_input.total_tools, _input.log_pop, _input.contact_high)
    return _model
end

