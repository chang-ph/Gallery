# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

path = joinpath(@__DIR__, "data.csv")

function read_data(path)
    df = CSV.read(path, DataFrame; delim=';')
    df.tank = 1:nrow(df)
    return df
end

# ## Model

using Turing

## Thanks to Kai Xu!

@model function m12_2(density, tank, surv)
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    α ~ Normal(0, 1)

    N_tank = length(tank)
    α_tank ~ filldist(Normal(α, σ), N_tank)

    logitp = α_tank[tank]
    surv .~ BinomialLogit.(density, logitp)
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
    _model =     m12_2(_input.density, _input.tank, _input.surv)
    return _model
end

