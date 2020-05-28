function x_proj = project_to_feasible_polytope(x, Aineq, bineq, ...
                                                Aeq, beq, lb, ub)
% PROJECT_TO_LINEAR_CONSTRAINTS - 
%   
    dimension = size(x, 1);
    I = eye(dimension);
    
    x_proj = solve_quadratic_problem(I, -x, 0, Aineq, bineq, Aeq, ...
                                     beq, lb, ub, x);

end

