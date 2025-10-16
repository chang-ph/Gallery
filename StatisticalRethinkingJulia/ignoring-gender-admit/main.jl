"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/ignoring-gender-admit.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/ignoring-gender-admit/data.csv).
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

    dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
    df.male = [g == "male" ? 1 : 0 for g in df.gender]
    df.dept_id = [dept_map[de] for de in df.dept]

    return (df.applications, df.dept_id, df.male, df.admit)
end

@model function m13_4(applications, dept_id, male, admit)
    sigma_dept ~ truncated(Cauchy(0, 2), 0, Inf)
    a ~ Normal(0, 10)
    a_dept ~ filldist(Normal(a, sigma_dept), 6)

    logit_p = a_dept[dept_id]

    admit .~ BinomialLogit.(applications, logit_p)
end;

flow.model = m13_4
