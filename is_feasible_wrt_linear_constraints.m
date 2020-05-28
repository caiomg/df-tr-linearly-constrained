function result = is_feasible_wrt_linear_constraints(x, constraints, tolerances)
% IS_FEASIBLE_WRT_LINEAR_CONSTRAINTS - 
%   
    if nargin < 3 
       tolerances = [];
    end
    
    if isfield(tolerances, 'linear_ineq') && ~isempty(tolerances.linear_ineq)
        tol_linear_ineq = tolerances.linear_ineq;
    else
        tol_linear_ineq = 1e-6;
    end
    if isfield(tolerances, 'linear_eq') && ~isempty(tolerances.linear_eq)
        tol_linear_eq = tolerances.linear_eq;
    else
        tol_linear_eq = 1e-6;
    end
    if isfield(tolerances, 'bounds') && ~isempty(tolerances.bounds)
        tol_bounds = tolerances.bounds;
    else
        tol_bounds = 0;
    end
    [ineq_viol, eq_viol, bounds_viol] = ...
        linear_constraints_violation(x, constraints);
    result = bounds_viol <= tol_bounds ...
             && eq_viol <= tol_linear_eq ...
             && ineq_viol <= tol_linear_ineq;
end
