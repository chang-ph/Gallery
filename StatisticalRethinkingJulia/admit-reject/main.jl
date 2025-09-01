# auto-generated

# ## Data

import Random

using CSV
using DataFrames
using StatsFuns
using Turing

Random.seed!(1)

file_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame; delim=';')
    return df
end

# ## Model

@model function m_pois(admit, reject)
   α₁ ~ Normal(0,100)
   α₂ ~ Normal(0,100)

   for i ∈ 1:length(admit)
       λₐ = exp(α₁)
       λᵣ = exp(α₂)
       admit[i] ~ Poisson(λₐ)
       reject[i] ~ Poisson(λᵣ)
   end
end;

# ## Output

function get_input(_input)
    if _input === nothing
        _data_path = file_path
    else
        _data_path = _input.file
    end
    return read_data(_data_path)
end

function model(_input)
    _input = get_input(_input)
    _model = m_pois(_input.admit, _input.reject)
    return _model
end

