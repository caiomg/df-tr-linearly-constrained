function x_proj = project_to_feasible_polytope(x, constraints)
% PROJECT_TO_LINEAR_CONSTRAINTS - 
%   
    Aineq = constraints.Aineq;
    bineq = constraints.bineq;
    Aeq = constraints.Aeq;
    beq = constraints.beq;
    lb = constraints.lb;
    ub = constraints.ub;

    if isempty(find(Aineq*x - bineq > 0, 1)) && isempty(find(Aeq*x - beq ~= 0, 1))
        x_proj = min(ub, max(lb, x));
    else
        dim = size(x, 1);
        I = eye(dim);
    
        x_proj = ...
            solve_quadratic_problem(I, -x, 0, Aineq, bineq, Aeq, beq, ...
                                    lb, ub, x);
    end
end

