# auto-generated

# ## Data

import CSV
import Random

using DataFrames
using Statistics: mean

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv") 
df = CSV.read(data_path, DataFrame; delim=';')

df.log_pop = log.(df.population)
df.contact_high = [contact == "high" ? 1 : 0 for contact in df.contact]

# New col where we center(!) the log_pop values
mean_log_pop = mean(df.log_pop)
df.log_pop_c = map(x -> x - mean_log_pop, df.log_pop)
df

# ## Model

using Turing

@model function m10_10stan_c(total_tools, log_pop_c, contact_high)
    α ~ Normal(0, 100)
    βp ~ Normal(0, 1)
    βc ~ Normal(0, 1)
    βpc ~ Normal(0, 1)

    for i ∈ 1:length(total_tools)
        λ = exp(α + βp*log_pop_c[i] + βc*contact_high[i] +
            βpc*contact_high[i]*log_pop_c[i])
        total_tools[i] ~ Poisson(λ)
    end
end;

function model(_input)
    _input == nothing && (_input = df)
    _model =     m10_10stan_c(_input.total_tools, _input.log_pop_c, _input.contact_high)
    return _model
end

