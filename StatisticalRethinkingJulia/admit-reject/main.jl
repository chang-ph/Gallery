# auto-generated

# ## Data

import Random

using CSV
using DataFrames
using StatsFuns
using Turing

Random.seed!(1)

file_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(file_path, DataFrame; delim=';')

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

function model(_input)
    _input == nothing && (_input = df)
    _model = m_pois(_input.admit, _input.reject)
    return _model
end

