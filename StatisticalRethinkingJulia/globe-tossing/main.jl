# auto-generated

# ## Data

import Random

Random.seed!(1)

n = 9
k = 6;

# ## Model

using Turing

@model function globe_toss(n, k)
    θ ~ Beta(1, 1)
    k ~ Binomial(n, θ)
    return k, θ
end;

# ## Output

using Random

Random.seed!(1)
function model(_input)
    
    _model = globe_toss(n, k)
    return _model
end

