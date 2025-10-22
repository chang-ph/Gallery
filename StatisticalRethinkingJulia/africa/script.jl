using StableRNGs
using AbstractMCMC

flow = Coinfer.ServerlessBayes.current_workflow()
m = flow.model(flow.parsed_data...)

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
