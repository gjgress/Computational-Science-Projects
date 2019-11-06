module OptModeling

using SparseArrays

export MyModel, Variable, AffineExpression, LinearConstraint, add_variable, add_constraint, construct_constraint_data

mutable struct MyModel
    num_variables::Int
    constraints::Vector
    MyModel() = new(0, Any[])
end

struct Variable
    model::MyModel
    index::Int
end
Base.show(io::IO, x::Variable) = Base.print(io, "Variable($(x.index))")

function add_variable(model::MyModel)
    model.num_variables += 1
    return Variable(model, model.num_variables)
end

struct AffineExpression
    variables::Vector{Variable}
    coeffs::Vector{Float64}
    constant::Float64
    AffineExpression(variables,coeffs,constant) = new(variables,coeffs,constant)
    AffineExpression(var::Variable) = new([var],[1],0)
    AffineExpression(coef::Real, var::Variable) = new([var],[coef],0)
    AffineExpression(aff::AffineExpression) = aff
    AffineExpression(re::Real) = new([],[],re)
end

struct LinearConstraint
    aff_expr::AffineExpression
    lb::Float64
    ub::Float64
end

add_constraint(model::MyModel, constr::LinearConstraint) = push!(model.constraints, constr)

function affs_are_equal(aff1::AffineExpression, aff2::AffineExpression)
    if aff1.constant != aff2.constant
        return false
    end
    idx_to_coeff_1 = Dict{Int,Float64}()
    idx_to_coeff_2 = Dict{Int,Float64}()
    for i in 1:length(aff1.variables)
        idx = aff1.variables[i].index
        init_value = get(idx_to_coeff_1, idx, 0.0)
        idx_to_coeff_1[idx] = init_value + aff1.coeffs[i]
    end
    for i in 1:length(aff2.variables)
        idx = aff2.variables[i].index
        init_value = get(idx_to_coeff_2, idx, 0.0)
        idx_to_coeff_2[idx] = init_value + aff2.coeffs[i]
M
    end
    if keys(idx_to_coeff_1) != keys(idx_to_coeff_2)
        return false
    end
    for v in keys(idx_to_coeff_1)
        if idx_to_coeff_1[v] != idx_to_coeff_2[v]
            return false
        end
    end
    return true
end


import Base: +, -, *, /, <=, ==, >=

################################################################################
# PART A: Implement the following methods

# The purpose of the unions is to shorten the code drastically. Once we have created the method for adding Affines, and can convert arbitrarily Reals, Variables, and Affines into Affines, then we can be blind as to what we are given, to some degree. The process for adding a Variable and a Real is the same as a Variable and a Variable, and so it can be condensed immensely by simply unioning them together. For each union, if we didn't do the union, we would have to implement each addition separately. So if it is a Union of three types, it would be three times as many implementations.

# However, we cannot implement one big union for everything, for a couple of reasons. For one, the program is reliant on other methods. That is, once Affine + Affine is defined, we can rephrase the other methods in terms of it. More problematic, if we do a big union, it would redefine Real + Real, which is already defined in Julia. This is obviously bad, but made worse by the fact that our addition is reliant on Real+Real as given by Julia, and so redefining it would break our methods.

+(x::Real, y::Union{Variable, AffineExpression}) = AffineExpression(x) + AffineExpression(y)

+(x::Variable, y::Union{Real, Variable, AffineExpression}) = AffineExpression(x) + AffineExpression(y)

+(x::AffineExpression, y::Union{Real, Variable}) = AffineExpression(x) + AffineExpression(y)

+(x::AffineExpression, y::AffineExpression) = AffineExpression(vcat(x.variables, y.variables),vcat(x.coeffs, y.coeffs), x.constant + y.constant)

 -(x::Real, y::Union{Variable, AffineExpression}) = AffineExpression(x) - AffineExpression(y)
 -(x::Variable, y::Union{Real, Variable, AffineExpression}) = AffineExpression(x) - AffineExpression(y)
 -(x::AffineExpression, y::Union{Real, Variable}) = AffineExpression(x) - AffineExpression(y)
 -(x::AffineExpression, y::AffineExpression) = AffineExpression(vcat(x.variables, y.variables),vcat(x.coeffs, -1*y.coeffs), x.constant - y.constant)
 *(x::Real, y::Variable) = AffineExpression([y],[x],0)
 *(x::Real, y::AffineExpression) = AffineExpression(y.variables,x*y.coeffs, x*y.constant)
 *(x::Variable, y::Real) = y*x
 *(x::AffineExpression, y::Real) = y*x
 /(x::Union{Variable, AffineExpression}, y::Real) = x * (1/y)

<=(lhs::Real, rhs::Union{Variable, AffineExpression}) = LinearConstraint(lhs-rhs,-Inf,0)
<=(lhs::Variable, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,-Inf,0)
<=(lhs::AffineExpression, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,-Inf,0)
==(lhs::Real, rhs::Union{Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,0)
==(lhs::Variable, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,0)
==(lhs::AffineExpression, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,0)
>=(lhs::Real, rhs::Union{Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,Inf)
>=(lhs::Variable, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,Inf)
>=(lhs::AffineExpression, rhs::Union{Real, Variable, AffineExpression}) = LinearConstraint(lhs-rhs,0,Inf)
################################################################################


################################################################################
# PART B: Implement the following method
function construct_constraint_data(model::MyModel)::Tuple{SparseMatrixCSC{Float64,Int}, Vector{Float64}, Vector{Float64}}

I = []
J = []
V = []
lb = []
ub = []


for i in 1:length(model.constraints)
Constraint = model.constraints[i]
Affine = Constraint.aff_expr

I = vcat(I,i*ones(length(Affine.coeffs)))
for j in 1:length(Affine.variables)
J = vcat(J,Affine.variables[j].index)
end
V = vcat(V,Affine.coeffs)

lb= vcat(lb,Constraint.lb-Affine.constant)
ub= vcat(ub,Constraint.ub-Affine.constant)

end
A = sparse(I,J,V)

return(A,lb,ub)

end

################################################################################

end  # module OptModeling

