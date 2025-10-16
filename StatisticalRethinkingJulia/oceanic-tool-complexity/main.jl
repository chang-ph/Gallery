"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/oceanic-tool-complexity.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/oceanic-tool-complexity/data.csv).
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

    df.log_pop = log.(df.population)
    df.contact_high = [contact == "high" ? 1 : 0 for contact in df.contact]

    return (df.total_tools, df.log_pop, df.contact_high)
end

@model function m10_10stan(total_tools, log_pop, contact_high)
    α ~ Normal(0, 100)
    βp ~ Normal(0, 1)
    βc ~ Normal(0, 1)
    βpc ~ Normal(0, 1)

    for i ∈ 1:length(total_tools)
        λ = exp(α + βp*log_pop[i] + βc*contact_high[i] +
            βpc*contact_high[i]*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
end;

flow.model = m10_10stan
