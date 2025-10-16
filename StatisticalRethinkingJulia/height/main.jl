"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/height.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/height/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

using Pkg
Pkg.develop(; path=ARGS[1])  # load Coinfer.jl
Pkg.update("TuringCallbacks")
Pkg.add("Turing")
Pkg.add("CSV")
Pkg.add("DataFrames")

using Turing
using Coinfer
using DataFrames
using CSV

flow = Coinfer.ServerlessBayes.current_workflow()

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')
    df = filter(row -> row.age >= 18, df);
    return [df.height]
end

@model function line(height)
    μ ~ Normal(178, 20)
    σ ~ Uniform(0, 50)

    height ~ Normal(μ, σ)
end

flow.model = line
