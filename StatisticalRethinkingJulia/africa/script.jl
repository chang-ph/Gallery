using StableRNGs
using AbstractMCMC

flow = Coinfer.ServerlessBayes.current_workflow()
m = flow.model(flow.parsed_data...)

parallel_algorithm = eval(flow.settings["sampling_params"]["parallel_algorithm"])
iteration_count = flow.settings["sampling_params"]["iteration_count"]
num_chains = flow.settings["sampling_params"]["num_chains"]

Coinfer.ServerlessBayes.sample(
    StableRNG(Int(floor(time()))),
    m,
    DynamicPPL.Sampler(NUTS(), m),
    parallel_algorithm,
    iteration_count,
    num_chains;
)
