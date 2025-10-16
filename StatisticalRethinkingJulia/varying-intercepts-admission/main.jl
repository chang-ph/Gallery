"""
This model is from https://github.com/vectorly-ai/Gallery/tree/main/StatisticalRethinkingJulia/varying-intercepts-admission.
The data it needs is also in that directory (https://github.com/vectorly-ai/Gallery/blob/main/StatisticalRethinkingJulia/varying-intercepts-admission/data.csv).
If you don't provide any data in the workflow, that data will be used by default.
If you want to provide data, it should be provided in the same format as the default data and attached to the workflow.
"""

using Pkg
Pkg.develop(; path=ARGS[1])  # load Coinfer.jl
Pkg.update("TuringCallbacks")
Pkg.add("Turing")
Pkg.add("CSV")
Pkg.add("DataFrames")

using Coinfer
using DataFrames
using CSV
using Turing

flow = Coinfer.ServerlessBayes.current_workflow()

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')

    dept_map = Dict(key => idx for (idx, key) in enumerate(unique(df.dept)))
    df.male = [g == "male" ? 1 : 0 for g in df.gender]
    df.dept_id = [dept_map[de] for de in df.dept]
    return (df.applications, df.dept_id, df.male, df.admit)
end


@model function m13_3(applications, dept_id, male, admit)
    Rho ~ LKJ(2, 2.)
    sigma_dept ~ filldist(truncated(Cauchy(0, 2), 0, Inf), 2)
    bm ~ Normal(0, 1)
    a ~ Normal(0, 1)

    dist_mu = [a, bm]
    dist_Sigma = sigma_dept .* Rho .* sigma_dept'
    dist_Sigma = (dist_Sigma' + dist_Sigma) / 2

    a_bm_dept ~ filldist(MvNormal(dist_mu, dist_Sigma), 6)

    a_dept, bm_dept = a_bm_dept[1, :], a_bm_dept[2, :]
    logit_p = a_dept[dept_id] + bm_dept[dept_id] .* male

    admit .~ BinomialLogit.(applications, logit_p)
end;

flow.model = m13_3
