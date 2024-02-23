# auto-generated

# ## Data

y = [-1,1]

# ## Model

using Turing

@model function m8_3(y)
    α ~ Normal(1, 10)
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    μ = α

    y ~ Normal(μ, σ)
end;

# ## Output

function model(_input)
    
    _model = m8_3(y)
    return _model
end

