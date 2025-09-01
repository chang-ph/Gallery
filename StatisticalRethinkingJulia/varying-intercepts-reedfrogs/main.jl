# auto-generated

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';');
    @assert size(df) == (48, 5) ## hide
    df.tank_index = 1:nrow(df)
    return df
end

# ## Model

using Turing
using StatsFuns: logistic

@model function reedfrogs(Nᵢ, i, Sᵢ)
    αₜₐₙₖ ~ filldist(Normal(0, 1.5), length(i))
    pᵢ = logistic.(αₜₐₙₖ[i])
    Sᵢ .~ Binomial.(Nᵢ, pᵢ)
end;

# ## Output

n = nrow(df)
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
    _model = reedfrogs(_input.density, _input.tank_index, _input.surv)
    return _model
end

