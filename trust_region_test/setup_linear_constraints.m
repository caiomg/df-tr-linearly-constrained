function constraints = setup_linear_constraints(problem)
% SETUP_LINEAR_CONSTRAINTS - 
%   
    BIG_M = 1e18;
    dimension = problem.dim;
    x0 = problem.x0;
    constraints.lb = problem.lb;
    constraints.ub = problem.ub;

    linear_equalities = find(problem.constraint_linear & problem.constraint_equality);
    n_linear_equalities = numel(linear_equalities);
    Aeq = zeros(n_linear_equalities, dimension);
    beq = zeros(n_linear_equalities, 1);
    row = 0;
    for con_n = linear_equalities'
        [g, dg] = problem.evaluate_constraint(x0, con_n);
        row = row + 1;
        Aeq(row, :) = dg';
        beq(row) = problem.con_ub(con_n) - (g - dg'*x0);
    end
    constraints.Aeq = Aeq;
    constraints.beq = beq;

    linear_inequalities = find(problem.constraint_linear & ~problem.constraint_equality);
    n_linear_inequalities = sum(problem.con_lb(linear_inequalities) > - BIG_M)+...
                                sum(problem.con_ub(linear_inequalities) < BIG_M);
    Aineq = zeros(n_linear_inequalities, dimension);
    bineq = zeros(n_linear_inequalities, 1);
    row = 0;
    for con_n = linear_inequalities'
        [g, dg] = problem.evaluate_constraint(x0, con_n);
        if problem.con_ub(con_n) < BIG_M
            row = row + 1;
            Aineq(row, :) = dg';
            bineq(row) = problem.con_ub(con_n) - (g - dg'*x0);
        end
        if problem.con_lb(con_n) > -BIG_M
            row = row + 1;
            Aineq(row, :) = -dg';
            bineq(row) = (g - dg'*x0) - problem.con_lb(con_n);
        end
    end
    constraints.Aineq = Aineq;
    constraints.bineq = bineq;
end

