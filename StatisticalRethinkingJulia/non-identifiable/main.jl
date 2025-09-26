"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/non-identifiable
"""

# ## Data

using Distributions
using Random

Random.seed!(1)
y = rand(Normal(0,1), 100);

# ## Model

using Turing

@model function m8_4(y)
    ## Can't really set a Uniform[-Inf,Inf] on σ 
    α₁ ~ Uniform(-3000, 1000)
    α₂ ~ Uniform(-1000, 3000)
    σ ~ truncated(Cauchy(0,1), 0, Inf)

    y ~ Normal(α₁ + α₂, σ)
end

function model(_input)
    
    _model = m8_4(y)
    return _model
end

