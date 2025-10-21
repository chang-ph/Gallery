
# These variables are parsed and used by Coinfer, keep it simple literal assignments
COINFER_EXPERIMENT_NAME = "__EXPERIMENT_NAME__"
COINFER_PARALLEL = 1  # 1..4
COINFER_ENGINE = "fargate"  # fargate/lambda
# arguments to Julia executable:
#   If you use MCMCSerial, you need to add the correct `-t x` where x is the number of threads.
#   If you use MCMCDistributed, you need to add the correct `-p x` where x is the number of processes.
COINFER_JULIA_ARGS = []


using StableRNGs
using AbstractMCMC
using DataFrames
using CSV

function interpret_data(data)
    df = CSV.read(IOBuffer(data), DataFrame; delim=';')
    df = filter(row -> row.age >= 18, df);
    return [df.height]
end

flow = Coinfer.ServerlessBayes.current_workflow()
data = interpret_data(flow.data) # user defined function to interpret input data
m = flow.model(data...)

parallel_algorithm = AbstractMCMC.MCMCSerial()
iteration_count = 1000
num_chains = 1

Coinfer.ServerlessBayes.sample(
    StableRNG(Int(floor(time()))),
    m,
    DynamicPPL.Sampler(NUTS(), m),
    parallel_algorithm,
    iteration_count,
    num_chains;
)
