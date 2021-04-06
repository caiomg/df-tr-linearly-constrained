# df-tr-linearly-constrained

## Introduction

This is an open-source Derivative-Free Trust-Region Algorithm for MATLAB which tackles optimization problems with linear constraints on the variables. Formally, the problems addressed are of the form:
min  f(x)
s.t.:
lb <= x <= ub
Aeq x = beq
Aineq x <= bineq
where f is a black-box function. The algorithm uses the past evaluations of f to build quadratic interpolation models, employed inside the trust-region. The code of this repository also models other functions (such as nonlinear constraints), but their specific use is left to the user.

## Setting up the environment

The algorithm is run from the "trust_region" file in the root directory. Both the following directories contain necessary code for trust-region modeling and must be added to the search path (even if relative to the current working directory):
* tr_modeling
* tr_modeling/polynomials

One also needs to add to the search path one of the following directories with linear and quadratic solvers:
* solver_matlab
* solver_ipopt
* solver_gurobi

## Usage
Provided the directories above are included, the algorithm is used as follows:
[x, fval] = trust_region(funcs, initial_points, initial_fvalues, constraints, options)
where:
* `funcs` is a cell of anonymous functions. Any number of functions may be included. The first will be the objective. The remaining will also be modeled, but the vanilla algorithm will not make further use  of them.
* `initial_points` is a matrix with one or more columns with the initial points. At least one point must be provided.
* `initial_fvalues` is a matrix with the values of the functions (from `funcs`) precomputed in the `initial_points` (may be empty).
* `constraints` is a struct with fields `Aineq`, `bineq`, `Aeq`, `beq`, `lb`, `ub`, defining the constraints of the problem (as above).
* `options` is a struct of algorithmic options:
    * `initial_radius` (default: 1), initial value for the trust-region radius.
    * `radius_max` (default: 1000), maximum trust-region radius allowed
    * `tol_radius` (default: 1e-5), minimum trust-region radius (used as stopping criterion)
    * `eta_0` (default: 0), decrease accepted (requiring models to be Fully Linear)
    * `eta_1` (default: 0.05) decrease for successful iteration (does not depend on model geometry)
    * `eps_c` (default: 1e-5), criticality value which triggers criticality step
    * `gamma_inc` (default: 2), factor for radius increase upon successful iteration
    * `gamma_dec` (default: 0.5) factor for radius decrease on unsuccessful iteration

