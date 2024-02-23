# auto-generated

# ## Data

## Outcome and predictor almost perfectly associated.
x = repeat([-1], 9); append!(x, repeat([1],11));
y = repeat([0], 10); append!(y, repeat([1],10));

# ## Model

using Turing

@model function m_good_stan(x, y)
    α ~ Normal(0, 10)
    β ~ Normal(0, 10)

    logits = α .+ β * x

    y .~ BinomialLogit.(1, logits)
end;

# ## Output

function model(_input)
    
    _model = m_good_stan(x, y)
    return _model
end

