"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/varying-slopes-cafe.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/varying-slopes-cafe/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

# ## Data

import CSV
import Random

using DataFrames

Random.seed!(1)

data_path = joinpath(@__DIR__, "data.csv")

function read_data(data_path)
    df = CSV.read(data_path, DataFrame);
    return df
end

# DataFrame `df` is shown Section [df](#df).

# ## Model

using Turing

@model function m13_1(cafe, afternoon, wait)
    Rho ~ LKJ(2, 1.)
    sigma ~ truncated(Cauchy(0, 2), 0, Inf)
    sigma_cafe ~ filldist(truncated(Cauchy(0, 2), 0, Inf), 2)
    a ~ Normal(0, 10)
    b ~ Normal(0, 10)

    dist_mu = [a, b]
    dist_Sigma = sigma_cafe .* Rho .* sigma_cafe'
    dist_Sigma = (dist_Sigma' + dist_Sigma) / 2
    a_b_cafe ~ filldist(MvNormal(dist_mu, dist_Sigma), 20)

    a_cafe = a_b_cafe[1, :]
    b_cafe = a_b_cafe[2, :]

    μ = a_cafe[cafe] + b_cafe[cafe] .* afternoon
    wait ~ MvNormal(μ, sigma)
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
    _model =     m13_1(_input.cafe, _input.afternoon, _input.wait)
    return _model
end

