# auto-generated


# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')

# ## Model

using StatsFuns: logistic
using Turing

@model function m11_5(admit, applications)
  θ ~ truncated(Exponential(1), 0, Inf)
  α ~ Normal(0, 2)

  ## alpha and beta for the BetaBinomial must be provided.
  ## The two parameterizations are related by
  ## alpha = prob * theta, and beta = (1-prob) * theta.
  ## See https://github.com/rmcelreath/rethinking/blob/master/man/dbetabinom.Rd

  prob = logistic(α)
  alpha = prob * θ
  beta = (1 - prob) * θ
  admit .~ BetaBinomial.(applications, alpha, beta)
end

function model(_input)
    _input == nothing && (_input = df)
    _model = m11_5(_input.admit, _input.applications)
    return _model
end

