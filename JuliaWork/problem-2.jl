module FixedCostTrans

################################################################################
# PART A: Implement the following method
using JuMP
using GLPK

function fixed_cost_transportation(alpha::Real, beta::Real, w::Matrix{Float64}, s::Vector{Float64}, d::Vector{Float64})::Float64

M = length(d)
N = length(s)

model = Model()
@variable(model,x[1:M,1:N] >= 0);
@variable(model, z[1:M], Bin)

for j in 1:N
           @constraint(model, sum(x[i,j] for i in 1:M) == d[j])
end

for i in 1:M
           @constraint(model, sum(x[i,j] for j in 1:N) <= s[i])
end

for i in 1:M
	for j in 1:N
@constraint(model, x[i,j] <= min(s[i],d[j])*z[i])
end
end

func = sum(beta*z[i] + alpha * sum(w[i,j]*x[i,j] for j in 1:N)  for i in 1:M) 

@objective(model, Min, func);

set_optimizer(model,with_optimizer(GLPK.Optimizer))
optimize!(model)

return sum(value.(z)) 

end
################################################################################

end  # module FixedCostTrans

################################################################################
# PART B: Run the following code, using the implementation in PART A
import Random
Random.seed!(123)

M = 10
N = 10

s = rand(M)
d = rand(N)
s *= 1.5 * sum(d) / sum(s)
w = rand(M, N)

using Plots

alphas = 1:20
betas = 0:0.1:1.5
opt_vals = [FixedCostTrans.fixed_cost_transportation(alpha, beta, w, s, d) / M for beta in betas, alpha in alphas]
heatmap(alphas, betas, opt_vals, aspect_ratio=10)
xaxis!("alpha")
yaxis!("beta")

savefig("problem-b-heatmap.png")
################################################################################

